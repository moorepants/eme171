% this is the simulation we did in class of the bicycle balance model
x0 = [0; 0; 0];  % one initial condition for each state
ts = linspace(0, 4, 200);  % time values
r = [0; 5*pi/180];  % using constant values for the inputs
p.m = 87;
p.g = 9.81;
p.h = 1.0;
p.a = 0.5;
p.b = 1.0;
p.v = 5.0;
p.I = 3.28;
eval_bicycle_rhs_anon = @(t, x) eval_bicycle_rhs(t, x, r, p);
[ts, xs] = ode45(eval_bicycle_rhs_anon, ts, x0);
figure(1)
plot(ts, xs*180/pi)
xlabel('Time [s]')
legend('\omega [deg/s]', '\theta [deg]', '\psi [deg]')

% this is a second simulation of the same model but it has an input function
x0 = [0; 5*pi/180; 0];
% add two more parameters for the control input (PD controller)
p.kp = 2.5; % proportional gain
p.kd = 0.5;  % derivative gain
eval_bicycle_rhs_anon2 = ...
    @(t, x) eval_bicycle_rhs2(t, x, @eval_steer_control_input, p);
[ts, xs] = ode45(eval_bicycle_rhs_anon2, ts, x0);
figure(2)
plot(ts, xs*180/pi)
xlabel('Time [s]')
legend('\omega [deg/s]', '\theta [deg]', '\psi [deg]')
