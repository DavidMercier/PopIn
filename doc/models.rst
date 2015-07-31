The 'pop-in' phenomenon
==========================

.. include:: includes.rst

Nanoindentation experiment
############################

The nanoindentation (or instrumented or depth sensing indentation) is a variety
of indentation hardness tests applied to small volumes. During nanoindentation,
an indenter is brought into contact with a sample and mechanically loaded.

The following parts give a short overview of models existing in the
literature used for the extraction of mechanical properties of homogeneous 
bulk materials from indentation experiments with conical indenters.

Parameters such as contact load :math:`F_\text{c}` and depth of penetration :math:`h` are recorded
at a rapid rate (normally 10Hz) during loading and unloading steps of the indentation test.
Usually, the depth resolution is around the fraction of :math:`\text{nm}`-level and the resolution is around :math:`\text{nN}`-level.

During the loading step of nanoindentation, a discontinuity in the measured depth is commonly referred to as a pop-in event.

The pop-in event
###################

A pop-in (event) is a sudden (load or displacement) burst during the loading of an indenter on a sample.
If the nanoindentation experiment is load-controlled, an horizontal plateau is also observed on the 
load-displacement curve, when a pop-in occurs at the critical load :math:`F_\text{crit}` and
critical displacement :math:`h_\text{crit}` (see Figure 1). In the case of a displacement-controlled
nanoindentation experiments, a vertical drop of the load is observed on the load-displacement curve.

.. figure:: ./_pictures/load-disp_curve_popin.png
   :scale: 60 %
   :align: center
   
   *Figure 1 : Schematics of indentation load-displacement curve with a pop-in: a) load-controlled and b) displacement-controlled nanoindentation experiments.*

:math:`F_\text{c,max}` is the maximum applied load, :math:`h_\text{t}` is the total indentation depth and
:math:`h_\text{r}` is the residual indentation depth.

.. warning::
    In this toolbox, only load-controlled nanoindentation experiments are analyzed.

Many authors observed pop-in events on metals or metallic thin films, ceramics, semiconductors, hard brittle thin films deposited on a soft elastoplastic substrate...

The pop-in event is often explained by on of the following mechanisms in function of the indented specimen (ceramic, metal, semiconductor, coated or multilayer specimen...)
and the experimental conditions (time, temperature, geometry of the indenter...) :

    * dislocations nucleation (= sudden yielding of a material under load) ;
    * rupture of a hard brittle film on an elastic-plastic substrate ;
    * crack(s) formation ; 
    * phase transformation ;
    * strain transfer across a grain boundary.

