:title: Two Degree of Freedom Quarter Car Model

Learning Objectives
===================

The course's labs aim to demonstrate that:

#. the bond graph method can organize and simplify the modeling process,
   and that
#. Octave/MATLAB makes computer simulation very accessible, allowing you
   to concentrate on the dynamics of the system.

These initial labs are focused on the second objective, as we are again
providing the system equations of motion, instead of you generating
them. Don't worry if you don't completely understand how to generate
these equations on your own: you’ll all be experts in bond graph
equation formulation within the next couple of weeks!

Grading Rubric
==============

Attendance [10 points]

- [10] Both students attended at least 1 lab session for the two weeks prior to
  the lab being due.
- [0] Boht students did not attend a lab.

Contributions [10 points]

- [10] Very clear that everyone in the lab group conrtributed equitably. (both
  need to do some coding, both work on bond graph, both should contribute to
  writing)
- [5] Needs improvement in equitable
- [0] Clear that everyone is not contributing equilably

Introduction
============

In the last lab, you simulated a one degree-of-freedom quarter car suspension
model. Here we present a two degree-of-freedom quarter car suspension model
that is more in which the additional degree of freedom captures the simplified
compression/extension of the tire between the wheel hub and the ground.
Similar, to the prior lab the goal is to simulate this system to see the
response as it is driven over a pothole.

Power flowing from the system to the ground is considered positive (note the
direction in which positive velocity is defined).


To view the system response to driving over a pothole, we need to:

#. Determine all the system constant parameters, initial conditions, and
   time-varying inputs/outputs.
#. Determine the control parameters.
#. Write the Octave/MATLAB files, incorporating the provided equations
   of motion.
#. Simulate the system and plot the desired responses.

Model Description
=================

The sprung mass, :math:`M`, represents a quarter of the weight of the car that
is located above the shock absorber (spring and damper in parralell). The
unsprung mass, :math:`M_u`, represents the mass of the wheel and tire. The
spring between the unspring mass and the ground represents the stiffness of the
tire.

|Screen Shot 2019-01-24 at 11.14.36 AM.png|

States
------

The state equations derived from the bond graph are as follows:

.. math::

   \dot{p}_2 & = -\frac{B}{M}p_2 - Kq_6 + \frac{B}{M}_up_8 + Mg  \\

   \dot{q}_6 & = \frac{1}{M}p_2 - \frac{1}{M}p_8  \\

   \dot{p}_8 & = \frac{B}{M}p_2 + Kq_6 - \frac{B}{M_u}p_8 - K_tq_{11} + M_ug \\

   \dot{q}_{11} & = \frac{1}{M_u}p_8 - v_i \\

where the states are defined as:

- :math:`p_2`: vertical momentum of the sprung mass [kg m/s]
- :math:`q_6`: displacement between the sprung and unsprung mass [m]
- :math:`p_8`: vertical momentum of the unsprung mass [kg m/s]
- :math:`q_{11}`: displacement between the unsprung mass and the ground [m]

Constant Parameters
-------------------

- Acceleration due to gravity: :math:`g=9.81`
- Car sprung mass: :math:`M = 250 \textrm{kg}`
- Forward speed of the car: :math:`V_c = 10 \textr{ms}^{-1}`
- Width of the pothole: :math:`L = 1.2 \textrm{m}`
- Depth of the pothole: :math:`A = 0.08 \textrm{m}`
- Ratio of the sprung and unsprung masses: :math:`\frac{M}{M_u} = 5`
- Ratio of the tire and suspension spring stiffnesses: :math:`\frac{K_t}{K} = 10`
- Damping ratio of the sprung mass: :math:`\zeta = \frac{B}{2M\omega_n} = 0.3`
- Natural frequency of the sprung mass: :math:`\omega_n = \sqrt{\frac{K}{M} \textrm{rad/s}, f_n = \frac{\omega_n}{2\pi} = 1 \textrm{Hz}`

Initial Conditions
------------------

The initial velocities of the two masses should be set to zero, which implies
that the momentums are also zero:

.. math::

   p_2 = 0 \textrm{ at } t = 0
   p_8 = 0 \textrm{ at } t = 0

