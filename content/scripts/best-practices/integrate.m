   % create an initial condition vector, mx1
   % x0 = [theta0, omega0]
   x0 = [5*pi/180;  % angle in rad
         0];  % angular rate in rad/s

   % create time values that you desire a solution at
   % 0 to 10 seconds with 500 equally spaced time values
   ts = linspace(0, 10, 500);

   % create a vector to hold all the constants, be careful with units!
   % 3x1 constant parameter vector.
   % p = [m, l, g];
   p = [1.00;   % mass in kg
        1.00;   % length in m
        9.81];  % acc due to gravity in m/s^2

   % create a vector to hold all of the inputs (constant in this case)
   r = [2.0];  % torque in N-m

   % check if the eval_rhs funciton works (if it doesn't you'll get an error
   % at this line)
   eval_rhs(5.0, x0, r, p)

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
   % create an anonymous function with the required inputs for ode45(), i.e.
   % (t, x). Note that r and p are set to the values above on creation of
   % this function.
   f_anon = @(t, x) eval_rhs(t, x, r, p);

   % integrate the equations with one of the available integrators, in this
   % case the Runga-Kutta 4,5 method (good for common non-stiff systems).
   [ts, xs] = ode45(f_anon, ts, x0);

   % the default output of the integrator are the states at each desired
   % time value:
   % - ts, size 500 x 1
   % - xs, size 500 x 2
   % plotting the states versus time should be your first check to see if
   % the result seems reasonable
