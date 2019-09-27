Learning Objectives
===================

Students will be able to:

- translate analytic ordinary differential equations into a computer function
  that evaluates the equations at any given time
- numerically integrate ordinary differential equations with Octave/Matlab
- create clear plots of the resulting input, state, and output trajectories
- create a report with textual explanations and plots of the simulation

Introduction
============

Up to a point, a dynamic physical system can be understood and designed
using analytical methods, but at a certain level of complexity and as
soon as significant nonlinear effects are encountered, the use of
computer simulation is of great benefit.

These notes deal with using computatoinal engineering to numerically integrate
the differential equations implied by a bond graph model of a system. This
process is called "simulation". In order to concentrate on developing the
simulation code, these equations are provided for this tutorial. Deriving
equations of motion from a bond graph model is straight-forward and will be
covered in the following weeks. The goal is to generate a simple script to
simulate the behavior of a dynamic system.

The Example System
------------------

The vibratory system shown below can be used as a simple model of four
wheeled vehicle suspension. The mass :math:`M` is one-quarter of the total
vehicle mass and is typically called a "quarter car model". The spring
represents the effective stiffness between the ground and the vehicle chassis
at one wheel. The damper represents the shock absorber and the effective
damping at the wheel.  In a real vehicle, the spring and shock absorber are
nonlinear elements but here they will be considered to behave linearly, which
is a reasoable assumption for small motions.  The wheel mass and the tire
stiffness are not represented explicitly in this simple model. Additionally,
the force due to gravity has been neglected. To do so, the position of the mass
is measured from its equilibrium position in a gravity field. The velocity
input at the base :math:`v_{in}` represents the roadway unevenness the vehicle
would experience if it were rolling over the roadway.

The figure to the right of the mechanical schematic is a **bond graph**, a
domain neutral representation of the system components and the associated
energy flow among the components. You will learn to create bond graphs in this
course.  For now, we provide it for reference but with no explanations beyond
the fact that you can see some of the same parameters in the mechanical
schematic that you do in the bond graph.

|Screen Shot 2019-01-10 at 5.45.24 PM.png|

Figure 1: Mechanical Schematic of Quarter Car Model

After a bond graph is created, the first order ordinary differential equations
that describe how the dynamics of the system change with respect to time can be
formulated. You will learn how to generate these equations from a bond graph in
this class. For now, we provide you with the two equations:

.. math::

   \dot{p} = K q + B (v_{in} - \frac{p}{M})
   \dot{q} = V_{in} - \frac{p}{M}

These equations define expressions for the derivatives of the two state
variables :math:`p` and :math:`q`.

States
------

This model also has two primary state variables:

- Momentum of the mass: :math:`p(t)`
- Change in displacement between the mass and the ground: :math:`q(t)`

Parameters
----------

This model has three parameters associated with the three components.
Values that represent a light care of for these constant parameters are:

- Quarter car mass: :math:`M = 267 \textrm{kg}`
- Linear shock absorber damping coefficient: :math:`B = 1398 \textrm{N} \cdot \textrm{s m}^{-1}`
- Linear spring stiffness: :math:`K = 1.87\times 10^4 \textrm{Nm}^{-1]}`

The parameters for this model, which represent typical values for a
light car, are M = 267 kg, B = 1398 N-sec/m, K = 1.87×10e4 N /m. The
bond graph method uses a capacitance or compliance value rather than the
spring constant, C = 1/ K=5 .35×10e−5m/N.

Inputs
------

The flow input represents a triangular bump for the wheel to move over.
Since we're describing the flow (velocity input), not displacement, it
will take the form of a doublet--moving upward for a time, then downward
at the same rate for the same duration. It is important to note that
anything that changes in time must be defined inside the function. In
this example, we are not interested in frequently changing the timing of
the changes in road input. However, it may be instructive to see the
effect of changing the road velocity amplitude (amp), so it has been
declared as global, along with the physical system parameters.

::

   ts = 0.5; %s, time of bump start
   tm = 1.0; %s, time of bump apex
   te = 1.5; %s, time of bump end

Using the above-defined time parameters in a conditional statement
allows the velocity input (Vi) to have the proper shape. Note how the
inequalities used account for each entry in the time array only once.

::

   if t < ts
   Vi = 0; %m/s
   elseif t >= ts && t <= tm
   Vi = amp;
   elseif t > tm && t <= te
   Vi = -amp; %m/s
   else
   Vi = 0; %m/s
   end




Instructions
============

To help in deciding on computing time steps and the total time for a
computing run, it is useful to compute natural frequencies and damping
ratios whenever possible. In this case, |LaTeX:
\\omega_n=\:\sqrt{\frac{K}{M}}|\ = 8.37 rad/sec. This corresponds to
|LaTeX: f_n = \\omega_n/(2\pi)| = 1.33 Hz. The damping ratio is |LaTeX:
\\zeta| = |LaTeX: 0.5B(MK)^{-1/2}|\ = 0.313. These computed values allow
one to a) choose a reasonable total simulation time of 5.0 sec in order
to see a number of cycles of response and b) to guess that a plot point
every 0.01 sec should give very smooth response curves.

