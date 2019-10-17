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

Introduce the lab material. This includes describing the system you are simulating, providing the system diagram, bond graph, state equations, and parameters, discussing the learning objectives, This lab concerns the simulation of a nonlinear mass/spring/damper system subjected to a force input, where the nonlinear spring has a constitutive law

.. math::

   F_{s} = Gq_{k}^3
   
The goal of this lab is to linearize the spring and to demonstrate the effects of linearization on simulation accuracy. The system and bond graph are shown in Figure 1.

.. figure:: https://raw.githubusercontent.com/kevinrmallon/eme171/master/content/images/example-system-and-bondgraph.PNG
   :width: 600px

   **Figure 1**: Mechanical Schematic of Nonlinear System (left) and
   equivalent bond graph (right).

The state equations for the nonlinear system are:

