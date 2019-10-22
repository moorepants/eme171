:title: Bicycle Balance Control Simulation
:status: hidden

The model presented here is based on the model described here:

https://plot.ly/ipython-notebooks/bicycle-control-design/

eval_bicycle_rhs
================

The file |eval_bicycle_rhs|_ encodes the 1st order ordinary differential
equations that govern the steer-roll dynamics of a bicycle. The steer and steer
rate inputs are set to constants.

.. code-include:: ../scripts/eval_bicycle_rhs.m
   :lexer: matlab

.. |eval_bicycle_rhs| replace:: ``eval_bicycle_rhs.m``
.. _eval_bicycle_rhs: {filename}/scripts/eval_bicycle_rhs.m

eval_bicycle_rhs2
=================

The file |eval_bicycle_rhs2|_ encodes the 1st order ordinary differential
equations that govern the steer-roll dynamics of a bicycle. The steer and steer
rate inputs are calculated by an input function.

.. code-include:: ../scripts/eval_bicycle_rhs2.m
   :lexer: matlab

.. |eval_bicycle_rhs2| replace:: ``eval_bicycle_rhs2.m``
.. _eval_bicycle_rhs2: {filename}/scripts/eval_bicycle_rhs2.m

eval_steer_control_input.m
==========================

The file |eval_steer_control_input.m|_ encodes a PD controller that generates
the steer and steer rate inputs.

.. code-include:: ../scripts/eval_steer_control_input.m
   :lexer: matlab

.. |eval_steer_control_input.m| replace:: ``eval_steer_control_input.m``
.. _eval_steer_control_input.m: {filename}/scripts/eval_steer_control_input.m

bicycle_main.m
==============

The file |bicycle_main|_ runs the simulation with the constant inputs and the
inputs from the controller.

.. code-include:: ../scripts/bicycle_main.m
   :lexer: matlab

.. |bicycle_main| replace:: ``bicycle_main.m``
.. _bicycle_main: {filename}/scripts/bicycle_main.m
