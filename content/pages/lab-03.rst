:title: Lab 3: Motocross Pitch-Heave Model
:status: hidden

.. contents::

Learning Objectives
===================

After completing this lab you will be able to:

- translate ordinary differential equations into a computer function that
  evaluates the equations at any given point in time
- numerically integrate ordinary differential equations with Octave/Matlab's
  ode45_
- create complete and legible plots of the resulting input, state, and output
  trajectories
- create a report with textual explanations and plots of the simulation
- explain how various parameters affect the motion of a two degree-of-freedom
  quarter car model

.. _ode45: https://www.mathworks.com/help/matlab/ref/ode45.html

Introduction
============

In this lab, you will investigate the response of a motocross motorcycle as it
traverses two road bumps. You will look into the pitch and heave motion of the
motorcycle when it travels over the bumps. You will also consider how the rider
can change the dynamics of the vehicle by shifting his or her weight around on
the motorcycle.

Model Description
=================

The schematic for the model is shown in Figure 1. There is a primary mass and
inertia that represents the rider and the motorcycle lumped as a single rigid
body supported by front and rear suspension systems and tires.

.. figure:: https://objects-us-east-1.dream.io/eme171/2019f/lab-03-fig-01.png
   :width: 600px

   **Figure 1** Motocross cycle model (pitch-heave model). Note: In this
   schematic, the front wheel has already gone over the first bump.

System Equations
----------------

.. figure:: https://objects-us-east-1.dream.io/eme171/2019f/lab-03-fig-02.png
   :width: 600px

   **Figure 2** System equations

State Variables
---------------

=============== ====================================
:math:`p_J`     Pitch angular momentum
:math:`p_{cr}`  Vertical momentum of motorcycle and rider
:math:`q_{sf}`  Front suspension spring displacement
:math:`q_{sr}`  Rear suspension spring displacement
:math:`p_{tf}`  The momentum of front tire mass
:math:`p_{tr}`  The momentum of rear tire mass
:math:`q_{tf}`  Front tire deflection
:math:`q_{tr}`  Rear tire deflection
=============== ====================================

Constant Parameters
-------------------

=============== ============================================= ======== =======================
Symbol          Description                                   Value    Units
:math:`v_c`     Cycle forward velocity                        10       m/s
:math:`L_{cg}`  Center of gravity distance (standard config.) 0.9      m
:math:`L_{cg}`  Center of gravity distance (forward config.)  0.7      m
:math:`m_{cr}`  Mass of cycle and rider                       300      kg
:math:`r_{gy}`  Body radius of gyration                       0.5      m
:math:`k_{sf}`  Front suspension stiffness                    3000     N/m
:math:`k_{sr}`  Rear suspension stiffness                     3500     N/m
:math:`b_{sf}`  Front damping coefficient                     400      Ns/m
:math:`b_{sr}`  Rear damping coefficient                      500      Ns/m
:math:`m_{tf}`  Front tire (unsprung) mass                    15       kg
:math:`m_{tr}`  Rear tire (unsprung) mass                     20       kg
:math:`k_{tf}`  Front tire stiffness                          30,000   N/m
:math:`k_{tr}`  Rear tire stiffness                           40,000   N/m
:math:`L_{wb}`  Wheel base distance                           1.6      m
:math:`A`       Bump height                                   See Note m
:math:`L`       Bump distance                                 0.5      m
:math:`g`       Acceleration due to gravity                   9.81     :math:`\frac{m}{s^2}`
=============== ============================================= ======== =======================

Hint: :math:`J_{cr}\:=\:m_{cr}\:\cdot r_{gy}\:^2`

Inputs
------

The maximum suspension deflection **from equilibrium conditions** is
:math:`\delta_{\max}=0.1\:m` for both the front and rear suspensions.

The motorcycle will go over two bumps, each height :math:`A`. You want to
determine the largest bump height which the motorcycle can go over **without
bottoming out either the front or rear suspension.** Bottoming out means that
the suspension deflection has equaled or exceeded the maximum suspension
deflection specified above.

This should be determined for both loading configurations
(:math:`L_{cg}\:=\:0.9\:m| and |LaTeX: L_{cg}\:=\:0.7\:m`). A clue is that this
is a linear system, which means that if inputs are scaled up or down, the
responses of all variables will be scaled identically (e.g., if you double the
inputs, the outputs are doubled as well). This means that only two simulation
runs are necessary to determine the size of the bump that will cause the
suspension to bottom out (one for each configuration). You may want to use the
MATLAB/Octave command *max* () to find the maximum suspension deflections.

================== ===================================
:math:`m_{cr}\:g`  Gravity on cycle and rider
:math:`m_{tf}g`    Gravity on the front tire
:math:`m_{tr}g`    Gravity on the rear tire
:math:`v_{fi}(t)`  Vertical velocity at the front tire
:math:`v_{ri}(t)`  Vertical velocity at the rear tire
================== ===================================

Note: :math:`a\:=\:L_{cg}\:and\:b\:=\:L_{wb}-\:L_{cg}`

