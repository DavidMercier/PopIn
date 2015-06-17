Statistical models
======================

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
Usually, the depth resolution is around the fraction of :math:`\text{nm}`-level and the load resolution is around :math:`\text{nN}`-level.

During the loading step of nanoindentation, a discontinuity in the measured depth is commonly referred to as a pop-in event.

The pop-in event
###################

A pop-in (event) is a sudden displacement burst during the loading of an indenter on a sample.
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
    In this toolbox, only load controlled nanoindentation experiment are analyzed.

Many authors observed pop-in events on metals or metallic thin films, ceramics, semiconductors, hard brittle thin films deposited on a soff elastoplastic substrate...

The pop-in event is often explained by on of the following mechanisms in function of the indented specimen
and the experimental conditions :

    * dislocations nucleation (= sudden yielding of a material under load) ;
    * rupture of a hard brittle film on an elastic-plastic substrate ;
    * crack(s) formation ; 
    * phase transformation ;
    * strain transfer across a grain boundary.

Weibull-type distribution
#################################

The cumulative Weibull distribution function with 2 parameters :math:`(\lambda, m)` is a continuous probability distribution
and is often used to describe particle size distributions and in survival or failure analysis [#Weibull_1951]_.

    .. math:: V\left(x, \lambda, m) = exp\left(\left(\frac{x}{\lambda}\right)^m\right)
            :label: Weibull_mortality

    .. math:: W\left(x, \lambda, m) = 1 - exp\left(\left(\frac{x}{\lambda}\right)^m\right)
            :label: Weibull_survival
			
    .. math:: \lambda = F^0_\text{crit}
            :label: lambda

With :math:`V` the mortal probability function and :math:`W` the survival probability function.
:math:`m` is a dimensionless material-dependent constant, often named the Weibull modulus (from 0 to usually 50) [#Afferante_2006]_.
If :math:`m=1`, the rate of failure remains constant and there is random failure occurring.

In the case of several indentations performed on the same sample,
:math:`x` can be the distribution of the critical loads :math:`F_\text{crit}` or the critical displacements :math:`h_\text{crit}`,
at which the pop-in events appear on the corresponding load-displacement curves. In this case, 
higher is :math:`m`, more homogeneous is the distribution of the pop-in.



:math:`F^0_{cr}` is the mean critical load at which the pop-in event appears.


in this toolbox for
the description of the statistics of the pop-in event  and [#Chechenin_1995]_ :



A cumulative Weibull-type distribution function is used as a survival probability in this toolbox for
the description of the statistics of the pop-in event [#Weibull_1951]_ and [#Chechenin_1995]_ :

    .. math:: W\left(\frac{F_\text{crit}}{F^0_\text{crit}}\right) = 1 - exp\left(-ln2\left(\frac{F_\text{crit}}{F^0_\text{crit}}\right)^m\right)
            :label: Weibull_modified



This Weibull-type distribution is modified to have a probability of 0.5, when :math:`F_{crit}` (the critical load)
is equal to :math:`F^0_{cr}` (the mean critical load).

The same Weibull-type distribution can be used for the critical displacement :math:`h_{crit}`.

Rupture of a hard brittle film on an elastic-plastic substrate
################################################################


    .. math:: F_\text{crit,s} = Kh_\text{crit}^n
            :label: critical_load_substrate

With :math:`F_\text{crit,s}`   and 

    .. math:: c = \sqrt{\frac{3F_\text{crit,s}}{2\pi\sigma_\text{e}}}
            :label: plastic_zone_radius

.. figure:: ./_pictures/popin_mechanisms_2.png
   :scale: 20 %
   :align: center
   
   *Figure 2 : Schematic cross section of deformation profile of a hard brittle film on an elastic-plastic substrate under indentation.*

With :math:`\sigma_\text{e}` the yield stress of the metallic substrate.
   
Statistical investigation of the onset of plasticity
######################################################

.. figure:: ./_pictures/popin_mechanisms_1.png
   :scale: 20 %
   :align: center
   
   *Figure 3 : Schematics cross section of deformation profile of an elastic-plastic substrate under indentation : 1) elastic deformation, 2) elastoplastic deformation (nucleation of dislocation) and 3) transfer of dislocations across a grain boundary.*

==> rate dependence and temperature dependence of incipient plasticity

cumulative statistics

Strain transfer across grain boundaries
######################################################

[#Mercier_2015]_
[#STABiX]_

See Figure 3-3...

.. figure:: ./_pictures/load-disp_curve_two_popin_Hertzian_fit.png
   :scale: 60 %
   :align: center
   
   *Figure 4 : Schematic of indentation load-displacement curve with two pop-in events (the 1st for the nucleation of dislocation and the 2nd for the strain transfer across a grain boundary).*
   
Matlab functions
###################

* `disttool - Interactive density and distribution plots <http://de.mathworks.com/help/stats/disttool.html>`_
* `fitdist - Fit probability distribution object to data <http://de.mathworks.com/help/stats/fitdist.html>`_
* `dfittool - Open Distribution Fitting app <http://de.mathworks.com/help/stats/dfittool.html>`_

References
#############

.. [#Afferante_2006] `Afferante L. et al., "Is Weibull’s modulus really a material constant? Example case with interacting collinear cracks" (2006).<http://dx.doi.org/10.1016/j.ijsolstr.2005.08.002>`_
.. [#Chechenin_1995] `Chechenin N.G. et al., "Nanoindentation of amorphous aluminum oxide films II. Critical parameters for the breakthrough and a membrane effect in thin hard films on soft substrates." (1995).<http://dx.doi.org/10.1016/S0040-6090(94)06494-6>`_
.. [#Mercier_2015] `Mercier D. et al. "A Matlab toolbox to analyze slip transfer through grain boundaries" (2015).<http://dx.doi.org/10.1088/1757-899X/82/1/012090>`_
.. [#STABiX] `STABiX toolbox <http://stabix.readthedocs.org/en/latest/>`_
.. [#Weibull_1951] `Weibull W., "A statistical distribution function of wide applicability", J. Appl. Mech.-Trans. ASME (1951), 18(3).<http://www.barringer1.com/wa_files/Weibull-ASME-Paper-1951.pdf>`_