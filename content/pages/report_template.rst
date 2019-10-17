:title: EME 171 Lab Report Guidelines and Template
:status: hidden

=======================
 Lab Report Guidelines
=======================
Lab reports prepared for EME 171 should meet the following guidelines:

* One lab report per group.

* Lab reports must be submitted online on Canvas. You may scan or take pictures of hand-calculations or hand-drawn figures (such as bond graphs) to include them in the report.

* Start each report with a title page containing the following information: 

  * Lab assignment name & number
  
  * Course
  
  * Quarter
  
  * Year
  
  * Date
  
  * Your names
  
  * Student IDs

* Include a brief introduction explaining the system, simulation, and learning objectives.

* Reports must include the bond graph, the equations of motion, and the parameters used.

* Reports must include a list of the system's states and parameters, and must clearly explain any computed values such as time parameters, initial conditions, and derived parameters.

* Use both text and plots to explain your work and findings and to answer the questions presented in the lab. Write the report such that a reader can understand the topic given only your document. All results should be explained with text (complete sentences and paragraphs) interwoven among the figures that you present.

* Be sure to use clear, concise language. Omit needless words. Grammar, spelling, conciseness, structure, organization, and formatting will be assessed.

* All plots should have:

  * Axes labeled with units
  
  * Axes limits set to show the important aspects of the graph
  
  * Fonts large enough to read (>= 8pt)
  
  * A figure number, short title, and caption explaining what the figure is
  
  * Legends to describe multiple lines on a single plot

* Include your code in the report in an appendix.

  * Show each function and the main script. These should be monospaced font formatting and ideally syntax highlighted. You can use the publish function in Octave and Matlab to export code files to nice formats. See https://www.mathworks.com/help/matlab/matlab_prog/publishing-matlab-code.html (Links to an external site.) for more information.

  * Your code should be readable by someone else. Include comments, useful variable names, and follow good style recommendations, for example see this guide (Links to an external site.). Imagine that you will come back to this in 10 years and you want to be able to understand it quickly.

  * All functions should have a "help" description written in the standard style describing the inputs and outputs of the function. This template (Links to an external site.) is useful (click the function tab).

====================
 Example Lab Report
====================

Cover Page
==========

.. list-table::
   
   * - Lab 1: Introduction to Simulation 
   * - EME171 Fall 2019
   * - October 18, 2019
   * - Student A -- 123456789
   * - Student B -- 987654321

Introduction
============

Introduce the lab material. This includes describing the system you are simulating, providing the system diagram, bond graph, state and output equations, and parameters, discussing the learning objectives, and so on. In this example, the lab concerns the simulation of a nonlinear mass/spring/damper system subjected to a force input, where the nonlinear spring has a constitutive law

.. math::

   F_{s} = Gq_{k}^3
   
The goal of this lab is to linearize the spring and to demonstrate the effects of linearization on simulation accuracy. The system and bond graph are shown in Figure 1.

.. figure:: https://raw.githubusercontent.com/kevinrmallon/eme171/master/content/images/example-system-and-bondgraph.PNG
   :width: 600px

   **Figure 1**: Mechanical Schematic of Nonlinear System (left) and equivalent bond graph (right).

The state equations for the nonlinear system are:

.. math::

   \dot{p}_m(t) = F(t) - G q_k(t) - \frac{b}{m}p_m(t) \\
   \dot{q}_k(t) = \frac{1}{m}p_m(t)
   
The state equations for the linearized system are:

.. math::

   \dot{p}_m(t) = F(t) - k \left(q_k(t) - q_{k,eq}\right) - \frac{b}{m}p_m(t) \\
   \dot{q}_k(t) = \frac{1}{m}p_m(t)

where :math:`p_{m}` is the momentum of the mass, :math:`q_{k}` is the spring displacement, :math:`G` is the nonlinear spring coefficient, :math:`k` is the linearized spring coefficient, :math:`b` is the damping coefficient, :math:`m` is the mass, and :math:`F(t)` is the input force.

Additionally, the output of this simulation is the deflection from equilibrium :math:`\delta`, where

.. math::

   \delta = q_{k} - q_{k,eq}

Calculations
============

In this section, show your work for any computed variables like initial conditions, equilibrium points, or computed parameters. Make sure to include these here even if the calculations are present in your code. You may include scanned images of hand computations if need be. In this example, we have a section for computing system parameters and time parameters, but these will of course vary with each lab.

------------------
 System Paramters
------------------
A mass :math:`m=10`kg is lowered onto a nonlinear spring and damper and reaches its equilibrium position at  :math:`q_{k,eq}=0.25`m. Knowing this, the nonlinear spring constant  :math:`G` can be found:

.. math::

   F_{eq} = mg = 98.1N \\
   G = \frac{F_{eq}}{q_{k,eq}^3} = \frac{98.1}{0.25^3} = 6272 \frac{N}{m^3}
   
The linearized spring stiffness can be found by taking the derivative of the spring force equation at the equilibrium point.

.. math::

   k = \left.\frac{d}{dq_k} F_s\right|_{q_k=x_e} = \left.3Gq_k^2\right|_{q_k=x_e} = 1176 \frac{N}{m}
   
We can approximate the natural frequency from the linearized spring constant and the mass as

.. math::

   \omega_{n} = \sqrt{\frac{k}{m}} \approx 10.84\ rad/s
   
From a given damping ratio of :math:`\zeta=0.3` we can find the damping coefficient

.. math::

   b = 2\zeta\sqrt{km} \approx 65.06 Ns/m
   