The intial conditions of the displacements should reflect the equilbrium state
of the springs. If there is no motion, i.e the system is static, then the state
derivative equations reduce and show that:

.. math::

   Q_6 & = \frac{Mg}{K}| \\
   Q_{11} & = \frac{(M+M_u)g}{K_t}

Inputs
------

The flow source is more complicated, as it varies over time. When the wheel
hits the first part of the pothole, the wheel travels down (positive for the
bond graph) with a constant vertical velocity. Once the tire reaches the bottom
of the hole the wheel reverses its vertical direction and travels up at the
same speed. Assume that the profile of the pothole represents the displacement
of where the rubber meets the road. At the end of the pothole, the wheel
resumes a vertical velocity of zero. It is better to build this input flow from
simple things than to make one
  complicated formula. The amount of time it takes for the tire to cross
  the pothole is  T =\frac{ L}{V_C}|. Consequently, if the tire
  enters the pothole at time = T1, the middle of the pothole occurs at
   |LaTeX: T_2 = T_1 + \\frac{L}{(2 \\cdot V_C)}|, and the tire leaves
  the pothole at |LaTeX: T_3 = T_1 + \\frac{L}{V_C}|. The vertical
  velocity is given by |LaTeX: V_C = \\frac{dY}{dx}|, where |LaTeX:
  \\frac{dY}{dX}| is the slope of the pothole. Using the standard slope
  formula the vertical speed down is |LaTeX: V_{amp} = 2 \\cdot A \\cdot
  \\frac{V_c}{L}|. Remembering that downward is positive, define the
  following times:

::

   T1 = WheneverYouDecideToStartIt;
   T2 = T1 + L/(2VC);
   T3 = T1 + L/(VC);
   Vamp = 2*A*Vc/L;

The flow source is to be completely defined from within the function, as
it's a time-varying input. The following code declares the required
parameters and sets up the flow source (it should be placed prior to the
dynamic equations, where SF12 is needed):

::

   Vc = 10; % m/s
   L = 1.2; % m
   A = 0.08; % m
   T1 = 0.1; %seconds
   T2 = T1 + L/(2Vc); %seconds
   T3 = T1 + L/(Vc); %seconds
   if t < T1
     SF12 = 0;
   elseif t >= T1 && t <= T2
     SF12 = 2*A*Vc/L;
   elseif t > T2 && t <= T3
     SF12 = -2*A*Vc/L;
   else
     SF12 = 0;
   end

The outputs are defined by what you are interested in:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

| We are interested in the suspension deflection. This is the output
  that represents the suspension deflection:

|LaTeX: Q_6 - Q_{6_{IN}}|

Remember a positive number represents compression. Since |LaTeX: Q_6| is
a state variable and the initial condition is a constant, the required
deflection plot can be constructed using only the plot command.

We are also interested in the mass (M) acceleration. Remember:
**computers hate to take derivatives.** To get the acceleration of the
sprung mass we use F = MA, or really A=F/M. The force on the mass is E2
and the mass magnitude is I2. Consequently, we output E2 from the
function file and get the acceleration by dividing by I2.

In addition, it would be nice to **actually see** the pothole. If we
integrate the pothole flow versus time, we will get the displacement. We
can simply expand the state space to include the input displacement, as
was done in the first lab.

2. Determine the time control parameters.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

| Octave/MATLAB needs to know the desired maximum time step to ensure
  that enough data is recorded. To determine the time step we need to
  think about the *dynamics of the system*.
| If the system oscillates very rapidly we will want a short time step.
  If the oscillation is very slow or if there is a huge amount of
  damping, the time step may be longer. The natural frequency of the one
  degree-of-freedom system is given by the square root of K/M. Remember
  that this is in radians per second Converting it to Hertz (cycles per
  second) can be an effective way to visualize this value. We would like
  to have at least 10 data points per cycle. We should also consider how
  long it takes to move over the pothole. I would recommend at least
  1\ **0 data points per half of the pothole**. Let’s say, for example,
  it takes 0.10 seconds to move halfway through the pothole. It would be
