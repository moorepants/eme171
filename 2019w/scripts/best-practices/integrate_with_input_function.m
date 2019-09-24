% this setup of initial conditions, time values, and parameters is the same
% as before
x0 = [5*pi/180;  % [rad]
      0];        % [rad/s]
ts = linspace(0, 10, 500);  % [s]
p = [1;  % kg
     1;  % m
     9.81];  % m/s^2

% check if the input function works for the initial condition
display('Checking if eval_input returns an expected result:')
eval_input(5.0, x0, p)

% check if the eval_rhs function works with the input function passed in as
% an anoymous function
display('Checking if eval_rhs_with_input returns an expected result:')
eval_rhs_with_input(5.0, x0, @eval_input, p)

% create an anonymous function with the required inputs for ode45(), i.e. (t, x).
f = @(t, x) eval_rhs_with_input(t, x, @eval_input, p);

% Now the equations can be integrated.
[ts, xs] = ode45(f, ts, x0);
