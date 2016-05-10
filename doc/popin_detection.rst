The 'pop-in' detection
==========================

.. include:: includes.rst

The pop-in detection in the literature
###################################################

In 2001, Malzbender J. et al. proposed to use the derivative :math:`dF/dh^{2}` vs. :math:`h^{2}` of the indentation load-displacement
data for the pop-in detection [#Malzbender_2001]_. Minima on these curves correspond to pop-in on the load-displacement curve.

In his algorithm, Askari H. et al. proposed the following criteria to detect a pop-in [#Askari]_:

    * Absolute change in depth over 2 lines of data i.e.   :math:`\Delta h = h(i) -h(i-1)`
    * Forward 2 pts avg - trailing 2 pts avg. i.e.         :math:`\Delta h = (h(i)+h(i+1))/2 -(h(i-1)+h(i-2))/2`
    * Forward 3 pts avg - trailing 3 pts avg. i.e.         :math:`\Delta h = (h(i)+h(i+1)+h(i+2))/3 -(h(i-1)+h(i-2)+h(i-3))/3`
	
The absolute step size is the difference beteen two (or more in case averaging is active) consecutive depth readings from the machine.
If this step size exceeds a user defined number then it is considered as pop-in.

The pop-in detection in the PopIn Matlab toolbox
###################################################

In the PopIn Matlab toolbox, a pop-in is detected when a peak is identifed on the 22nd derivative of the load-displacement curve.
Peaks anaysis is performed using the function peakdet released by E. Billauer to the public domain (http://www.billauer.co.il/peakdet.html).

References
#############

.. [#Askari] `Pop-in Detection by Askari H. et al. <https://nanohub.org/resources/20804>`_
.. [#Malzbender_2001] `Malzbender J. and de With  G., "The use of the indentation loading curve to detect fracture of coatings" (2001). <http://dx.doi.org/10.1016/S0257-8972(00)01091-4>`_