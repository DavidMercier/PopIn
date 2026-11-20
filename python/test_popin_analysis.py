import tempfile
import unittest
from pathlib import Path

import numpy as np
import pandas as pd

from popin_analysis import criterion_values, detect_popins, load_curves, peak_indices, weibull_fit


class PopinAnalysisTests(unittest.TestCase):
    def test_import_crops_at_segment_and_depth_bounds(self):
        rows = [
            ["Segment", "Displacement Into Surface", "Load On Sample"],
            [None, "nm", "mN"],
            ["Load Segment Type", 0, 0],
            [None, 1, 0.1],
            [None, "bad", 0.2],
            ["Hold Segment Type", 2, 0.3],
            ["Unload From Peak Segment Type", 3, 0.4],
        ]
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "curves.xlsx"
            pd.DataFrame(rows).to_excel(path, sheet_name="Test 1", header=False, index=False)
            curves = load_curves(path)
            self.assertEqual(curves["Test 1"]["depth"].tolist(), [0, 1, 2])
            with self.assertRaisesRegex(ValueError, "exactly one"):
                load_curves(path, "missing")
            with self.assertRaisesRegex(ValueError, "fewer than three"):
                load_curves(path, max_depth=2)

    def test_criteria_and_peak_confirmation(self):
        depth = [0, 1, 2, 7, 8, 9]
        load = [0, 1, 2, 3, 4, 5]
        signal, _ = criterion_values(depth, load, 2)
        np.testing.assert_array_equal(signal, [0, 4, -4, 0, 0, 0])
        self.assertEqual(peak_indices(signal, 2), [1])
        self.assertEqual(peak_indices([0, 5, 4], 2), [])
        self.assertEqual(peak_indices([-5, -1, -4], 2), [])
        with self.assertRaisesRegex(ValueError, "non-finite"):
            peak_indices([0, np.inf, 1], 1)

    def test_all_criteria_use_matlab_padded_differences(self):
        depth, load = [0, 1, 3, 6], [0, 1, 5, 14]
        expected = {
            1: [1, 2, 3, 3],
            2: [1, 1, 0, 0],
            3: [0, -1, 0, 0],
            4: [1, 0.5, 1 / 3, 1 / 3],
            5: [-1, -2, -np.inf, -np.inf],
            6: [1, 1, 1, 1],
        }
        for criterion, result in expected.items():
            with self.subTest(criterion=criterion):
                signal, _ = criterion_values(depth, load, criterion)
                np.testing.assert_allclose(signal, result)

    def test_missing_second_event_is_reported(self):
        curves = {"one": pd.DataFrame({"depth": [0, 1, 2, 7, 8, 9], "load": [0, 1, 2, 3, 4, 5]})}
        events = detect_popins(curves, criterion=2, event_number=2)
        self.assertEqual(events.loc[0, "peak_count"], 1)
        self.assertTrue(pd.isna(events.loc[0, "sample_index"]))
        self.assertTrue(pd.isna(events.loc[0, "load"]))

    def test_weibull_positions_and_invalid_values(self):
        values, probability, params = weibull_fit([3, 1, 2])
        np.testing.assert_array_equal(values, [1, 2, 3])
        np.testing.assert_allclose(probability, [1 / 3, 1 / 3 + 1 / 4, 1 / 3 + 1 / 2])
        self.assertTrue(np.all(params > 0))
        with self.assertRaisesRegex(ValueError, "positive"):
            weibull_fit([0, 1])


if __name__ == "__main__":
    unittest.main()