| nice to have a few data points in that interval. **For this example**,
  pick the max step size to be **0.01 seconds**. *Your* numbers will be
  different from this example. You must make these calculations using
  your systems natural frequency and the time for half a bump in order
  to come up with the proper value for your simulation. Remember there
  are two requirements for calculation of the maximum time step: 1) 10
  data points per cycle at the highest natural frequency and 2) 10 data
  points per half the bump. These two requirements will result in two
  calculations. You must then pick the smallest value, satisfying both
  requirements. This choice will dictate the number of elements in the
  time
| array that is given to the integration routine, ode45().
| When setting up your time array, also make sure that the amount of
  time simulated also represents the dynamics of the system are
  accurate. This is a judgment call. Some
| parts of the system act very fast, others take a longer time. We like
  to see approximately 3 oscillations or a steady state case if it is
  possible.

3. Edit the Octave/MATLAB files.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using the method demonstrated in the first lab, generate two m-files to
accomplish the desired

FOR YOUR REPORT TURN IN THE FOLLOWING:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. A plot of the suspension deflection for A = 0.08 m with a final time
   of 0.5 sec.
#. A plot of the mass acceleration in g for A = 0.08 m with a final time
   of 4.0 sec.
#. From the plots above give your best estimation of the vibration
   period and the frequency. Explain how you determined these numbers.
#. Try changing the damping ratio, ζ. Plot suspension deflection for
   this new damping ratio and comment. (DO NOT change or recalculate
   other parameters. Just change
   ζ). What happens when ζ decreases/increases? How does the change in ζ
   affect the mass acceleration?
#. List the bond graph variables (i.e. e2, f7) for the following
   physical variables: mass velocity, total suspension force from the
   spring and damper, the force on the road, the force on the damper,
   the force on the spring, and the total force on the mass.
#. A printout of your

-  Master M-file
-  Function M-file

Lab 2 Equations
---------------

The equations of motion for the quarter car model given in the lab
prompt are

|Screen Shot 2019-01-24 at 11.47.35 AM.png|

This is an example of a linear state-space system of the form |LaTeX:
\\dot{x} = Ax + Bu| where |LaTeX: x = \\begin{bmatrix}p_2 & q_6 & p_8 &
q_{11}\end{bmatrix}^{T}| and |LaTeX: \\begin{bmatrix} v_i(t) & Mg & M_u
g \\end{bmatrix}^{T}|. The system matrices are

|Screen Shot 2019-01-24 at 11.47.45 AM.png|

If the state variables are taken around the equilibrium and

|LaTeX: \\widetilde{q}_6 \\overset{\Delta}{=} q_6 - q_{6_0} \\quad
\\quad \\quad (7)|

|   |LaTeX: \\widetilde{q}_{11} \\overset{\Delta}{=} q_{11} - q_{11_0}
  \\quad \\quad \\quad (8)|  
|       

then the B matrix reduces to a single vector where the only input is
|LaTeX: u = v_i(t)|.

Report Guidelines
-----------------

Submit one report per group.

The reports must be generated using Octave or Matlab’s publish
functionality with the final result being a single PDF file.

#. Matlab:\ https://www.mathworks.com/help/matlab/matlab_prog/publishing-matlab-code.html
#. Octave:\ https://octave.org/doc/v4.2.0/Publish-Octave-Script-Files.html

Reports begin with the following information (no cover pages please):

#. Names of both group members
#. Assignment number and title

Write the report such that a reader can understand the topic given only
your document, i.e. include any relevant and necessary figures.

All results should be explained with text (complete sentences and
paragraphs) interwoven among the figures that you present.

All plots, diagrams, and figures must be:

#. clearly labeled (both axes, legend, etc) and titled.
#. scaled and cropped to appropriately present data.

Constant parameters and time-varying variables (inputs, states, outputs)
should be identified with descriptive text, a variable name, and units.

Grammar, spelling, conciseness, structure, organization, and formatting
will also be assessed.

There should be a section describing the contributions of each team
member to work done to complete the assignment.

.. |LaTeX: V_c = 10 \\frac{m}{s}| image:: https://canvas.ucdavis.edu/equation_images/V_c%2520%253D%252010%2520%255Cfrac%257Bm%257D%257Bs%257D
   :class: equation_image
