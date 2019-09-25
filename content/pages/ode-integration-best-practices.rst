:title: ODE Integration Best Practices With Octave/Matlab
:status: hidden

This document describes some recommended best practices for integrating
ordinary differential equations using Octave or Matlab. Following these
guidelines will result in well organized, modular, readable code and provide
advantages in computational efficiency [1]_.

.. [1] Efficiency is not the primary purpose of this document. More terse
       optimized code can certainly be written to maximize computation speed if
       needed.

Evaluating the ODEs
===================

There are several equations that are of potential interest, but the primary
equations are the ordinary differential equations, the "ODEs". These equations
always have to be considered; other equations described below are optional.
Your primary goal is to solve the ODEs and discover the time dependent behavior
of the system's states. You should already have the equations in explicit first
order form before moving forward here.  "Explicit" refers to the fact that
there are no time derivatives on the right hand side of the equations and
"first order" refers to their being :math:`m` equations, one for each of the
:math:`m` state variables. The general form for these equations is:

.. math::

   \dot{\mathbf{x}}(t) = \mathbf{f}(t, \mathbf{x}(t), \mathbf{r}(t), \mathbf{p})

where

- :math:`\mathbf{f}` is the function defining the right hand side of the
  explicit first order ordinary differential equations. It defines the time
  derivatives of the states at any given time, i.e. how the states change with
  time.
- :math:`\mathbf{x}(t)` is the state trajectory vector which is implicitly a
  function of time, size :math:`m\times1`.
- :math:`\mathbf{r}(t)` is the input trajectory vector which is implicitly a
  function of time, size :math:`o\times1`.
- :math:`\mathbf{p}` is the constant parameter vector (not a function of time),
  size :math:`p\times1`.

Note that it is customary to drop the :math:`(t)` that expresses the implicit
function of time for the various time dependent variables. That is done from
here forward.

The state trajectory, :math:`\mathbf{x}`, is determined by integrating
:math:`\mathbf{f}` with respect to time:

.. math::

   \mathbf{x} = \int_{t_0}^{t_f} \mathbf{f}(t, \mathbf{x}, \mathbf{r}, \mathbf{p}) dt

In general, these equations will be non-linear functions of the state variables
and there is unlikely to be analytical symbolic solutions that describe the
state trajectory in time. Thus, numerical integration is required to reach a
solution. This is fine because linear ODEs really only represent a tiny
percentage of all possible ODEs and the methods described here work with linear
and nonlinear ODEs.

The following describes how to numerically integrate :math:`\mathbf{f}` using
Octave or Matlab. The first step is to write an Octave/Matlab function that
evaluates :math:`\mathbf{f}`.

Defining the State Derivative Function
--------------------------------------

For example, the two explicit first order ordinary differential equations of a
simple pendulum are:

.. math::

   \mathbf{f}
   =
   \begin{bmatrix}
     \dot{\theta} \\
     \dot{\omega}
   \end{bmatrix}
   =
   \begin{bmatrix}
     \omega \\
     \frac{-mgl\sin(\theta) + \tau}{ml^2}
   \end{bmatrix}

- The state vector is :math:`\mathbf{x} = [\theta \quad \omega]^T`, where
  :math:`\theta` is the pendulum angle and :math:`\omega` is the angular rate.
- The parameter vector is :math:`\mathbf{p} = [m \quad l \quad g]^T`. The
  variables, respectively, are mass, length, and acceleration due to gravity.
- The input vector is :math:`\mathbf{r} = [\tau]^T`, a torque acting between
  the pendulum and its static attachment (inertial space).

The derivation of these equations can be found on the `relevant wikipedia page
<https://en.wikipedia.org/wiki/Pendulum_(mathematics)>`_.

The first step is to translate these ordinary differential equations into a
function that evaluates :math:`\mathbf{f}` at any given time instant. Below a
function named ``eval_rhs()`` is defined in an m-file named |eval_rhs|_ that
does so. ``rhs`` stands for the "right hand side" of the
differential equations.

