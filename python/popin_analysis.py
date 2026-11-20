"""Load MTS indentation curves and analyze their pop-in distributions."""

from pathlib import Path
import warnings

import numpy as np
import pandas as pd
from scipy.optimize import least_squares


def load_curves(path, end_segment="Hold Segment Type", min_depth=None, max_depth=None):
    """Read each worksheet through the chosen segment, then crop finite samples."""
    if min_depth is not None and not np.isfinite(min_depth):
        raise ValueError("min_depth must be finite or None")
    if max_depth is not None and not np.isfinite(max_depth):
        raise ValueError("max_depth must be finite or None")
    if min_depth is not None and max_depth is not None and min_depth >= max_depth:
        raise ValueError("min_depth must be less than max_depth")

    curves = {}
    with pd.ExcelFile(Path(path)) as workbook:
        for sheet in workbook.sheet_names:
            raw = pd.read_excel(workbook, sheet_name=sheet, header=None)
            if raw.empty:
                warnings.warn(f"Skipping empty worksheet {sheet!r}", stacklevel=2)
                continue
            if (raw.shape[0] < 3 or raw.shape[1] < 3
                    or not str(raw.iat[0, 1]).lower().startswith("displacement")
                    or not str(raw.iat[0, 2]).lower().startswith("load")):
                raise ValueError(f"Worksheet {sheet!r} must have Segment, Displacement and Load columns and two header rows")
            segments = raw.iloc[2:, 0].astype("string")
            matches = np.flatnonzero(segments.eq(end_segment).fillna(False).to_numpy())
            if len(matches) != 1:
                raise ValueError(f"Worksheet {sheet!r} must contain exactly one {end_segment!r} marker; found {len(matches)}")
            marker_row = matches[0] + 2
            samples = raw.iloc[2:marker_row + 1, 1:3].apply(pd.to_numeric, errors="coerce")
            samples.columns = ["depth", "load"]
            samples = samples[np.isfinite(samples).all(axis=1)]
            if min_depth is not None:
                samples = samples[samples["depth"] >= min_depth]
            if max_depth is not None:
                samples = samples[samples["depth"] < max_depth]
            if len(samples) < 3:
                raise ValueError(f"Worksheet {sheet!r} has fewer than three finite samples in the selected range")
            curves[sheet] = samples.reset_index(drop=True)
    if not curves:
        raise ValueError("The workbook contains no usable worksheets")
    return curves


def criterion_values(depth, load, criterion):
    """Return MATLAB's padded criterion and the data used to choose delta."""
    depth = np.asarray(depth, dtype=float)
    load = np.asarray(load, dtype=float)
    if depth.ndim != 1 or load.shape != depth.shape or len(depth) < 3:
        raise ValueError("depth and load must be matching 1-D arrays of at least three samples")
    if not np.isfinite(depth).all() or not np.isfinite(load).all():
        raise ValueError("depth and load must be finite")
    if criterion not in range(1, 7):
        raise ValueError("criterion must be an integer from 1 to 6")

    def padded_diff(values):
        diff = np.diff(values)
        return np.append(diff, diff[-1])

    dh = padded_diff(depth)
    dl = padded_diff(load)
    if criterion <= 3:
        data = dh
        for _ in range(criterion - 1):
            data = padded_diff(data)
        return data, data
    with np.errstate(divide="ignore", invalid="ignore"):
        if criterion == 4:
            data = 1 / (dl / dh)
            return data, data
        if criterion == 5:
            data = padded_diff(dl / dh) / dh
            return -1 / data, data
        data = dl / (dh * dh)
        return data, data


def peak_indices(values, delta):
    """Return positive maxima confirmed by a subsequent drop greater than delta."""
    if not np.isfinite(delta) or delta <= 0:
        raise ValueError("delta must be positive and finite")
    peaks = []
    maximum, minimum = -np.inf, np.inf
    maximum_index = None
    look_for_maximum = True
    for index, value in enumerate(values):
        if not np.isfinite(value):
            raise ValueError("The detection criterion contains non-finite values; choose another criterion or crop the data")
        if value > maximum:
            maximum, maximum_index = value, index
        if value < minimum:
            minimum = value
        if look_for_maximum and value < maximum - delta:
            if maximum > 0:
                peaks.append(maximum_index)
            minimum = value
            look_for_maximum = False
        elif not look_for_maximum and value > minimum + delta:
            maximum, maximum_index = value, index
            look_for_maximum = True
    return peaks


def detect_popins(curves, criterion=2, delta_mean_factor=2, event_number=1):
    """Detect peaks per curve; report missing requested events instead of inventing one."""
    if event_number not in (1, 2):
        raise ValueError("event_number must be 1 or 2")
    if delta_mean_factor not in (0, 0.5, 1, 2):
        raise ValueError("delta_mean_factor must be 0, 0.5, 1 or 2")
    rows = []
    for name, curve in curves.items():
        signal, delta_data = criterion_values(curve["depth"], curve["load"], criterion)
        if not np.isfinite(delta_data).all():
            raise ValueError(f"Worksheet {name!r}: criterion contains non-finite values")
        delta = np.max(delta_data) - delta_mean_factor * np.mean(delta_data)
        try:
            peaks = peak_indices(signal, delta)
        except ValueError as exc:
            raise ValueError(f"Worksheet {name!r}: {exc}") from exc
        index = peaks[event_number - 1] if len(peaks) >= event_number else None
        rows.append({
            "sheet": name, "peak_count": len(peaks), "delta": delta,
            "sample_index": index,
            "depth": curve["depth"].iloc[index] if index is not None else np.nan,
            "load": curve["load"].iloc[index] if index is not None else np.nan,
        })
    return pd.DataFrame(rows)


def weibull_fit(values):
    """Fit the MATLAB Weibull CDF to its empirical plotting positions."""
    values = np.sort(np.asarray(values, dtype=float))
    if values.ndim != 1 or len(values) < 2 or not np.isfinite(values).all() or np.any(values <= 0):
        raise ValueError("Weibull fitting requires at least two finite, positive event values")
    n = len(values)
    probabilities = 1 / n + np.arange(n) / (n + 1)

    def cdf(x, shape, scale):
        return -np.expm1(-(x / scale) ** shape)

    result = least_squares(
        lambda params: cdf(values, *params) - probabilities,
        x0=[1.0, np.mean(values)],
        bounds=([1e-8, 1e-12], [1000, np.max(values)]),
    )
    if not result.success:
        raise RuntimeError(f"Weibull fit failed: {result.message}")
    return values, probabilities, result.x