.. |LaTeX: \\frac{M}{M_u} = 5| image:: https://canvas.ucdavis.edu/equation_images/%255Cfrac%257BM%257D%257BM_u%257D%2520%253D%25205
   :class: equation_image
.. |LaTeX: \\frac{K_t}{K} = 10| image:: https://canvas.ucdavis.edu/equation_images/%255Cfrac%257BK_t%257D%257BK%257D%2520%253D%252010
   :class: equation_image
.. |LaTeX: \\zeta = \\frac{B}{2M\omega_n} = 0.3| image:: https://canvas.ucdavis.edu/equation_images/%255Czeta%2520%253D%2520%255Cfrac%257BB%257D%257B2M%255Comega_n%257D%2520%253D%25200.3
   :class: equation_image
.. |LaTeX: \\omega_n = \\sqrt{ \\frac{K}{M}} \\textrm{rad/s}, f_n = \\frac{\omega_n}{2\pi} = 1 Hz| image:: https://canvas.ucdavis.edu/equation_images/%255Comega_n%2520%253D%2520%255Csqrt%257B%2520%255Cfrac%257BK%257D%257BM%257D%257D%2520%255Ctextrm%257Brad%252Fs%257D%252C%2520%2520f_n%2520%253D%2520%255Cfrac%257B%255Comega_n%257D%257B2%255Cpi%257D%2520%253D%25201%2520Hz
   :class: equation_image
.. |Screen Shot 2019-01-24 at 11.14.36 AM.png| image:: https://canvas.ucdavis.edu/courses/372109/files/6589571/preview
   :width: 1474px
   :height: 824px
.. |LaTeX: P_{2_{IN}} = M \\cdot V = 0| image:: https://canvas.ucdavis.edu/equation_images/P_%257B2_%257BIN%257D%257D%2520%253D%2520M%2520%255Ccdot%2520V%2520%253D%25200
   :class: equation_image
.. |LaTeX: V_u| image:: https://canvas.ucdavis.edu/equation_images/V_u
   :class: equation_image
.. |LaTeX: P_{8_{IN}} = M_u \\cdot V_u| image:: https://canvas.ucdavis.edu/equation_images/P_%257B8_%257BIN%257D%257D%2520%253D%2520M_u%2520%255Ccdot%2520V_u
   :class: equation_image
.. |LaTeX: Q_{6_{IN}} =\frac{I_2 \\cdot G}{K}| image:: https://canvas.ucdavis.edu/equation_images/Q_%257B6_%257BIN%257D%257D%2520%253D%255Cfrac%257BI_2%2520%255Ccdot%2520G%257D%257BK%257D
   :class: equation_image
.. |LaTeX: Q_{11_{IN}} = \\frac{(I_8+I_2) \\cdot G}{K_t}| image:: https://canvas.ucdavis.edu/equation_images/Q_%257B11_%257BIN%257D%257D%2520%253D%2520%255Cfrac%257B(I_8%252BI_2)%2520%255Ccdot%2520G%257D%257BK_t%257D
   :class: equation_image
.. |LaTeX: SE_1 = I_2 \\cdot 9.81, SE_9 = I_8 \\cdot 9.81| image:: https://canvas.ucdavis.edu/equation_images/SE_1%2520%253D%2520I_2%2520%255Ccdot%25209.81%252C%2520SE_9%2520%253D%2520I_8%2520%255Ccdot%25209.81
   :class: equation_image
.. |LaTeX: T =\frac{ L}{V_C}| image:: https://canvas.ucdavis.edu/equation_images/T%2520%253D%255Cfrac%257B%2520L%257D%257BV_C%257D
   :class: equation_image
.. |LaTeX: T_2 = T_1 + \\frac{L}{(2 \\cdot V_C)}| image:: https://canvas.ucdavis.edu/equation_images/T_2%2520%253D%2520T_1%2520%252B%2520%255Cfrac%257BL%257D%257B(2%2520%255Ccdot%2520V_C)%257D
   :class: equation_image