Note that the inputs and outputs of this function are carefully documented in
the lines just below the function signature. Typing ``help eval_rhs`` will
print this documentation at the Octave/Matlab command prompt.

.. code-include:: ../scripts/best-practices/eval_rhs.m
   :lexer: matlab

.. |eval_rhs| replace:: ``eval_rhs.m``
.. _eval_rhs: {filename}/scripts/best-practices/eval_rhs.m

.. topic:: An alternative for passing in the constant parameters
   :class: alert alert-warning

   Octave/Matlab have a data type called a "structure" (similar to a C
   structure). The simplest use of a structure is a key-value pair mapping. To
   create a structure with a single key value pair assign a value to the
   desired name of the structure followed by a ``.`` and the key variable name.

   .. code-block:: matlabsession

      >> p.a = 2
      p =

        scalar structure containing the fields:

          a =  2

   More key value pairs can be added to the same structure by repeating what
   the same thing with different keys and values.

   .. code-block:: matlabsession
      >> p.b = 3
      p =

        scalar structure containing the fields:

          a =  2
          b =  3

      >> p.c = 4.192
      p =

        scalar structure containing the fields:

          a =  2
          b =  3
          c =  4.1920

   Now you can access these values of the structure ``p`` by appending ``.``
   and the key's variable name. The values in the structure can be used in
   computations just like other variables.

   .. code-block:: matlabsession

      >> p.a
      ans =  2
      >> p.a^2 + p.b^2 - p.c^2
      ans = -4.5729

Integrating the Equations
-------------------------

Once the function is defined, you can integrate the differential equations with
one of the available Octave/Matlab integrators or one of your own design:

.. code-include:: ../scripts/best-practices/integrate.m
   :lexer: matlab

.. topic:: Only define numbers once!
   :class: alert alert-warning

   Note that the constant parameters are only defined in this file. This is on
   purpose. If you define numerical values redundantly in multiple files and
   functions you significantly increase your chances of having an erroroneous
   output due to forgetting to change them all when you make edits.

You may be wondering what the ``@`` symbol specifically means. This designates
an *anonymous function* and is required by ``ode45()``. The following section
explains what an anonymous function is along with why and how it can be used.

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
3. Variables declared in the same scope as and before the anonymous function
   will be available in the anonymous function. This allows you to avoid the
   use of global variables or other bad practices at making the values
   available across a set of functions and scripts.

Anonymous functions are declared with the following syntax:

.. code-block:: text

   var_name = @(arg1, arg2, arg3, ...) expression involving the args;

You can use anonymous functions to declare simple functions that fit on one line:

.. code-block:: matlabsession

   >> my_func = @(x, y) x + y;
   >> my_func(1, 2)
   ans = 3

use and alternative name for an existing function:

.. code-block:: matlabsession

   >> my_mean = @mean;
   my_mean = @mean
   >> my_mean([1, 2, 3])
   ans =  2

use anonymous functions to customize the input to existing functions:

.. code-block:: matlabsession

   >> my_func = @(x, y, z) mean([x, y, z]);
   >> my_func(1, 2, 3)
   ans = 2

and use anonymous functions to access values stored in variables in the
script's scope:

.. code-block:: matlabsession

   >> b = 2;
   >> c = 3;
   >> my_func = @(x) mean([x, b, c]);
   >> my_func(1)
   ans = 2

Note that you have to declare the variables before declaring the anonymous
function, the following code fails to compute:

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

.. topic:: Why not global variables?
   :class: alert alert-warning

   It is possible to use global variables to simultaneously make the constant
   parameters available to both your primary script file and the file that
   defines your state derivative function. This works, but it is best to avoid
   global variables except for special needs. Each function provides a unique
   scope where all variables defined in the function are contained in the
   function. Using global variables increases the likelihood of programming
   errors when programs become more complex. A google search on "why global
   variables are bad" will provide you with background. Here is a Matlab
   specific note on them:

   https://matlab.fandom.com/wiki/FAQ#Are_global_variables_bad.3F

