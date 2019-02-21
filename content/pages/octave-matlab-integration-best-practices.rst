:title: Best practices for integrating ordinary differential equations using
        Octave/Matlab.

This document describes some recommended best practices for integrating
ordinary differential equations using Octave or Matlab. Following these
guidelines will result in well organized, readable code and provide some
advantages in computational efficiency (the later is not the focus and more
terse code can certainly be written to maximize computation speed).

Integrating the ODEs
====================

There are several equations that are of interest. The first are the ordinary
differential equations. You should already have these in explicit first order
form before moving forward here.

.. math::

   \dot{\mathbf{x}}(t) = \mathbf{f}(t, \mathbf{x}(t), \mathbf{r}(t), \mathbf{p})

- :math:`\mathbf{f}` is the function defining the right hand side of the
  explicit first order ordinary differential equations. It defines the time
  derivatives of the states at any given time.
- :math:`\mathbf{x}(t)` is the state vector, size mx1.
- :math:`\mathbf{r}(t)` is the input vector, size nx1.
- :math:`\mathbf{p}` is the constant parameter vector, size ox1.

:math:`\mathbf{x}` is determined by integrating :math:`\mathbf{f}(x, r, p, t)`
with respect to time:

.. math::

   \mathbf{x}(t) = \int_{t_0}^{t_f} \mathbf{f}(t, \mathbf{x}(t), \mathbf{r}(t), \mathbf{p}) dt

For example the two explicit first order ordinary differential equations of a
simple pendulum are:

.. math::

   \dot{\theta} & = \omega \\
   \dot{\omega} & = \frac{-mgl\sin(\theta) + \tau}{mL^2}

- The state vector is :math:`\mathbf{x} = [\theta \quad \omega]^T`.
- The parameter vector is :math:`\mathbf{p} = [m \quad L \quad g]^T`.
- The input vector is :math:`\mathbf{r} = [\tau]^T`.

The first step is to translate these differential equations into a function
that evaluates :math:`\mathbf{f}` at any given time instant. Below a function
named ``eval_rhs()`` is defined in an m-file of the same name that evaluates
:math:`\mathbf{f}`, i.e. the right hand side of the differential equations.

.. raw:: html

   <div class="highlight">

.. include:: ../scripts/best-practices/eval_rhs.m
   :code: matlab
   :class: highlight

.. raw:: html

   </div>

Once the function is defined, you can integrate the differential equations with
one of the available integrators or one of your own design:

.. raw:: html

   <div class="highlight">

.. include:: ../scripts/best-practices/integrate.m
   :code: matlab
   :class: highlight

.. raw:: html

   </div>

.. code:: matlab

   x0 = [5*pi/180; 0];

   ts = linspace(0, 10, 500);

   % 3x1 constant parameter vector.
   p = [1; 1; 9.81];

   % 1x1 input vector, constant in this case.
   r = [0.1];

   % new function, written in a single line, called an anonymous function.
   % The is needed for two reasons:
   % 1. You can only store a m-file function in a variable by using anonymous
   %    functions.
   % 2. ode45 requires that the function only has t and x as arguments, but
   %    we'd like to pass in the values of p and r from the variables declered
   %    above. This allows us to do that.
   % This is superior to using global variables to share variables in all %
   % function scopes or declaring these parameters directly in the right hand %
   % side function.
   f_anon = @(t, x) f(t, x, r, p);

   % Now the equations can be integrated.
   xdots = ode45(f_anon, x0, times);

Anonymous Functions
-------------------

An anonymous function has three important features that a normal function
(written in a unique m-file) doesn't have:

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

.. code:: matlab

   var_name = @(arg1, arg2, arg3, ...) expression involving the args;

You can use anonymous functions to declare simple functions that fit on one line:

.. code:: matlab

   >> my_func = @(x, y) x + y;
   >> my_func(1, 2)
   ans = 3

, use and alternative name for an existing function:

.. code:: matlab

   >> my_mean = @mean;
   my_mean = @mean
   >> my_mean([1, 2, 3])
   ans =  2

, use anonymous functions to customize the input to existing functions:

