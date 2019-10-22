:title: Lab Report Guidelines and Template
:status: hidden

Lab Report Guidelines
=====================

Lab reports prepared for EME 171 should meet the following guidelines:

- One lab report per group.
- Lab reports must be submitted online on Canvas. You may scan or take pictures
  of hand-calculations or hand-drawn figures (such as bond graphs) to include
  them in the report.
- Start each report with a title page containing the following information:

  - Lab assignment name & number
  - Course
  - Quarter
  - Year
  - Date
  - Your names
  - Student IDs

- Include a brief introduction explaining the system, simulation, and learning
  objectives.
- Reports must include the bond graph, the equations of motion, and the
  parameters used.
- Reports must include a list of the system's states and parameters, and must
  clearly explain any computed values such as time parameters, initial
  conditions, and derived parameters.
- Use both text and plots to explain your work and findings and to answer the
  questions presented in the lab. Write the report such that a reader can
  understand the topic given only your document. All results should be
  explained with text (complete sentences and paragraphs) interwoven among the
  figures that you present.
- Be sure to use clear, concise language. Omit needless words. Grammar,
  spelling, conciseness, structure, organization, and formatting will be
  assessed.
- All plots should have:

  - Axes labeled with units
  - Axes limits set to show the important aspects of the graph
  - Fonts large enough to read (>= 8pt)
  - A figure number, short title, and caption explaining what the figure is
  - Legends to describe multiple lines on a single plot

- Include your code in the report in an appendix.

  - Show each function and the main script. These should be monospaced font
    formatting and ideally syntax highlighted. You can use the publish function
    in Octave and Matlab to export code files to nice formats. See
    https://www.mathworks.com/help/matlab/matlab_prog/publishing-matlab-code.html
    (Links to an external site.) for more information.
  - Your code should be readable by someone else. Include comments, useful
    variable names, and follow good style recommendations, for example see this
    guide (Links to an external site.). Imagine that you will come back to this
    in 10 years and you want to be able to understand it quickly.
  - All functions should have a "help" description written in the standard
    style describing the inputs and outputs of the function. This template
    (Links to an external site.) is useful (click the function tab).

Example Lab Report
==================

Cover Page
----------

.. list-table::
   :class: table table-bordered

   * - Lab 1: Introduction to Simulation
   * - EME171 - Analysis, Simulation and Design of Mechatronic Systems
   * - Fall 2019
   * - October 18, 2019
   * - Student A -- 123456789
   * - Student B -- 987654321

Introduction
------------

Introduce the lab material. This includes describing the system you are
simulating, providing the system diagram, bond graph, state and output
equations, and parameters, discussing the learning objectives, and so on. In
this example, the lab concerns the simulation of a nonlinear mass/spring/damper
system subjected to a force input, where the nonlinear spring has a
constitutive law

.. math::

   F_{s} = Gq_{k}^3

The goal of this lab is to linearize the spring and to demonstrate the effects
of linearization on simulation accuracy. The system and bond graph are shown in
Figure 1.

.. figure:: https://objects-us-east-1.dream.io/eme171/2019f/example-system-and-bondgraph.png
   :width: 600px

   **Figure 1**: Mechanical Schematic of Nonlinear System (left) and equivalent
   bond graph (right).

The state equations for the nonlinear system are:

.. math::

   \dot{p}_m(t) = F(t) - G q_k(t) - \frac{b}{m}p_m(t) \\
   \dot{q}_k(t) = \frac{1}{m}p_m(t)

The state equations for the linearized system are:

.. math::

   \dot{p}_m(t) = F(t) - k \left(q_k(t) - q_{k,eq}\right) - \frac{b}{m}p_m(t) \\
   \dot{q}_k(t) = \frac{1}{m}p_m(t)

where :math:`p_{m}` is the momentum of the mass, :math:`q_{k}` is the spring
displacement, :math:`G` is the nonlinear spring coefficient, :math:`k` is the
linearized spring coefficient, :math:`b` is the damping coefficient, :math:`m`
is the mass, and :math:`F(t)` is the input force.

