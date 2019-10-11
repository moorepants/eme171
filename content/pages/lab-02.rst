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
is located above the shock absorber (represented by a linear spring and damper
in parallel). The unsprung mass, :math:`M_u`, represents the mass of the wheel
and tire. The spring between the unsprung mass and the ground represents the
stiffness of the tire.

|Screen Shot 2019-01-24 at 11.14.36 AM.png|

States
------

The state equations derived from the bond graph are as follows:

.. math::

   \dot{p}_2 & = -\frac{B}{M}p_2 - Kq_6 + \frac{B}{M}_up_8 + Mg  \\

   \dot{q}_6 & = \frac{1}{M}p_2 - \frac{1}{M}p_8  \\

   \dot{p}_8 & = \frac{B}{M}p_2 + Kq_6 - \frac{B}{M_u}p_8 - K_tq_{11} + M_ug \\

   \dot{q}_{11} & = \frac{1}{M_u}p_8 - v_i \\

where the time varying states are defined as:

- :math:`p_2`: vertical momentum of the sprung mass [kg m/s]
- :math:`q_6`: displacement between the sprung and unsprung mass [m]
- :math:`p_8`: vertical momentum of the unsprung mass [kg m/s]
- :math:`q_{11}`: displacement between the unsprung mass and the ground [m]

It will once again be useful to find the vertical displacement of the road to
visualize the shape. An additional state equation can be added to the above
minimal set of equations:

.. math::

   \dot{y}_{in} = v_{in}

Lastly, it would be nice to visualize the pothole in terms of the vertical
position, as opposed to vertical velocity. If we integrate the pothole velocity
versus time, we will get the shape of the pothole.

Constant Parameters
-------------------

- Acceleration due to gravity: :math:`g=9.81 \textrm{ms}^{-2}`
- Sprung mass: :math:`M = 250 \textrm{kg}`
- Ratio of the sprung and unsprung masses: :math:`\frac{M}{M_u} = 5`
- Ratio of the tire and suspension spring stiffnesses: :math:`\frac{K_t}{K} = 10`
- Forward speed of the car: :math:`V_c = 10 \textr{ms}^{-1}`
- Width of the pothole: :math:`L = 1.2 \textrm{m}`
- Depth of the pothole: :math:`A = 0.08 \textrm{m}`

Initial Conditions
------------------

The initial velocities of the two masses should be set to zero, which implies
that the momentums are also zero:

.. math::

   p_2 = 0 \textrm{ at } t = 0
   p_8 = 0 \textrm{ at } t = 0

The initial conditions of the displacements should reflect the equilibrium
state of the springs. If there is no motion, i.e the system is static, then the
state derivative equations reduce and show that:

.. math::

   Q_6 & = \frac{Mg}{K}| \\
   Q_{11} & = \frac{(M+M_u)g}{K_t}

which should be used as the initial conditions for the displacement states.

Inputs
------

The single input to the model is the vertical velocity of the road as seen from
a reference frame that translated with the forward motion of the car. This
velocity will vary over time and be partially determined by the travel speed of
the car.

When the wheel hits the first part of the pothole, the wheel travels down
(positive for the bond graph) with a constant vertical velocity. Once the tire
reaches the bottom of the hole the wheel reverses its vertical direction and
travels up at the same speed. Assume that the profile of the pothole represents
the displacement of the point where the tire rubber meets the road. At the end
of the pothole, the wheel resumes a vertical velocity of zero. It is better to
build this input flow from simple things than to make one complicated formula.

The amount of time it takes for the tire to cross the pothole is 
:math:`T=\frac{L}{V_c}`. Consequently, if the tire enters the pothole at
:math:`t=T_1`, the middle of the pothole occurs at :math:`T_2 = T_1 +
\frac{L}{2V_c}`, and the tire leaves the pothole at :math:`T_3 = T_1 +
\frac{L}{V_c}`. The vertical velocity is given by :math:`V_c = \frac{dy}{dx}`,
where :math:`\frac{dy}{dx}` is the slope of the pothole. Using the standard
slope formula the vertical speed down is :math:`V_{amp} = 2A\frac{V_c}{L}`.
Remembering that downward is positive, define the following times:

Time
====

- Damping ratio of the sprung mass: :math:`\zeta = \frac{B}{2M\omega_n} = 0.3`
- Natural frequency of the sprung mass: :math:`\omega_n = \sqrt{\frac{K}{M} \textrm{rad/s}, f_n = \frac{\omega_n}{2\pi} = 1 \textrm{Hz}`
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

Outputs
=======

One output that may be useful for a suspension engineer is the deflection of
the suspension relative to the equilibrium deflection. You may know that if the
suspension bottoms out, there may be damage to the car when hitting the
pothole. The deflection of the suspension is:

.. math::

   Q_6 - Q_{6}(t=0)

Remember a positive number represents compression.

We are also interested in the sprung mass acceleration, as this acceleration
will correlate to the forces the car's frame and the passengers experience.


Deliverables
============

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

Report Guidelines
=================

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

