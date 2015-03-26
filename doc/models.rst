Models for bulk material
==========================

.. include:: includes.rst

The pop-in event
#################################

A schematic of the load-displacement curve obtained from
(load controlled) nanoindentation experiment with a pop-in (or plateau) is given Figure 1.

.. figure:: ./_pictures/load-disp_curve_popin.png
   :scale: 60 %
   :align: center
   
   *Figure 1 : Schematic of indentation load-displacement curve with a pop-in.*

Parameters such as contact load :math:`F_\text{c}` and depth of penetration :math:`h`
are recorded during loading and unloading steps of the indentation test.

Weibull-type distribution
#################################

A Weibull-type distribution is used as a survival probability in this toolbox for
the description of the statistics of the pop-in event [#Weibull_1951]_ and [#Chechenin_1995]_ :

    .. math:: W\left(\frac{F_{cr}}{F^0_{cr}}\right) = exp\left(-ln2\left(\frac{F_{cr}}{F^0_{cr}}\right)^m\right)
            :label: Weibull

:math:`W` is the survival probability function.
:math:`F_{cr}` is the critical load at which the pop-in event appears for a given load-displacement curve.
:math:`F^0_{cr}` is the mean critical load at which the pop-in event appears.
:math:`m` is a material constant, often named the Weibull modulus. Higher is :math:`m`, more homogeneous is 
the distribution of the pop-in.

This Weibull-type distribution is modified to have a probability of 0.5, when :math:`F_{cr}` (the critical load)
is equal to :math:`F^0_{cr}` (the mean critical load).

The same Weibull-type distribution can be used for the critical displacement :math:`h_{cr}`.

References
#############

.. [#Weibull_1951] `Weibull W., "A statistical distribution function of wide applicability", J. Appl. Mech.-Trans. ASME (1951), 18(3). <http://www.barringer1.com/wa_files/Weibull-ASME-Paper-1951.pdf>`_

.. [#Chechenin_1995] `Chechenin N.G., Bøttiger J., Krog J.P., "Nanoindentation of amorphous aluminum oxide films II. Critical parameters for the breakthrough and a membrane effect in thin hard films on soft substrates.", Thin Solid Films (1995), 261(1-2), pp.228-235. <http://dx.doi.org/10.1016/S0040-6090(94)06494-6>`_