Additionally, the output of this simulation is the deflection from equilibrium
:math:`\delta`, where

.. math::

   \delta = q_{k} - q_{k,eq}

Calculations
------------

In this section, show your work for any computed variables like initial
conditions, equilibrium points, or computed parameters. Make sure to include
these here even if the calculations are present in your code. You may include
scanned images of hand computations if need be. In this example, we have a
section for computing system parameters and time parameters, but these will of
course vary with each lab.

System Parameters
^^^^^^^^^^^^^^^^^

A mass :math:`m=10` kg is lowered onto a nonlinear spring and damper and
reaches its equilibrium position at  :math:`q_{k,eq}=0.25` m. Knowing this, the
nonlinear spring constant :math:`G` can be found:

.. math::

   F_{eq} = mg = 98.1N \\
   G = \frac{F_{eq}}{q_{k,eq}^3} = \frac{98.1}{0.25^3} = 6272 \frac{N}{m^3}

The linearized spring stiffness can be found by taking the derivative of the
spring force equation at the equilibrium point.

.. math::

   k = \left.\frac{d}{dq_k} F_s\right|_{q_k=x_e} = \left.3Gq_k^2\right|_{q_k=x_e} = 1176 \frac{N}{m}

We can approximate the natural frequency from the linearized spring constant
and the mass as

.. math::

   \omega_{n} = \sqrt{\frac{k}{m}} \approx 10.84\ rad/s

From a given damping ratio of :math:`\zeta=0.3` we can find the damping
coefficient

.. math::

   b = 2\zeta\sqrt{km} \approx 65.06 Ns/m

Time Parameters
^^^^^^^^^^^^^^^

Be sure to include a section for your calculations for the time parameters;
that is, how you computed the final time and the number of time steps. Even if
this work is present in your code, be sure to show it here as well.

Simulation
----------

In this section, discuss what you simulated and the ensuing results. Use both
text and plots to explain your work and findings and to answer the questions
presented in the lab. Write the report such that a reader can understand the
topic given only your document. All results should be explained with text
(complete sentences and paragraphs) interwoven among the figures that you
present. Remember to clearly label the elements of plot, including axes, axes
labels, titles, and captions. Also, if you have multiple plots on the same
graph, make sure they are visually distinct.

The linear and nonlinear equations of motion were simulated for :math:`F/mg =`
0.1, 0.2, 2.0, and 5.0. The results of these simulations are shown below. In
all cases, the linearized model overestimated the system's displacement. This
is because the actual spring force increased much more rapidly than the spring
force of the linearized model (specifically, cubic growth vs. linear growth).
Additionally, the linearized model kept a constant natural frequency, while the
response frequency of the nonlinear system increased with displacement. Again,
this discrepancy is due to the linearized model not accounting for the actual
system's increasing stiffness.

.. figure:: https://objects-us-east-1.dream.io/eme171/2019f/example-results-plot.png
   :width: 600px

   **Figure 2**: Comparison of results for the nonlinear and linearized
   deflections.

Code
----

Include all code at the end of your report. Your code should be well-commented,
and any function files you write should include a standard "help" description
written in the standard style describing the inputs and outputs of the
function.

The example code shown below does not correspond to the system above, provides
an example of what yours submitted code should look like. Make sure it is in a
fixed-width font and (ideally) has syntax highlighting.

Simulation Script
^^^^^^^^^^^^^^^^^

.. code-include:: ../scripts/best-practices/integrate_with_derivative_output.m
   :lexer: matlab

Input Function
^^^^^^^^^^^^^^

.. code-include:: ../scripts/best-practices/eval_step_input.m
   :lexer: matlab

State Equations Function
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-include:: ../scripts/best-practices/eval_rhs_with_input.m
   :lexer: matlab

Output Function
^^^^^^^^^^^^^^^

.. code-include:: ../scripts/best-practices/eval_output.m
   :lexer: matlab

Output Function with State Derivatives
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-include:: ../scripts/best-practices/eval_output_with_state_derivatives.m
   :lexer: matlab