-----------------
 Time Parameters
-----------------
Be sure to include a section for your calculations for the time parameters; that is, how you computed the final time and the number of time steps. Even if this work is present in your code, be sure to show it here as well.

Simulation
==========

In this section, discuss what you simulated and the ensuing results. Use both text and plots to explain your work and findings and to answer the questions presented in the lab. Write the report such that a reader can understand the topic given only your document. All results should be explained with text (complete sentences and paragraphs) interwoven among the figures that you present. Remember to clearly label the elements of plot, including axes, axes labels, titles, and captions. Also, if you have multiple plots on the same graph, make sure they are visually distinct.

The linear and nonlinear equations of motion were simulated for :math:`F/mg =` 0.1, 0.2, 2.0, and 5.0. The results of
these simulations are shown below. In all cases, the linearized model overestimated the system's displacement. This is because the actual spring force increased much more rapidly than the spring force of the linearized model (specifically, cubic growth vs. linear growth). Additionally, the linearized model kept a constant natural frequency, while the response frequency of the nonlinear system increased with displacement. Again, this discrepancy is due to the linearized model not accounting for the actual system's increasing stiffness.

.. figure:: https://raw.githubusercontent.com/kevinrmallon/eme171/master/content/images/example-results-plot.PNG
   :width: 600px
   
**Figure 2**: Comparison of results for the nonlinear and linearized deflections.

Code
====
Include all code at the *end* of your report. Your code should be well-commented, and any function files you write should include a standard "help" description written in the standard style describing the inputs and outputs of the function.

The example code shown below does not correspond to the system above, provides an example of what yours submitted code should look like.

Master Script
-------------

.. code-block:: matlab
   %% define all constant parameters and store in a structure
   p.g = 9.81;  % acceleration due to gravity [m/s^2]
   p.mp = 75.0;  % person + platform mass [kg]
   p.Jp = 14.0;  % person + platform inertia [kg m^2]
   p.lp = 0.9;  % center of mass [m]
   p.d = 0.4;  % wheel diameter [m]
   p.mw = 6;  % wheel mass [kg]
   p.Jw = p.mw*(p.d/2)^2;  % wheel inertia [kg m^2]
   p.T = 12;  % dc motor constant [Nm/A]
   p.R = 8;  % dc motor winding resistance [O]
   p.L = 0.5;  % dc motor wiinding inductance, [H]

   %% calculate the state and input matrices
   [A, B] = segway_state_space(p);

   %% calculate the eigenvalues and eigenvectors of the state matrix
   [evecs, evals] = eig(A);
   display('Eigenvalues');
   evals
   display('Eigenvectors');
   evecs

   %% check to see if a simple proportional feedback of q8 will stabilize the
   %% system
   % create a SISO plant input: e, output: q8 and control: e=-k*q8.
   C = [0, 0, 1, 0];  % i.e. y = q8
   sys = ss(A, B(:, 1), C, 0);
   [num, den] = ss2tf(sys);
   q8_e = tf(num, den)
   % see if proportional feedback can stabilize using root locus graph
   figure;
   rlocus(q8_e)

   %% try a PID controller (manually selected gains)
   pid_controller = pid(500, 50, 5);
   feedback(q8_e, pid_controller)
   display('Eigenvalues of PID controlled system')
   eig(feedback(q8_e, pid_controller))


   %% try a linear quadratic regulator controller
   if rank(ctrb(A, B(:, 1))) == length(A)
       display('System is controllable with full state feedback')
   end
   Q = eye(4);
   R = 1;
   [G, X, L] = lqr(A, B(:, 1), Q, R);
   display('Eigenvalues of PID controlled system')
   L

   %% simulate the system with the LQR controller
   final_time = 6.0;
   ts = linspace(0, final_time, num=final_time*60);

   f = @(t, x) eval_segway_rhs(t, x, @eval_segway_input, p, A, B, G);

   % set the initial forward lean angle to 20 degrees
   x0 = [0.0; 0.0; -20*pi/180; 0.0; 0.0];

   [ts, xs] = ode45(f, ts, x0);

   % calculate the inputs and outputs of the simulation
   us = zeros(length(ts), 2);
   ys = zeros(length(ts), 5);
   for i = 1:length(ts)
       us(i, :) = eval_segway_input(ts(i), xs(i, :)', p, G);
       ys(i, :) = eval_segway_output(ts(i), xs(i, :)', @eval_segway_input, p, G);
   end

   % save all simulation input and output data to a file
   save('-v6', 'segway-sim-data.mat', 'ts', 'xs', 'ys', 'us', 'p');

   %% plot the simulation results
   figure(1);
   plot(ts, xs);
   legend('p3', 'p7', 'q8', 'p17', 'xw');

   figure(2);
   plot(ts, ys);
   legend('xw', 'yw', 'xp', 'yp', 'P');

   figure(3);

   subplot(611)
   plot(ts, us(:, 2));
   ylabel('Wind force [N]');

   subplot(612)
   plot(ts, us(:, 1));
   ylabel('Applied Voltage [V]');

   subplot(613)
   plot(ts, 180/pi*xs(:, 3));
   ylabel('Angle [deg]');

   subplot(614)
   plot(ts, ys(:, 1));
   ylabel('Wheel Location [m]');

   subplot(615)
   plot(ts, 180/pi*xs(:, 4)/p.Jw);
   ylabel('Wheel Speed [deg/s]');

   subplot(616)
   plot(ts, ys(:, 5));
   ylabel('Power [Watts]');
