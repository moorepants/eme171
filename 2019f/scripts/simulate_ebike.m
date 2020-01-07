% This m file simulates the linear motion of a simple electric bicycle model
% traveling over a 2D sinusoidal road. The sinusoidal road is defined by its
% amplitude, H, and the horizontal distance corresponding to the "period" of
% the road. The states are wheel angle theta, wheel angular rate omega,
% motor current i, and horizontal distance traveled x. The no-slip
% constraint provides that the forward speed v is equal to the angular rate
% time the wheel speed.

% define numerical constants
m = 100;  % mass of bike and rider [kg]
R = 0.3;  % wheel radius [m]
Cr = 0.005;  % coefficient of rolling resistance [unitless]
Cd = 1.1;  % coefficient of drag [unitless]
rho = 1.2;  % density of air [kg/m^3]
A = 0.5;  % frontal area [m^2]
g = 9.81;  % acceleration due to gravity [m/s^2]
J = 0.24;  % wheel moment of inertia [kg m^2]
bm = 0.2;  % hub friction coefficient [N*m*s]
Kt = 1.5;  % motor torque constant [N*m/A]
L = 0.5;  % motor inductance [H]
Rw = 1;  % motor winding resistance [Ohm]
X = 5;  % x distance for one period of sine curve road [m]
H = 3;  % amplitude of sine curve road [m]

% pack constant parameters into a 1d vector
p = [m; R; Cr; Cd; rho; A; g; J; bm; Kt; L; Rw; X; H];

% apply a constant voltage (throttle applies 50 volts)
V = 50;  % voltage [V]

% create an anoymous function to pass in inputs and parameters
rhs = @(t, s) eval_ebike_rhs(t, s, V, p);

% integrate the dynamic equations over 60 seconds with the initinal
% condition at zero
[t, res] = ode45(rhs, linspace(0, 60), [0, 0, 0, 0]);

% extract the states from the integration results
theta = res(:, 1);
omega = res(:, 2);
i = res(:, 3);
x = res(:, 4);

% plot the variables of interest versus time
subplot(6, 1, 1);
plot(t, 180/pi*theta);
ylabel('\theta [deg]');
xlabel('Time [s]');

subplot(6, 1, 2);
plot(t, 180/pi*omega);
ylabel('\omega [deg/s]');
xlabel('Time [s]');

subplot(6, 1, 3);
plot(t, i);
ylabel('i [A]');
xlabel('Time [s]');

subplot(6, 1, 4);
plot(t, x);
ylabel('x [m]');
xlabel('Time [s]');

subplot(6, 1, 5);
plot(t, omega*R);
ylabel('v [m/s]');
xlabel('Time [s]');

subplot(6, 1, 6)
plot(t, V*i)
xlabel('Time [s]');
ylabel('Power [W]')
