Learning Objectives
===================

Students will be able to:

- translate an analytic ordinary differential equations
- numerically integrate ordinary differential equations with Octave/Matlab
- create clear plots of the resulting input, state, and output trajectories

Introduction
------------

Up to a point, a dynamic physical system can be understood and designed
using analytical methods, but at a certain level of complexity and as
soon as significant nonlinear effects are encountered, the use of
computer simulation is of great benefit. These notes deal with using a
general-purpose simulation program, MATLAB, to numerically integrate the
differential equations implied by a bond graph model of a system. In
order to concentrate on developing the MATLAB simulation, these
equations are provided for this tutorial. Deriving equations of motion
from a bond graph model is straight-forward and will be covered in the
following weeks. The goal is to generate a simple script to simulate the
behavior of a dynamic system.

The Example System
------------------

The vibratory system shown below is supposed to be the simplest possible
model of a vehicle suspension. The mass is one-quarter of the vehicle
mass and the spring represents the effective spring rate at the wheel.
The damper represents the shock absorber and the effective damping at
the wheel. In a real vehicle the spring and shock absorber are very
nonlinear elements but here they will be considered to behave linearly.
The wheel mass and the tire stiffness are not represented in this simple
model. The gravity force has been neglected—the position of the mass is
measured from its equilibrium position in a gravity field. The velocity
input at the base represents the roadway unevenness the vehicle would
experience if it were rolling over the roadway.

|Screen Shot 2019-01-10 at 5.45.24 PM.png|

Figure 1: Schematic Diagram of Quarter Car Model

The parameters for this model, which represent typical values for a
light car, are M = 267 kg, B = 1398 N-sec/m, K = 1.87×10e4 N /m. The
bond graph method uses a capacitance or compliance value rather than the
spring constant, C = 1/ K=5 .35×10e−5m/N.

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

master.m
--------

------------------------------------------------------------------------------------------------------

The purpose of this file is to enter system parameters, call the
differential equation solver and finally post-process and plot results.
Since you will likely be running consecutive simulations, it's prudent
to begin your code by 'clearing the slate.'

MATLAB Cleanup
--------------

The clear() function, with 'all' as its input argument, removes all
variables, globals, functions and MEX links.

::

   clear all

The close() function, with 'all' as its input argument, closes all the
open figure windows.

::

   close all

The 'clc' command clears the command window.

::

   clc

Input System Parameters
-----------------------

This section is for declaring system variables. These variables must be
made 'global,' so that the function file (eqns.m) has access to their
values. Note that variable names are case-sensitive and that an
associated function file needs to also define the appropriate variables
as global.

::

   global M K B amp

Provide numerical values for system variables in the (main MATLAB)
workspace.

::

   M = 267; %kg, mass of 1/4 car
   K = 1.87e4; %N/m, spring stiffness
   B = 1389; %N-s/m, damper coefficient
   amp = 0.2; %m/s, velocity input (road profile)

Define Initial Conditions
-------------------------

The initial condition values for each system state variable are defined.
The order of the system is (2); there are (2) state variables: the
momentum of the vehicle mass and the displacement of the suspension
spring. We are also interested in viewing the inertial displacement of
the vehicle body and the profile of the road. To accommodate these two
requirements, we add on to the state vector, going beyond the 'minimum
state-space realization.' Refer to the included function file (eqns.m)
for explanation of the added variables.

::

   initial = [0 0 0 0]; % [mass momentum, spring disp, mass disp, bump disp]

Setup Time Array
----------------

Create the time array using the linspace() function, which generates
evenly-spaced points within a given range: linspace(X1, X2, N) generates
N points between X1 and X2. Note that you can also use the following
code to achieve the same result: tspan = 0:0.0025:5.

::

   tspan = linspace(0,5,2001);

Call ode45() Ordinary Differential Equation Solver
--------------------------------------------------

The ODE solver syntax is as follows: [TOUT,YOUT] =
ODE45(ODEFUN,TSPAN,Y0) with TSPAN = [T0 TFINAL] integrates the system of
differential equations y' = f(t,y) from time T0 to TFINAL with initial
conditions Y0. Note that the eqns.m file refers to the state vector as
's'.

::

   [t, s] = ode45(@eqns,tspan,initial);