| The method demonstrated here can be used (and of course re-used on
  subsequent labs) for systems of arbitrary size and complexity. It
  scales well and is augmented easily to include advanced (non-linear)
  dynamics and the deployment of many engineering tools, such as state
  observers and control systems.
| For this tutorial, we will be producing two separate MATLAB M-files to
  complete the simulation:
| 1) master.m – The main file, where simulation constants are declared,
  the ODE solver is called and the data is post-processed and plotted.
| 2) eqns.m – The function file that contains the equations of motion
  (EOM).
| As you work through the accompanying m-files and encounter various
  functions, please be sure to read the syntax and examples produced by
  typing: help FunctionName at the MATLAB command window.


Additional state variables
--------------------------

We should expand the state-space when the only information available is
the derivative of the desired output. Otherwise it is sufficient to use
the supplementary output array that already exists (ext). This function
file already defines the derivatives of the state variables--so we
simply need to determine the derivative of these new items. These
additions to the state vector will come right out along with the spring
displacement and mass momentum (the original two state variables). The
derivative of the body displacement is obviously the body velocity. This
can be obtained readily by dividing the momentum of the body (the first
state variable) by the mass parameter.

::

   dbody_dot = p/M;

The derivative of the bump displacement is the velocity input itself.

::

   droad_dot = Vi;

Defining extra variables for output
-----------------------------------

As stated, we are interested in the total force in the suspension
damper. It would also be useful to plot the velocity input, so we can
append this value to our output array (ext). In this case the extra
output variable (ext) will be of size 1X2.

::

   ext(1) = B*(Vi - p/M);
   ext(2) = Vi;

At this point, the two m-files constitute a fully-operational
simulation. Of course, this is only the first step—in a real lab or in a
research environment, this simulation would be used to answer questions
or develop a design. Set B to 0.0 to show what the model predicts would
happen if the shock absorber were to be removed entirely.

**Deliverables**
----------------

| There is no lab report for the first week—you only need to **submit
  three plots created via Publish feature **\ as a **.pdf**: The
  displacement and velocity plots from above and either of these with B
  set to 0.0 N-s/m.
| EXTRA CREDIT Modify your definition of the bump profile to instead
  replicate each of the following and show resulting displacement plots:
| 1. a sinusoidal undulating road input with velocity amplitude of 0.1
  meters per second, at the natural frequency: |LaTeX: \\sqrt{K/M}|
| 2. driving over an 8” curb
| 3. a random roadway with bumps described by a velocity input uniformly
  distributed between -0.1 and 0.1 meters per second

.. |Screen Shot 2019-01-10 at 5.45.24 PM.png| image:: https://canvas.ucdavis.edu/courses/372109/files/6589565/preview
   :width: 1586px
   :height: 594px
.. |LaTeX: \\omega_n=\:\sqrt{\frac{K}{M}}| image:: https://canvas.ucdavis.edu/equation_images/%255Comega_n%253D%255C%253A%255Csqrt%257B%255Cfrac%257BK%257D%257BM%257D%257D
   :class: equation_image
.. |LaTeX: f_n = \\omega_n/(2\pi)| image:: https://canvas.ucdavis.edu/equation_images/f_n%2520%253D%2520%255Comega_n%252F(2%255Cpi)
   :class: equation_image
.. |LaTeX: \\zeta| image:: https://canvas.ucdavis.edu/equation_images/%255Czeta%2520
   :class: equation_image
.. |LaTeX: 0.5B(MK)^{-1/2}| image:: https://canvas.ucdavis.edu/equation_images/0.5B(MK)%255E%257B-1%252F2%257D
   :class: equation_image
.. |LaTeX: \\sqrt{K/M}| image:: https://canvas.ucdavis.edu/equation_images/%255Csqrt%257BK%252FM%257D%2520
   :class: equation_image

Note on Automatic Document Preparation
--------------------------------------

| A function of the MATLAB editor, called 'cell mode,' allows for rapid
  production of documentation from m-files. By commenting with single
  and double percent signs (as is done in the provided files), you can
  indicate descriptions and section headings, respectively; the built-in
  'publish' feature allows for automatic generation of Word files,
  HTML/XML files or even LaTeX code. The remainder of this lab document
  was essentially prepared using this method (and the provided m-files).
  Starting with the
| 'publish' output from a well-commented m-file and adding on is an
  acceptable and efficient way to complete a lab report.

Note that if there are any other m-file rather than the main m-file that
you want to publish (e.i. function file), it won't publish unless it is
written in the main m-file (An example of this method is attached on the
file called
`main_publish.m <https://canvas.ucdavis.edu/courses/372109/files/6589568/download?wrap=1>`__).
Another method is to copy/paste your function files after publishing the
main m-file in a word document.

