% intial condition, time values, and parameter setup is the same
x0 = [5*pi/180;  % [rad]
      0];        % [rad/s]
ts = linspace(0, 10, 500);  % [s]
p = [1;  % kg
     1;  % m
     9.81];  % m/s^2

% check if the input function works for the initial condition
display('Checking step input function:');
eval_step_input(5.0, x0, p)

% check if the eval_rhs funciton works with the input function passed in as
% an anoymous function
display('Checking rhs input function:');
eval_rhs_with_input(5.0, x0, @eval_step_input, p)

% changing the input only requires changing the function name here
f = @(t, x) eval_rhs_with_input(t, x, @eval_step_input, p);

% Now the equations can be integrated.
[ts, xs] = ode45(f, ts, x0);