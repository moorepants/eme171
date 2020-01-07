%% Script that demonstrates basic integration of ODEs.

% create time values that you desire a solution at, size 1x500
% for example, 0 to 10 seconds with 500 equally spaced time values
ts = linspace(0, 10, 500);

% create a vector with the initial state values, size 2x1
theta0 = 5*pi/180;  % angle in rad
omega0 = 0.0;  % angular rate in rad/s
x0 = [theta0; omega0];  % 2x1 vector

% create a vector to hold all the constants, be careful with units!
% size 3x1 constant parameter vector.
m = 1.00;  % mass in kg
l = 1.00;  % length in m
g = 9.81;  % acc due to gravity in m/s^2
p = [m; l; g];  % 3x1 vector parameter

% create a vector to hold all of the inputs (constant torque in this case),
% size 1x1
r = [2.0];  % tau, torque in N-m

% check if the eval_rhs function works using an arbitrary time value, the
% initial state values, and the parameters. If it doesn't you'll get an
% error at this line or an unexpected output.
display('Checking eval_rhs:')
eval_rhs(5.0, x0, r, p)

% create an anonymous function with the required inputs for ode45(), i.e.
% (t, x). Note that r and p are set to the values above on creation of this
% function.
% The is needed for two reasons:
% 1. You can only store a m-file function in a variable by using anonymous
%    functions and ode45 requires that the function be anonymous
% 2. ode45 requires that the function only has t and x as arguments, but
%    we'd like to pass in the values of p and r from the variables declared
%    above. This allows us to do that.
% Point 2 above is better than using global variables to share variables in
% all function scopes or declaring these parameters directly in the right
% hand side function where they have limited access.
f_anon = @(t, x) eval_rhs(t, x, r, p);

% integrate the equations with one of the available integrators, in this
% case the Runga-Kutta 4,5 method (good for simple, non-stiff systems).
[ts, xs] = ode45(f_anon, ts, x0);

% the default output of the integrator are the times and states at each
% desired time value:
% - ts, size 500 x 1
% - xs, size 500 x 2

% plotting the states versus time should be your first check to see if the
% result seems reasonable
subplot(211)
plot(ts, xs(:, 1))
ylabel('Angle [rad]')

subplot(212)
plot(ts, xs(:, 2))
ylabel('Angular Rate [rad]')

xlabel('Time [s]')