| At this point, when master.m file calls ode45(), the function file is
  used 'length(tspan)' times
| (around two thousand in our case). We will continue to describe the
  current master.m file and then move on to the equations function (()).

Pre-allocate additional output vectors
--------------------------------------

Now once the simulation outputs are available (t, s), we'll move on to
obtain other outputs specified by the function. By creating an
appropriately sized zeros vector for each function output, the
computation time is minimized.

::

   ext = zeros(length(t),2);
   ds = zeros(length(t),4);

Obtain actual function outputs
------------------------------

Using the function file (eqns.m) with the ODE solver returns only the
time array used and the resulting state trajectories (no matter what
other ouputs you may have specified). In order to obtain the functions
actual outputs (the state derivatives and the extra outputs array), you
can call the function, without integrating, for each time step using the
state variable and time array outputs provided by the ODE call.

::

   for i = 1:length(t)
     [ds(i,:) ext(i,:)] = eqns(t(i), s(i,:));
   end

Plot outputs
------------

::

   figure('Name','displacements','NumberTitle','off','Color','white')
   plot(t,s(:,3),'k',t,s(:,4),'--k'), grid on
   title('Body and Road Displacement')
   legend('Body','Road')
   ylabel('displacement (m)')
   xlabel('time (s)')

Note how obtaining the body velocity is simply a matter of dividing the
body momentum (the first state variable) by mass.

::

   figure('Name','velocities','NumberTitle','off','Color','white')
   plot(t,s(:,1)/M,'k',t,ext(:,2),'--k'), grid on
   title('Body and Road Velocities')
   legend('Body','Road')
   ylabel('velocity (m/s)')
   xlabel('time (s)')
   % figure('Name','dforce','NumberTitle','off')
   % plot(t,ext(:,1),'k'), grid on
   % title('Suspension Damper Force')
   % ylabel('force (N)')
   % xlabel('time (s)')

OKAY! Those are the desired outputs for this tutorial. Now, as discussed
previously (()), we will review the function file (eqns.m) that contains
the system equations of motion. The objective of a function in this
context (when used with the ODE solver) is to simply define the
derivative of the system state variables, using the instantaneous values
of the states, and any inputs. To read more on function files, use help
function.

eqn.m
-----

--------------------------------------------------------------------------------------------------

State derivative function
-------------------------

This file outputs the state derivatives (ds) and an extra array (ext)
containing intermediate dynamic variables of interest. This file is
designed for MATLAB ordinary differential equation solvers (e.g., ode45,
ode23, ode15s). In this example, let us suppose that we are interested
in the force in the suspension damper. The function inputs are the time
and state vectors (t and s, respectively).

::

   function [ds, ext] = eqns(t,s)

.. _input-system-parameters-1:

Input system parameters
-----------------------

Please see the comments on global variables in the accompanying master
file (master.m).

::

   global M K B amp

Renaming variables for clarity
------------------------------

For readability (and ease of transcription) each entry in the state
vector is assigned an alphanumeric name corresponding to its physical
description.

::

   p = s(1); %kg-m/s, (body) momentum - bond graph standard variable
   q = s(2); %m, (suspension) displacement - bond graph standard variable
   % dbody = s(3); %m, body displacement (not used in EOM)
   % droad = s(4); %m, road input displacement (not used in EOM)

Input specifications
--------------------

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

Equations of Motion
-------------------

These are the most important equations, arranged as required in the form
s' = f(s,inputs). The following two equations, derived from the bond
graph, completely describe the dynamics of our example system. Please
note that in the initial labs these are provided—you'll be deriving your
own once it is covered in the course.

::

   p_dot = K*q + B*(Vi - p/M); %N, derivative of body momentum
   q_dot = Vi - p/M; %m/s, derivative of suspension displacement

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

Stacking up derivatives for output as vector
--------------------------------------------

The function requires a vector output for the state variables.

::

   ds = [p_dot; q_dot; dbody_dot; droad_dot];

At this point, the two m-files constitute a fully-operational
simulation. Of course, this is only the first step—in a real lab or in a
research environment, this simulation would be used to answer questions
or develop a design. Set B to 0.0 to show what the model predicts would
happen if the shock absorber were to be removed entirely.

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