Kinematics: :math:`v_{sf}\:=\:v_h\:+a\:\cos\theta\:\omega_p\:,\:v_{sr\:}\:=\:v_h\:-b\:\cos\theta\:\omega_p`,
where :math:`\\theta=\int_0^t\omega_pdt`. With a small angle
assumption: :math:`v_{sf}\:=\:v_h\:_{\:}+\:a\omega_p\:,\:v_{sr}\:=\:v_h\:-b\omega_p`.

Define all system inputs for the effort and flow sources in the equations file.
The effort sources are the force of gravity on the tire masses and the mass of
the cycle and rider. The flow sources are the road input velocities, dependent
on the road profile. For the flow sources, you need to first define a start
time (when the front tire first hits the bump). Then, using the forward
velocity and the given cycle/road geometry, find the following:

   -  The times when the front tire reaches the apex and end of the
      first bump.
   -  The times when the front tire reaches the start, apex, and end of
      the second bump.
   -  The times when the rear tire reaches the start, apex, and end of
      the first bump.
   -  The times when the rear tire reaches the start, apex, and end of
      the second bump.
   -  The input velocity amplitude when going up and down a bump (the
      amplitude is the same for both bumps and for front and rear
      inputs)

Note: You can assume that the horizontal distance between the wheel
bases (:math:`L_{wb}`) does not change as the angle of the top mass
changes. Show the complete input equations in your report.

Initial Conditions
------------------

You will need to calculate all of the displacements at the equilibrium state
and use these values for the initial displacements. Determine the initial
conditions from the equations of motion (remember, the system is initially in
equilibrium, with all state derivatives equal to zero) or by using statics.
**Develop these in equations form; let the computer calculate the actual
values**.

Simulation
==========

Simulate the system to obtain the front and rear suspension deflections, heave
velocity (vertical velocity of the cycle and rider) and pitch angular velocity.
Suspension deflection is defined as the spring displacement minus the initial
value so that it starts at zero in gravitational equilibrium.

Simulate your system for some arbitrary bump height (an even number like
0.1 m might be a good choice). Find the maximum suspension deflections
(front and rear) for that bump height and use it to determine the
maximum bump height that the cycle can travel over (recall the note
above about linear systems mentioned earlier).

Time
----

Set your time control parameters. The time control parameters are the maximum
step size and the finish time. To determine these, you will need to estimate
the system natural frequencies. Use Figure 2 to approximate the range of
natural frequencies for this system. Invert the frequency estimations to
determine the vibration periods, and then choose appropriate time control
parameters. You want the maximum step size to be at most about one-tenth of the
shortest vibration period or one-tenth of the time it takes to go over one half
of one bump, whichever is shorter. Set the finish time to be about three of the
longest vibration periods after the rear tire reaches the end of the second
bump. Once you have determined your final time and your step size, set the
simulation timespan in the master file.

Hint: :math:`T\:=\frac{\:1}{f_n},\:f_n\:=\frac{\omega_n}{2\pi\:},\:\omega_n\:=\:\sqrt{\frac{stiffness}{inertia}}`.

You may use a small angle assumption (:math:`\sin\:\theta\:\approx\theta`) when
determining the pitch natural frequency.

.. figure:: https://objects-us-east-1.dream.io/eme171/2019f/lab-03-fig-03.png
   :width: 600px

Deliverables
============

In your lab report, show your work for creating and evaluating the simulation
model. That is, include your bond graph drawing and any calculations for
initial conditions, input equations, maximum bump height, time control
parameters, and any other parameters. Additionally, provide/answer the
indicated plots/questions and provide a copy of your Matlab/Octave code.

Bond Graph
----------

Draw the bond graph for the system with the power flow and velocities as shown
in the schematic in Figure 1. Spring deflections are positive in compression.
Note: when drawing the kinematic relationships between
:math:`v_h\:,\:\omega_p\:,\:v_{sf}\:,\textrm{and}\:v_{sr}`\ on the bond graph,
use the small angle assumption shown under the "Lab 3 Equations" section of
this assignment.

Plots
-----

You should provide six total plots, three for the standard CG configuration and
three for the forward configuration. For each configuration, provide a plot of:

#. The front and rear suspension deflections (on the same plot).
#. The heave velocity.
#. The pitch angular velocity.

These plots should be scaled so that the bump size corresponds to the maximum
allowable bump height.

Questions
---------

#. What are the natural frequencies of the system? How do these
   frequencies affect your choice of sample time and simulation length?
#. According to the power flow on the bond graph, are the deflections of
   the suspension positive in compression or tension? Why?
#. Compare the plots of the suspension deflections for the two
   center-of-gravity configurations and describe how the shift in the
   center of mass affects the system response to the bumps (for example,
   discuss maximum displacements or shape of the response).
#. From the required plots of heave velocity and angular velocity,
   explain why the spikes in heave velocity are in the same direction,
   while those of the angular velocity switch direction.

Bonus Question
--------------

What would it mean if the force in one of the tires were to become
negative (or in other words, if the tire were to be put in tension)?
Would the model still be valid? (Hint:Would this happen in real life?)
If this is not valid, explain how you would modify your model to make it
valid (feel free to try your fix and show results). If you get this
correct or show an honest effort in trying to answer this question, you
will receive some extra credit.
