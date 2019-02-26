:title: Octave/Matlab ODE Integration Best Practices

This document describes some recommended best practices for integrating
ordinary differential equations using Octave or Matlab. Following these
guidelines will result in well organized, readable code and provide some
advantages in computational efficiency (the later is not the optimized and more
terse code can certainly be written to maximize computation speed).

Evaluating the ODEs
===================

There are several equations that are of potential interest. The primary
equations are the ordinary differential equations. These always have to be
considered, other equations described below are optional. You should already
have these in explicit first order form before moving forward here.

.. math::

   \dot{\mathbf{x}}(t) = \mathbf{f}(t, \mathbf{x}(t), \mathbf{r}(t), \mathbf{p})

- :math:`\mathbf{f}` is the function defining the right hand side of the
  explicit first order ordinary differential equations. It defines the time
  derivatives of the states at any given time, i.e. how the states change with
  time.
- :math:`\mathbf{x}(t)` is the state vector which is implicitly a function of
  time, size mx1.
- :math:`\mathbf{r}(t)` is the input vector which is implicitly a function of
  time, size nx1.
- :math:`\mathbf{p}` is the constant parameter vector (not a function of time),
  size ox1.

:math:`\mathbf{x}` is determined by integrating :math:`\mathbf{f}(x, r, p, t)`
with respect to time:

.. math::

   \mathbf{x}(t) = \int_{t_0}^{t_f} \mathbf{f}(t, \mathbf{x}(t), \mathbf{r}(t), \mathbf{p}) dt

Here we will numerically integrate :math:`\mathbf{f}` and the first step is to
write a Ocave/Matlab funciton that evalutes :math:`\mathbf{f}`.

Defining the State Derivative Function
--------------------------------------

For example, the two explicit first order ordinary differential equations of a
simple pendulum are:

.. math::

   \dot{\theta} & = \omega \\
   \dot{\omega} & = \frac{-mgl\sin(\theta) + \tau}{ml^2}

- The state vector is :math:`\mathbf{x} = [\theta \quad \omega]^T`, where
  :math:`\theta` is the pendulum angle and :math:`\omega` is the angular rate.
- The parameter vector is :math:`\mathbf{p} = [m \quad L \quad g]^T`. The
  variables, respectively, are mass, length, and acceleration due to gravity.
- The input vector is :math:`\mathbf{r} = [\tau]^T`, a torque acting between
  the pendulum and it's static attachment (inertial space).

The first step is to translate these differential equations into a function
that evaluates :math:`\mathbf{f}` at any given time instant. Below a function
named ``eval_rhs()`` is defined in an m-file named ``eval_rhs.m`` that
evaluates :math:`\mathbf{f}`, i.e. the right hand side of the differential
equations. Note that the inputs and outputs of this function are carefully
documented and calling ``help eval_rhs`` would print this documentation.

.. code-include:: ../scripts/best-practices/eval_rhs.m
   :lexer: matlab

Integrating the Equations
-------------------------

Once the function is defined, you can integrate the differential equations with
one of the available Octave/Matlab integrators or one of your own design:

.. code-include:: ../scripts/best-practices/integrate.m
   :lexer: matlab

You may be wondering what the ``@`` symbol means. This designates an *anonymous
function* and is required by ``ode45()``. The following section explains what
an anonymous function is along with why and how it can be used.

Anonymous Functions
-------------------

An anonymous function was used in the above script. The ``@`` symbol indicates
this type of function. An anonymous function has three important features that
a normal function (written in a unique m-file) doesn't have:

1. The function can be written in a single line (in fact, if your anonymous
   function is longer that a single line, 79 characters or so, you should move
   functionality into a normal function m-file).
2. The function can be stored in a variable that can be passed to other
   functions. For example, ``ode45()`` requires that the right hand side
   function be passed in as a variable.
3. Variables declared in the same scope as the anonymous function will be
   available in the anonymous function. This allows you to avoid the use of
   global variables or other bad practices at making the values available
   across a set of functions and scripts.

Anonymous functions are declared like with the following syntax:

