:title: Electric Bicycle Simulation
:status: hidden

These two Octave/Matlab files demonstrate the simulation of a model of an
electric bicycle traveling over a sinusoidal road. The format of the files
follows the `ODE integration best practices
<{filename}/pages/ode-integration-best-practices.rst>`_

eval_ebike_rhs
==============

The file |eval_ebike_rhs|_ encodes the 1st order ordinary differential
equations that govern the coupled dynamics of the electrical and mechanical
system.

.. code-include:: ../scripts/eval_ebike_rhs.m
   :lexer: matlab

.. |eval_ebike_rhs| replace:: ``eval_ebike_rhs.m``
.. _eval_ebike_rhs: {filename}/scripts/eval_ebike_rhs.m

simulate_ebike.m
================

The file |simulate_ebike|_ runs the simulation and plots the resulting motion.

.. code-include:: ../scripts/simulate_ebike.m
   :lexer: matlab

.. |simulate_ebike| replace:: ``simulate_ebike.m``
.. _simulate_ebike: {filename}/scripts/simulate_ebike.m