Some authors proposed to describe the statistics of the pop-in event with a cumulative Weibull-type distribution [#Chechenin_1995]_ or with a cumulative fraction function based on a rate equation, when a time or a temperature dependence of the pop-in is demonstrated.

Pop-in detection
#################################

Find here the |matlab| function to quantify pop-in by peak detection:
`peakdet.m <https://github.com/DavidMercier/PopIn/blob/master/Matlab_code/statistics/peakdet.m>`_.

Weibull-type distribution
#################################

The cumulative Weibull distribution function with 2 parameters :math:`(\lambda, m)` is a continuous probability distribution
and is often used to describe particle size distributions and in survival or failure analysis [#Weibull_1951]_.

    .. math:: V\left(x, \lambda, m\right) = exp\left(\left(\frac{x}{\lambda}\right)^m\right)
            :label: Weibull_mortality

    .. math:: W\left(x, \lambda, m\right) = 1 - exp\left(\left(\frac{x}{\lambda}\right)^m\right)
            :label: Weibull_survival

With :math:`V` the mortal probability function and :math:`W` the survival probability function.
:math:`m` is a dimensionless material-dependent constant, often named the Weibull modulus (from 0 to usually 50) [#Afferante_2006]_.
If :math:`m=1`, the rate of failure remains constant and there is random failure occurring.

In the case of several indentations performed on the same sample,
:math:`x` can be the distribution of the critical loads :math:`F_\text{crit}` or the critical displacements :math:`h_\text{crit}`,
at which the pop-in events appear on the corresponding load-displacement curves. In this case, 
higher is :math:`m`, more homogeneous is the distribution of the pop-in.

:math:`\lambda` is the scale parameter of the cumulative Weibull distribution.
In the case of indentations, :math:`\lambda` is the mean critical load :math:`F^0_{crit}` or
the mean critical displacement :math:`h^0_{crit}` at which the pop-in event appears for a given material.

Find here the |matlab| function to calculate the cumulative survival Weibull distribution:
`Weibull_cdf.m <https://github.com/DavidMercier/PopIn/blob/master/Matlab_code/statistics/Weibull/Weibull_cdf.m>`_.

Chechenin et al. proposed to use a modified cumulative Weibull distribution function for
the description of the statistics of the pop-in event [#Chechenin_1995]_.
This function is set to have a probability of 0.5, when :math:`F_{crit}` (the critical load)
is equal to :math:`F^0_{crit}` (the mean critical load).

    .. math:: W\left(\frac{F_\text{crit}}{F^0_\text{crit}}\right) = 1 - exp\left(-ln2\left(\frac{F_\text{crit}}{F^0_\text{crit}}\right)^m\right)
            :label: Weibull_modified

The cumulative Weibull distribution [#Weibull_1951]_ and the modified cumulative Weibull distribution [#Chechenin_1995]_
are implemented in the PopIn toolbox.

Find here the |matlab| function to calculate the cumulative modified survival Weibull distribution:
`Weibull_modified_cdf.m <https://github.com/DavidMercier/PopIn/blob/master/Matlab_code/statistics/Weibull/Weibull_modified_cdf.m>`_.

Rupture of a hard brittle film on an elastic-plastic substrate
################################################################

[#Bahr_2003]_

    .. math:: F_\text{crit,s} = Kh_\text{crit}^n
            :label: critical_load_substrate

With :math:`F_\text{crit,s}`   and :math:`K` :math:`n`

    .. math:: c = \sqrt{\frac{3F_\text{crit,s}}{2\pi\sigma_\text{e}}}
            :label: plastic_zone_radius

.. figure:: ./_pictures/popin_mechanisms_2.png
   :scale: 20 %
   :align: center

   *Figure 2 : Schematic cross section of deformation profile of a hard brittle film on an elastic-plastic substrate under indentation.*

With :math:`\sigma_\text{e}` the yield stress of the metallic substrate.

Statistical investigation of the onset of plasticity
######################################################

[#Schuh_2004]_ 
[#Schuh_2005]_
[#Schuh_2006]_
[#Mason_2006]_
[#Wo_2006]_
[#Morris_2011]_
[#Lu_2012]_
[#Ramalingam_2012]_
[#Wu_2014_1]_
[#Wu_2014_2]_


==> time / rate dependence and temperature dependence of incipient plasticity


.. figure:: ./_pictures/load-disp_curve_two_popin_Hertzian_fit.png
   :scale: 60 %
   :align: center
   
   *Figure 3 : Schematic of indentation load-displacement curve with two pop-in events (the 1st for the nucleation of dislocation and the 2nd for the strain transfer across a grain boundary).*

.. figure:: ./_pictures/popin_mechanisms_1.png
   :scale: 20 %
   :align: center

   *Figure 4 : Schematics cross section of deformation profile of an elastic-plastic substrate under indentation : 1) elastic deformation, 2) elastoplastic deformation (nucleation of dislocation) and 3) transfer of dislocations across a grain boundary.*

    .. math:: \dot{n} = \eta exp\left(-\frac{\epsilon-\sigma V}{kT}\right)
            :label: rate_equation
            
    .. math:: \dot{N} = \eta exp\left(-\frac{\epsilon}{kT}\right)\cdot\int\int\limits_\Omega\int exp \left(\frac{\sigma V}{kT}\right)d\Omega
            :label: global_rate_equation

    .. math:: \dot{F}(t) = \left[1-F(t)\right]{N}(t)
            :label: cumulative fraction function
            
    .. math:: F(t) = 1- exp\left(-\int_{0}^{t}{\dot{N}(t')dt'}\right)
            :label: integrated_cumulative fraction function

    .. math:: \tau_\text{max} = 0.31p_0 = 0.47p_\text{max} = \left(\frac{0.47}{\pi}\right)\left(\frac{4E^{*}}{3R^{*}}\right)F^{1/3}_{crit}
            :label: max_Hertzian_shearStress

With :math:`\tau_\text{max}` the maximun shear stress at a single point beneath the indenter given for an elastic Hertzian contact [#Johnson_1987]_.

Find here the |matlab| function to calculate the maximum shear stress:
`maxShearStress.m <https://github.com/DavidMercier/PopIn/blob/master/Matlab_code/elastic_contact/maxShearStress.m>`_.

Find here the |matlab| function to calculate the maximum pressure:
`maxPressure.m <https://github.com/DavidMercier/PopIn/blob/master/Matlab_code/elastic_contact/maxPressure.m>`_.

Find here the |matlab| function to calculate the mean pressure:
`meanPressure.m <https://github.com/DavidMercier/PopIn/blob/master/Matlab_code/elastic_contact/meanPressure.m>`_.

    .. math:: \frac{1}{E^{*}} = \frac{1}{E_\text{s}^{'}} + \frac{1}{E_\text{i}^{'}}
            :label: reduced_youngs_modulus

With :math:`E_\text{s}^{'}` the reduced Young's modulus of the sample and :math:`E_\text{i}^{'}` the reduced Young's modulus of the indenter.

    .. math:: \frac{1}{R^{*}} = \frac{1}{R_\text{s}} + \frac{1}{R_\text{i}}
            :label: reduced_radius

With :math:`R_\text{s}` the radius of the sample (usually :math:`+\infty`) and :math:`R_\text{i}` the radius of the indenter.

Find here the |matlab| function to calculate the reduced value of a variable:
`reducedValue.m <https://github.com/DavidMercier/PopIn/blob/master/Matlab_code/elastic_contact/reducedValue.m>`_.

    .. math:: \Omega \approx Ka^3 = K\left(\frac{3F_{crit}R^{*}}{4E^{*}}\right)
            :label: sampling_volume
            
    .. math:: F_\text{c} = \dot{F_\text{c}}\cdot t
            :label: loadrate
            
    .. math:: W(F_\text{c}) = 1-exp\left(-\frac{9KR^{*}\eta}{4E^{*}\dot{F_\text{c}}\alpha^6}exp\left(-\frac{\epsilon}{kT}\right)\left(\beta(\alpha,F_\text{c}\right)\right)
            :label: first_order_analytical_solution
            
    .. math:: \alpha = \left(\frac{0.47}{\pi}\right)\left(\frac{4E^{*}}{3R^{*}}\right)^{2/3}\frac{V}{kT}
            :label: alpha_function
            
    .. math:: \beta = \left(120+exp(F_\text{c}^{1/3}\alpha))\cdot\left(F_\text{c}^{5/3}\alpha^5 - 5F_\text{c}^{4/3}\alpha^4 + 20F_\text{c}\alpha^3-60F_\text{c}^{2/3}\alpha^2+120F_\text{c}^{1/3}\alpha-120\right)\right)
            :label: beta_function

Find here the |matlab| function to calculate the cumulative survival distribution in function of the loadrate and the temperature of nanoindentation tests:
`Mason_cdf.m <https://github.com/DavidMercier/PopIn/blob/master/Matlab_code/statistics/Mason/Mason_cdf.m>`_.

Find here the |matlab| function to calculate the :math:`\alpha` function:
`alphaMason.m <https://github.com/DavidMercier/PopIn/blob/master/Matlab_code/statistics/Mason/alphaMason.m>`_.

Find here the |matlab| function to calculate the :math:`\beta` function:
`betaMason.m <https://github.com/DavidMercier/PopIn/blob/master/Matlab_code/statistics/Mason/betaMason.m>`_.

Strain transfer across grain boundaries in metals
####################################################

Some authors observed sometimes two pop-in on the load-displacement curve during indentation performed close to a grain boundary (see Figure 3 and Figure 4).
The first pop-in is usually attributed to the nucleation of dislocation in a metallic material (see previous section of this documentation),
and the second pop-in is related to the presence nearby of the grain boundary.
 
The occurrence of such a strain burst is found to be related to the slip activity (function of the phase material and the grain orientation),
to the grain boundary resistance (function of the grain boundary misorientation [#Wang_2004]_, 
to the local chemistry [#Britton_2011]_ (impurities, embrittled hydrogen...), to the prior plastic deformation [#Britton_2011]_, to
the distance between the indenter and the grain boundary [#Wang_2004]_, or other experimental parameters like the shape of the indenter and the grain boundary inclination...

Recently, the STABiX Matlab toolbox was developed to analyse in simple way slip transmission in a bicrystal [#Mercier_2015]_ and [#Stabix_2015]_.

Matlab functions to fit probability distributions
###################################################

* `disttool - Interactive density and distribution plots <http://de.mathworks.com/help/stats/disttool.html>`_
* `fitdist - Fit probability distribution object to data <http://de.mathworks.com/help/stats/fitdist.html>`_
* `dfittool - Open Distribution Fitting app <http://de.mathworks.com/help/stats/dfittool.html>`_

References
#############

.. [#Afferante_2006] `Afferante L. et al., "Is Weibull’s modulus really a material constant? Example case with interacting collinear cracks" (2006). <http://dx.doi.org/10.1016/j.ijsolstr.2005.08.002>`_
.. [#Bahr_2003] `Bahr D.F. et al., "Non-linear deformation mechanisms during nanoindentation" (1998). <http://dx.doi.org/10.1016/S1359-6454(98)00024-X>`_
.. [#Britton_2011] `Britton T.B. et al., "Nanoindentation study of slip transfer phenomenon at grain boundaries" (2011). <http://dx.doi.org/10.1557/jmr.2009.0088>`_
.. [#Chechenin_1995] `Chechenin N.G. et al., "Nanoindentation of amorphous aluminum oxide films II. Critical parameters for the breakthrough and a membrane effect in thin hard films on soft substrates." (1995). <http://dx.doi.org/10.1016/S0040-6090(94)06494-6>`_
.. [#Johnson_1987] `Johnson K.L., "Contact Mechanics" (1987). <http://www.cambridge.org/us/academic/subjects/engineering/solid-mechanics-and-materials/contact-mechanics>`_
.. [#Lu_2012] `Lu J.-Y. et al. "Thermally activated pop-in and indentation size effects in GaN films" (2012). <http://dx.doi.org/10.1088/0022-3727/45/8/085301>`_
.. [#Mason_2006] `Mason J. et al., "Determining the activation energy and volume for the onset of plasticity during nanoindentation" (2006). <http://dx.doi.org/10.1103/PhysRevB.73.054102>`_
.. [#Mercier_2015] `Mercier D. et al. "A Matlab toolbox to analyze slip transfer through grain boundaries" (2015). <http://dx.doi.org/10.1088/1757-899X/82/1/012090>`_
.. [#Morris_2011] `Morris J.R. et al., "Size Effects and Stochastic Behavior of Nanoindentation Pop In" (2011). <http://dx.doi.org/10.1103/PhysRevLett.106.165502>`_
.. [#Ramalingam_2012] `Ramalingam S. et al. "Determining Activation Volume for the Pressure-Induced Phase Transformation in β-Eucryptite Through Nanoindentation" (2012). <http://dx.doi.org/10.1111/j.1551-2916.2012.05180.x>`_
.. [#Schuh_2004] `Schuh C.A. and Lund A.C., "Application of nucleation theory to the rate dependence of incipient plasticity during nanoindentation" (2004). <http://dx.doi.org/10.1557/JMR.2004.0276>`_
.. [#Schuh_2005] `Schuh C.A. et al., "Quantitative insight into dislocation nucleation from high-temperature nanoindentation experiments" (2005). <http://dx.doi.org/10.1038/nmat1429>`_
.. [#Schuh_2006] `Schuh C.A., "Nanoindentation studies of materials" (2006). <http://dx.doi.org/10.1016/S1369-7021(06)71495-X>`_
.. [#Stabix_2015] `STABiX toolbox <http://stabix.readthedocs.org/en/latest/>`_
.. [#Wang_2004] `Wang M.G. and Ngan A.H.W., "Indentation strain burst phenomenon induced by grain boundaries in niobium" (2004). <http://dx.doi.org/10.1557/JMR.2004.0316>`_
.. [#Weibull_1951] `Weibull W., "A statistical distribution function of wide applicability", J. Appl. Mech.-Trans. ASME (1951), 18(3). <http://www.barringer1.com/wa_files/Weibull-ASME-Paper-1951.pdf>`_
.. [#Wo_2006] `Wo P.C. et al., "Time-dependent incipient plasticity in Ni3Al as observed in nanoindentation" (2006). <http://dx.doi.org/10.1557/JMR.2005.0056>`_
.. [#Wu_2014_1] `Wu D. et al., "Effect of tip radius on the incipient plasticity of chromium studied by nanoindentation" (2014). <http://dx.doi.org/10.1016/j.scriptamat.2014.09.017>`_
.. [#Wu_2014_2] `Wu D. and Nieh T.G., "Incipient plasticity and dislocation nucleation in body-centered cubic chromium" (2014). <http://dx.doi.org/10.1016/j.msea.2014.04.107>`_