.. code-block:: matlab

   var_name = @(arg1, arg2, arg3, ...) expression involving the args;

You can use anonymous functions to declare simple functions that fit on one line:

.. code-block:: matlabsession

   >> my_func = @(x, y) x + y;
   >> my_func(1, 2)
   ans = 3

, use and alternative name for an existing function:

.. code-block:: matlabsession

   >> my_mean = @mean;
   my_mean = @mean
   >> my_mean([1, 2, 3])
   ans =  2

, use anonymous functions to customize the input to existing functions:

.. code-block:: matlabsession

   >> my_func = @(x, y, z) mean([x, y, z]);
   >> my_func(1, 2, 3)
   ans = 2

, and use anonymous functions to access values stored in variables in the
script's scope:

.. code-block:: matlabsession

   >> b = 2;
   >> c = 3;
   >> my_func = @(x) mean([x, b, c]);
   >> my_func(a)
   ans = 2

Note that  you have to declare the variables before declaring the anonymous function, the following code fails to compute:

.. code-block:: matlabsession

   >> clear all;
   >> a = 1;
   >> my_func = @(x) mean([x, b, c]);
   >> my_func(a)
   error: 'b' undefined near line 1 column 30
   error: called from
       @<anonymous> at line 1 column 22
   >> b = 2;
   >> c = 3;
   >> my_func(a)
   error: 'b' undefined near line 1 column 30
   error: called from
       @<anonymous> at line 1 column 22

Time Varying Inputs
===================

In the above example, a constant input for the torque was used. This is quite
limiting. What if you want the input to be a function of time, the state, and
the parameters (all valid choices)?

.. math::

   \mathbf{r} = \mathbf{g}(t, \mathbf{x}, \mathbf{p})

Similarily to the function that evaluates the differential equations, create an
Octave/Matlab function that returns the input vector given the current time,
state, and constant parameter values.
Save this as ``eval_input.m``.

.. code-include:: ../scripts/best-practices/eval_input.m
   :lexer: matlab

Now a slight adjustment to the right hand side function so it accepts the input
function instead of the values.

.. code-include:: ../scripts/best-practices/eval_rhs_w_input.m
   :lexer: matlab

The integration code now looks like:

.. code-include:: ../scripts/best-practices/integrate_with_input_function.m
   :lexer: matlab

This design sets you up to easily swap out input functions. You can create an
input function for each desired input type. For example, here is a step
funciton.

.. code-include:: ../scripts/best-practices/eval_step_input.m
   :lexer: matlab

Now integrating with the new input only takes changing the name of the
anonymous funciton.

.. code-include:: ../scripts/best-practices/integrate_with_step_function.m
   :lexer: matlab

Outputs Other Than The States
=============================

The first type of outputs you may be interested in are functions of the states,
time, inputs, and constant parameters. It is useful to create a function that
can calculate these. It is typically best to do this post integration for
computational efficiency purposes (e.g. you can leverage vectorization and
broadcasting, as shown below).

.. math::

   \mathbf{y} = \mathbf{h}(t, \mathbf{x}, \mathbf{r}, \mathbf{p})

Example outputs for the penudlum might be the Cartesian coordinates of the
pendulum bob and the energy, kinetic and potential. The function below
computes:

.. math::

   x_p = l \cos(\theta) \\
   y_p = l \sin(\theta) \\
   E_k = ml^2\omega/2 \\
   E_p = mghy_p

.. code-include:: ../scripts/best-practices/eval_output.m
   :lexer: matlab

Now this function can be used after the integration to compute any desired
outputs.

.. code-include:: ../scripts/best-practices/integrate_with_output.m
   :lexer: matlab

It is also worth noting that Octave/Matlab code can generally be written to avoid
loops. Slight adjustments to the output function will allow batch calculations
of the outputs, as shown below:

.. code-include:: ../scripts/best-practices/eval_output_vectorized.m
   :lexer: matlab

Outputs
=======


.. math::

   \mathbf{z} = \mathbf{h}(t, \dot{\mathbf{x}}, \mathbf{x}, \mathbf{r}, \mathbf{p})
