% This m file simulates the linear motion of a simple electric bicycle model
% traveling over a 2D sinusoidal road. The sinusoidal road is defined by its
% amplitude, H, and the horizontal distance corresponding to the "period" of
% the road. The states are wheel angle theta, wheel angular rate omega,
% motor current i, and horizontal distance traveled x. The no-slip
% constraint provides that the forward speed v is equal to the angular rate
% time the wheel speed.

% define numerical constants
p.A = 0.5;  % frontal area [m^2]
p.Cd = 1.1;  % coefficient of drag [unitless]
p.Cr = 0.005;  % coefficient of rolling resistance [unitless]
p.H = 3;  % amplitude of sine curve road [m]
p.J = 0.24;  % wheel moment of inertia [kg m^2]
p.Kt = 1.5;  % motor torque constant [N*m/A]
p.L = 0.5;  % motor inductance [H]
p.R = 0.3;  % wheel radius [m]
p.Rw = 1;  % motor winding resistance [Ohm]
p.V = 50;  % throttle voltage amplitude [V]
p.X = 5;  % x distance for one period of sine curve road [m]
p.bm = 0.2;  % hub friction coefficient [N*m*s]
p.g = 9.81;  % acceleration due to gravity [m/s^2]
p.m = 100;  % mass of bike and rider [kg]
p.rho = 1.2;  % density of air [kg/m^3]

% create an anoymous function to pass in inputs and parameters, provide the
% input function that creates a constant voltage and sinusoidal road
rhs = @(t, s) eval_ebike_rhs(t, s, @eval_ebike_input, p);

% integrate the dynamic equations over 60 seconds with the initinal
% condition at zero
[t, res] = ode45(rhs, linspace(0, 60), [0, 0, 0, 0]);

% extract the states from the integration results
theta = res(:, 1);
omega = res(:, 2);
i = res(:, 3);
x = res(:, 4);

% plot the variables of interest versus time
figure(1);
plot(t, 180/pi*theta);
ylabel('\theta [deg]');
xlabel('Time [s]');

figure(2);
plot(t, 180/pi*omega);
ylabel('\omega [deg/s]');
xlabel('Time [s]');

figure(3);
plot(t, i);
ylabel('i [A]');
xlabel('Time [s]');

figure(4);
plot(t, x);
ylabel('x [m]');
xlabel('Time [s]');

figure(5);
plot(t, omega*p.R);
ylabel('v [m/s]');
xlabel('Time [s]');

figure(6);
plot(t, p.V*i)
xlabel('Time [s]');
ylabel('Power [W]')