.. |LaTeX: T_3 = T_1 + \\frac{L}{V_C}| image:: https://canvas.ucdavis.edu/equation_images/T_3%2520%253D%2520T_1%2520%252B%2520%255Cfrac%257BL%257D%257BV_C%257D
   :class: equation_image
.. |LaTeX: V_C = \\frac{dY}{dx}| image:: https://canvas.ucdavis.edu/equation_images/V_C%2520%253D%2520%255Cfrac%257BdY%257D%257Bdx%257D
   :class: equation_image
.. |LaTeX: \\frac{dY}{dX}| image:: https://canvas.ucdavis.edu/equation_images/%255Cfrac%257BdY%257D%257BdX%257D
   :class: equation_image
.. |LaTeX: V_{amp} = 2 \\cdot A \\cdot \\frac{V_c}{L}| image:: https://canvas.ucdavis.edu/equation_images/V_%257Bamp%257D%2520%253D%25202%2520%255Ccdot%2520A%2520%255Ccdot%2520%255Cfrac%257BV_c%257D%257BL%257D
   :class: equation_image
.. |LaTeX: Q_6 - Q_{6_{IN}}| image:: https://canvas.ucdavis.edu/equation_images/Q_6%2520-%2520Q_%257B6_%257BIN%257D%257D
   :class: equation_image
.. |LaTeX: Q_6| image:: https://canvas.ucdavis.edu/equation_images/Q_6
   :class: equation_image
.. |Screen Shot 2019-01-24 at 11.47.35 AM.png| image:: https://canvas.ucdavis.edu/courses/372109/files/6589572/preview
   :width: 1038px
   :height: 404px
.. |LaTeX: \\dot{x} = Ax + Bu| image:: https://canvas.ucdavis.edu/equation_images/%255Cdot%257Bx%257D%2520%253D%2520Ax%2520%252B%2520Bu
   :class: equation_image
.. |LaTeX: x = \\begin{bmatrix}p_2 & q_6 & p_8 & q_{11}\end{bmatrix}^{T}| image:: https://canvas.ucdavis.edu/equation_images/x%2520%253D%2520%255Cbegin%257Bbmatrix%257Dp_2%2520%2526%2520q_6%2520%2526%2520p_8%2520%2526%2520q_%257B11%257D%255Cend%257Bbmatrix%257D%255E%257BT%257D
   :class: equation_image
.. |LaTeX: \\begin{bmatrix} v_i(t) & Mg & M_u g \\end{bmatrix}^{T}| image:: https://canvas.ucdavis.edu/equation_images/%255Cbegin%257Bbmatrix%257D%2520v_i(t)%2520%2526%2520Mg%2520%2526%2520M_u%2520g%2520%255Cend%257Bbmatrix%257D%255E%257BT%257D
   :class: equation_image
.. |Screen Shot 2019-01-24 at 11.47.45 AM.png| image:: https://canvas.ucdavis.edu/courses/372109/files/6589573/preview
   :width: 958px
   :height: 666px
.. |LaTeX: \\widetilde{q}_6 \\overset{\Delta}{=} q_6 - q_{6_0} \\quad \\quad \\quad (7)| image:: https://canvas.ucdavis.edu/equation_images/%255Cwidetilde%257Bq%257D_6%2520%255Coverset%257B%255CDelta%257D%257B%253D%257D%2520%2520q_6%2520-%2520q_%257B6_0%257D%2520%2520%2520%2520%2520%255Cquad%2520%255Cquad%2520%2520%255Cquad%2520(7)
   :class: equation_image
.. |LaTeX: \\widetilde{q}_{11} \\overset{\Delta}{=} q_{11} - q_{11_0} \\quad \\quad \\quad (8)| image:: https://canvas.ucdavis.edu/equation_images/%255Cwidetilde%257Bq%257D_%257B11%257D%2520%255Coverset%257B%255CDelta%257D%257B%253D%257D%2520%2520q_%257B11%257D%2520-%2520q_%257B11_0%257D%2520%255Cquad%2520%255Cquad%2520%2520%255Cquad%2520(8)
   :class: equation_image
.. |LaTeX: u = v_i(t)| image:: https://canvas.ucdavis.edu/equation_images/u%2520%253D%2520v_i(t)
   :class: equation_image

