% this is the simulation we did in class of the bicycle balance model

% Set the initial values of the states (initial conditions).
% Given an initial 5 deg roll angle and 5 deg steer angle, simulate the system.
x0 = [0;  % roll rate [rad/s]
      5*pi/180;  % roll angle [rad]
      0];  % heading angle [rad]

      % Generate time values for a 4 second duration.
ts = linspace(0, 4, 200);  % time values

% Set the inputs to constant values.
r = [0;  % steer rate [rad/s]
     5*pi/180];  % steer angle [rad/s]

% Define all of the numerical values for the constant parameters in a structure.
p.m = 87;  % kg
p.g = 9.81;  % m/s^2
p.h = 1.0;  % m
p.a = 0.5;  % m
p.b = 1.0;  % m
p.v = 5.0;  % m/s
p.I = 3.28;  % kg m^2

% Setup the anonymous function for ode45.
eval_bicycle_rhs_anon = @(t, x) eval_bicycle_rhs(t, x, r, p);

% Integrate the ODEs (simulate) with ode45.
[ts, xs] = ode45(eval_bicycle_rhs_anon, ts, x0);

% plot the results
figure(1)
plot(ts, xs*180/pi)
xlabel('Time [s]')
legend('\omega [deg/s]', '\theta [deg]', '\psi [deg]')

% this is a second simulation of the same model but it has an input function
% with a controller

% add a parameters for the proportional control input
p.kp = 2.5; % proportional gain

% define a new anonymous function that makes use of the input function
eval_bicycle_rhs_anon2 = ...
    @(t, x) eval_bicycle_rhs2(t, x, @eval_steer_control_input, p);

% simulate
[ts, xs] = ode45(eval_bicycle_rhs_anon2, ts, x0);

% plot the state trajectories
figure(2)
plot(ts, xs*180/pi)
xlabel('Time [s]')
legend('\omega [deg/s]', '\theta [deg]', '\psi [deg]')

% plot the input trajectories
rs = zeros(length(ts), 2);
for i = 1:length(ts)
    rs(i, :) = eval_steer_control_input(ts(i), xs(i, :), p);
end
figure(3)
plot(ts, rs*180/pi)
xlabel('Time [s]')
legend('\beta [deg/s]', '\delta [deg]')