.. code:: matlab

   >> my_func = @(x, y, z) mean([x, y, z]);
   >> my_func(1, 2, 3)
   ans = 2

, and use anonymous functions to access values stored in variables in the
script's scope:

.. code:: matlab

   >> b = 2;
   >> c = 3;
   >> my_func = @(x) mean([x, b, c]);
   >> my_func(a)
   ans = 2

Note that  you have to declare the variables before declaring the anonymous function, the following code fails to compute:

.. code:: matlab

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

What if you want the input to be a function of time, the state, and the
parameters?

Create an Octave/Matlab function that returns the input vector given the
current time, state, and constant parameter values.

.. code:: matlab

   function r = calc_inputs(t, x, p)

     theta = x(1);
     omega = x(2);

     m = p(1);
     l = p(2);
     g = p(3);

     tau = m * g * l * sin(pi/20*t);

     r = [tau];

   end

Save this as ``calc_inputs.m``.

.. raw:: html

   <div class="highlight">

.. include:: ../scripts/best-practices/eval_rhs.m
   :code: matlab
   :class: highlight

.. raw:: html

   </div>
.. code:: matlab

   function xdot = eval_rhs(t, x, r, p)
     % EVAL_RHS - Returns the time derivative of the states, i.e. evaluates the
     % right hand side of the explicit ordinary differential equations.
     %
     % Syntax: xdot = eval_rhs(t, x, r, p)
     %
     % Inputs:
     %   t - A scalar value of time, size 1x1.
     %   x - State vector at time t, size 2x1 were m is the number of states.
     %   r - Function that returns the input vector at time t, size 1x1 were m
     %   is the number of inputs. r should be of the form r = r(t, x, p) for
     %   the ith time instance.
     %   p - Constant parameter vector, size 3x1 were m is the number of parameters.
     % Outputs:
     %   xdoti - Time derivative of the states at time t, size 2x1.
     theta = x(1);
     omega = x(2);

     % treat r as a function
     r_vals = r(t, x, p);

     tau = r_vals(1);

     m = p(1);
     l = p(2);
     g = p(3);

     thetadot = omega;
     omegadot = (-m*g*l*sin(theta) + tau)/(m*l^2)

     xdot = [thetadot; omegadot];

   end


.. code:: matlab

   x0 = [5*pi/180; 0];

   ts = linspace(0, 10, 500);

   % 3x1 constant parameter vector.
   p = [1; 1; 9.81];

   f_anon = @(t, x) f(t, x, @calc_inputs, p);

   % Now the equations can be integrated.
   xdots = ode45(f_anon, x0, times);


.. code:: matlab

   function r = calc_inputs_step(t, x, p)

     theta = x(1);
     omega = x(2);

     m = p(1);
     l = p(2);
     g = p(3);

     tau = m * g * l * sin(pi/20*t);

     if t > 1.0
       tau = 5.0;
     else
       tau = 0.0;

     r = [tau];

   end

Note that this lets us create a function for any inputs we desire and easily
swap them out for the integration.

.. raw:: html

   <div class="highlight">

.. include:: ../scripts/best-practices/integrate.m
   :code: matlab
   :class: highlight

.. raw:: html

   </div>

Outputs Other Than The States
=============================

The first type of outputs yo umay be interested in are functions of the states,
time, inputs, and constant parameters. It is useful to create a function that
can calculate these. It is best to do this post integration for computational
efficiency purposes (i.e. you can leverage vectorization and broadcasting).

.. math::

   \mathbf{y} = \mathbf{g}(t, \mathbf{x}, \mathbf{r}, \mathbf{p})

.. code:: matlab

   function y = g(t, x, r, p)

     theta = x(1);

     l = p(2);

     x_pos = l*cos(theta);
     y_pos = l*sin(theta);

     y = [x; y];

   end


.. code:: matlab

   x0 = [5*pi/180; 0];

   ts = linspace(0, 10, 500);

   % 3x1 constant parameter vector.
   p = [1; 1; 9.81];

   f_anon = @(t, x) f(t, x, @calc_inputs_step, p);

   % Now the equations can be integrated.
   xs = ode45(f_anon, x0, times);

   ys = g(times, xs, r, p);