.. topic:: Computation speed of ``eval_rhs``
   :class: alert alert-info

   This function will be executed many times so it is important that this
   function only calculates the state derivatives and does nothing else. A
   simple ODE solver will evaluate the function :math:`n` times, where
   :math:`n` is the number of time instances you desire a solution at. But any
   quality ODE solver will execute this function more or less times than
   :math:`n`.  The solvers are often adaptive and will adjust the time step
   during integration to ensure low integration error. Fewer time evaluations
   are needed for slowly changing trajectories and more evaluations are needed
   when the trajectories change rapidly. Systems that have rapidly changing
   state trajectories are referred to as "stiff systems" or "stiff equations".
   For example, a stiff system may require :math:`1000 \times n` executions for
   an acceptable solution. Below, it is shown how to calculate all desired
   quantities that you may be tempted to calculate in ``eval_rhs`` so that you
   can keep this function minimal.

   For example, the number of right hand side function evaluations can be
   obtained by turning on the ``stats`` option for the integrator. Below shows
   that the equations, as described above, only need to be evaluated about half
   the number of desired output times.

   .. code-block:: matlabsession

      >> x0 = [5*pi/180; 0];
      >> ts = linspace(0, 10, 500);
      >> r = [5.0];
      >> p = [1; 1; 9.81];
      >> f_anon = @(t, x) eval_rhs(t, x, r, p);
      >> opt = odeset('stats', 'on');
      >> t_start = time();
      >> solution = ode45(f_anon, ts, x0, opt);
      >> time() - t_start
      ans = 0.050903
      >> solution.stats.nfevals
      ans =  217

   But notice that if the system is stiffened, significaanly increaasing
   :math:`g` does this, it now takes almost twice the number of evaluations
   than the desired output times.

   .. code-block:: matlabsession

      >> p = [1; 1; 1000];
      >> f_anon = @(t, x) eval_rhs_with_input(t, x, @eval_input, p);
      >> t_start = time();
      >> solution = ode45(f_anon, ts, x0, opt);
      >> time() - t_start
      ans = 0.35892
      >> solution.stats.nfevals
      ans =  1975

   This results in the stiff system integration taking about 7 times that of
   the less stiff system. If the ``eval_rhs`` takes a long time to execute by
   itself this can easily cause longer integration times.

Time Varying Inputs
===================

In the above example, a constant input for the torque was used. This is
sometimes desired but in general is quite limiting. What if you want the input
to be a function of time, the state, or the parameters (which are all valid
choices)?

.. math::

   \mathbf{r} = \mathbf{w}(t, \mathbf{x}, \mathbf{p})

Similarly to the function that evaluates the differential equations, create an
Octave/Matlab function that returns the input vector given the current time,
state, and constant parameter values. Save this as |eval_input|_.

.. |eval_input| replace:: ``eval_input.m``
.. _eval_input: {filename}/scripts/best-practices/eval_input.m

.. code-include:: ../scripts/best-practices/eval_input.m
   :lexer: matlab

For this function to be useful a slight adjustment to ``eval_rhs.m`` needs to
be made so that it accepts the input function instead of the values directly.
Save this as |eval_rhs_with_input|_.

.. |eval_rhs_with_input| replace:: ``eval_rhs_with_input.m``
.. _eval_rhs_with_input: {filename}/scripts/best-practices/eval_rhs_with_input.m

.. code-include:: ../scripts/best-practices/eval_rhs_with_input.m
   :lexer: matlab

Now you can pass in the input function as an anonymous function in similar
fashion as shown earlier for ``eval_rhs()``. Save as
|integrate_with_input_function|_.

.. |integrate_with_input_function| replace:: ``integrate_with_input_function.m``
.. _integrate_with_input_function: {filename}/scripts/best-practices/integrate_with_input_function.m

.. code-include:: ../scripts/best-practices/integrate_with_input_function.m
   :lexer: matlab

This design sets you up to easily swap out input functions. You can create an
input function for each desired input type. For example, here is a step
function, |eval_step_input|_.

.. |eval_step_input| replace:: ``eval_step_input.m``
.. _eval_step_input: {filename}/scripts/best-practices/eval_step_input.m

