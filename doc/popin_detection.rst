The 'pop-in' detection
==========================

.. include:: includes.rst

The pop-in detection in the literature
###################################################

In 2001, Malzbender J. et al. proposed to use the derivative :math:`dF/dh^{2}` vs. :math:`h^{2}` of the indentation load-displacement data for the pop-in detection [#Malzbender_2001]_. Minima on these curves correspond to pop-in on the load-displacement curve.

In 2004, Juliano T. et al. proposed to extract numerically the derivative behavior from  the  loading  and  unloading portions of the load-displacement curves [#Juliano_2004]_. The numerical first derivative at a depth :math:`h_\text{x}` was taken to be the slope of the least-squares fit between load-displacement data points and given as:

    .. math:: {\left(\frac{dF}{dh}\right)}_{\text{h}_\text{x}} = \frac{y\left(\sum_{F_{\text{x-(y-1)/2}},h_{\text{x-(y-1)/2}}}^{F_{\text{x+(y-1)/2}},h_{\text{x+(y-1)/2}}}{Fh}\right)-\left(\sum_{h_{\text{x-(y-1)/2}}}^{h_{\text{x+(y-1)/2}}}{h}\right)-\left(\sum_{F_{\text{x-(y-1)/2}}}^{F_{\text{x+(y-1)/2}}}{F}\right)}{y\left(\sum_{h_{\text{x-(y-1)/2}}}^{h_{\text{x+(y-1)/2}}}{h^2}\right)-\left(\sum_{h_{\text{x-(y-1)/2}}}^{h_{\text{x+(y-1)/2}}}{h}\right)}
            :label: Juliano_numerical_first_derivative

with :math:`x` the data points number and :math:`y` a positive odd integer number of data points considered.

Juliano T. et al. proposed also to take the derivative at a depth :math:`h_\text{x}`:

    .. math:: {\left(\frac{dF}{dh}\right)}_{\text{h}_\text{x}} = \frac{F_{\text{x+(y-1)/2}}-F_{\text{x-(y-1)/2}}}{h_{\text{x+(y-1)/2}}-h_{\text{x-(y-1)/2}}}
            :label: Juliano_first_derivative
	    
In 2014, Askari H. et al. developed the following criteria in his algorithm, to detect a pop-in [#Askari]_:

    * Absolute change in depth over 2 lines of data: :math:`\Delta h = h(i) - h(i-1)`
    * Forward 2 pts avg - trailing 2 pts average: :math:`\Delta h = (h(i)+h(i+1))/2 - (h(i-1)+h(i-2))/2`
    * Forward 3 pts avg - trailing 3 pts average: :math:`\Delta h = (h(i)+h(i+1)+h(i+2))/3 - (h(i-1)+h(i-2)+h(i-3))/3`
	
The absolute step size is the difference beteen two (or more in case averaging is active) consecutive depth readings from the machine. If this step size exceeds a user defined number then it is considered as pop-in.

In her PhD thesis, G. Nayyeri proposed to use the the first derivative at a depth :math:`h = h_0` of the load-dispalcement curve, to detect a pop-in [#Nayyeri_2016]_:

    .. math:: {\left(\frac{dF}{dh}\right)}_{\text{h}_{0}} = {F_{{\text{h}_{0}}+\Delta \text{h}} - F_{\text{h}_{0}} \over \Delta h}
            :label: Nayyeri_first_derivative

The pop-in detection in the PopIn Matlab toolbox
###################################################

In the PopIn Matlab toolbox, numerous criteria based on the function `diff <http://nl.mathworks.com/help/matlab/ref/diff.html>`_, are implemented to detect pop-in on the load-displacement curve:

    * Criterion 1 - Differences between adjacent depths: :math:`\Delta h = diff(h) = h(i+1) - h(i)`
    * Criterion 2 - 2nd differences between adjacent elements (the diff operator is used 2 times): :math:`\Delta h = diff(diff(h)) = diff(h,2)`
    * Criterion 3 - 3rd differences between adjacent elements (the diff operator is used 3 times): :math:`\Delta h = diff(diff(diff(h))) = diff(h,3)`
    * Criterion 4 - 1st derivative of the load-displacement curve: :math:`1/(dF/dh) = 1/(diff(F)/diff(h))`
    * Criterion 5 - 2nd derivative of the load-displacement curve: :math:`-1/(d^{2}F/dh^{2}) = -1/(diff(dF/dh)/diff(h))`
    * Criterion 6 - Derivative of the load-displacement curve: :math:`(dF/dh^{2}) = ((diff(F)/diff(h))/diff(h))`

The 6th criterion is based on the one proposed by Malzbender et al. [#Malzbender_2001]_.
Malzbender proposed to plot the 6th criterion as a function of :math:`h^{2}` and not as a function of :math:`h`, like it is proposed in the PopIn toolbox.

When a pop-in occurs, a peak is observed on the plot of differences or derivatives.
Peaks anaysis is performed using the function `peakdet <https://github.com/DavidMercier/PopIn/blob/master/third_party_codes/peakdet.m>`_ released by E. Billauer to the public domain (http://www.billauer.co.il/peakdet.html). Only positive peaks are counted. A point is considered a maximum peak if it has the maximal value, and was preceded (to the left) by a value lower by a given delta. The delta value can be set by user from the GUI.

Plots of the different criteria normalized by its maximum as a function of normalized indentation displacement (:math:`h/max(h)`).

.. figure:: ./_pictures/load-disp_curve_popin_exp.png
   :scale: 75 %
   :align: center
   
   *Plot of an experimental load-displacement curve displaying a pop-in.*

.. figure:: ./_pictures/load-disp_curve_popin_diff1.png
   :scale: 75 %
   :align: center
   
   *Plot of the normalized 1st criterion.*

.. figure:: ./_pictures/load-disp_curve_popin_diff2.png
   :scale: 75 %
   :align: center
   
   *Plot of the normalized 2nd criterion.*

.. figure:: ./_pictures/load-disp_curve_popin_diff3.png
   :scale: 75 %
   :align: center
   
   *Plot of the normalized 3rd criterion.*
   
.. figure:: ./_pictures/load-disp_curve_popin_dfdh.png
   :scale: 75 %
   :align: center
   
   *Plot of the normalized 4th criterion.*
   
.. figure:: ./_pictures/load-disp_curve_popin_d2fdh2.png
   :scale: 75 %
   :align: center
   
   *Plot of the normalized 5th criterion.*
   
.. figure:: ./_pictures/load-disp_curve_popin_dfdh2.png
   :scale: 75 %
   :align: center
   
   *Plot of the normalized 6th criterion.*

References
#############

.. [#Askari] `Pop-in Detection by Askari H. et al. (2014) <https://nanohub.org/resources/20804>`_
.. [#Juliano_2004] `Juliano T. et al., "Numerical derivative analysis of load-displacement curves in depth-sensing indentation" (2004). <https://doi.org/10.1557/PROC-791-Q7.5>`_
.. [#Malzbender_2001] `Malzbender J. and de With  G., "The use of the indentation loading curve to detect fracture of coatings" (2001). <https://doi.org/10.1016/S0257-8972(00)01091-4>`_
.. [#Nayyeri_2016] Nayyeri G., "Examination of deformation in magnesium using instrumented spherical indentation", University of British Columbia, PhD thesis (2016).