.. code-include:: ../scripts/best-practices/eval_step_input.m
   :lexer: matlab

Now integrating with the new input only requires changing the name of the
anonymous function in the main script, named here as
|integrate_with_step_function|_.

.. |integrate_with_step_function| replace:: ``integrate_with_step_function.m``
.. _integrate_with_step_function: {filename}/scripts/best-practices/integrate_with_step_function.m

.. code-include:: ../scripts/best-practices/integrate_with_step_function.m
   :lexer: matlab

Outputs Other Than The States
=============================

The first type of outputs you may be interested in are functions of the states,
time, inputs, and constant parameters. It is useful to create a function that
can calculate these. It is typically best to do this after integration for both
an organizational standpoint and computational efficiency purposes (e.g. you an
leverage vectorization and broadcasting, as shown below).

.. math::

   \mathbf{y} = \mathbf{g}(t, \mathbf{x}, \mathbf{r}, \mathbf{p})

Example outputs for the pendulum might be the Cartesian coordinates of the
pendulum bob and the energy, kinetic and potential. The equations below
describe these computations:

.. math::

   x_p = l \sin(\theta) \\
   y_p = l - l \cos(\theta) \\
   E_k = ml^2\omega/2 \\
   E_p = mghy_p

Create a new function file, |eval_output|_, that encodes these mathematical
operations.

.. |eval_output| replace:: ``eval_output.m``
.. _eval_output: {filename}/scripts/best-practices/eval_output.m

.. code-include:: ../scripts/best-practices/eval_output.m
   :lexer: matlab

Now this function can be used after integrating the ODEs to compute any desired
outputs. The following file, |integrate_with_output|_, shows how this is done.

.. |integrate_with_output| replace:: ``integrate_with_output.m``
.. _integrate_with_output: {filename}/scripts/best-practices/integrate_with_output.m

.. code-include:: ../scripts/best-practices/integrate_with_output.m
   :lexer: matlab

.. topic:: Vectorizing functions
   :class: alert alert-info

   It is also worth noting that Octave/Matlab code can generally be written to
   avoid loops, like in the above example. Slight adjustments to the output
   function will allow batch calculations of the outputs, as shown below in
   |eval_output_vectorized|_:

   .. |eval_output_vectorized| replace:: ``eval_output_vectorized.m``
   .. _eval_output_vectorized: {filename}/scripts/best-practices/eval_output_vectorized.m

   .. code-include:: ../scripts/best-practices/eval_output_vectorized.m
      :lexer: matlab

   Now, instead of the for loop, you can type:

   .. code-block:: matlab

      ys = eval_output_vectorized(ts, xs, nan, p);

   These batch, or "vectorized", calculations can be significantly faster than
   the loops, if that is desirable.

Outputs Involving State Derivatives
===================================

Additional outputs you may desire can also depend on the value of the time
derivative of the states, i.e. :math:`\mathbf{\dot{x}}`, and the output
function then takes this form:

.. math::

   \mathbf{z} = \mathbf{h}(t, \dot{\mathbf{x}}, \mathbf{x}, \mathbf{r}, \mathbf{p})

For example, the following function, |eval_output_with_state_derivatives|_,
calculates the radial and tangential acceleration of the pendulum bob. The
tangential acceleration depends on :math:`\dot{omega}`.

.. |eval_output_with_state_derivatives| replace:: ``eval_output_with_state_derivatives.m``
.. _eval_output_with_state_derivatives: {filename}/scripts/best-practices/eval_output_with_state_derivatives.m

.. code-include:: ../scripts/best-practices/eval_output_with_state_derivatives.m
   :lexer: matlab

The state derivatives are calculated internally when ``ode45()`` is called and
are not stored during integration. These can be recalculated after integration
for use in you primary script, e.g. as in |integrate_with_derivative_output|_.

.. |integrate_with_derivative_output| replace:: ``integrate_with_derivative_output.m``
.. _integrate_with_derivative_output: {filename}/scripts/best-practices/integrate_with_derivative_output.m

.. code-include:: ../scripts/best-practices/integrate_with_derivative_output.m
   :lexer: matlab
