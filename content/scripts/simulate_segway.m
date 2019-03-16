%% define all constant parameters and store in a structure
p.g = 9.81;  % acceleration due to gravity [m/s^2]
p.mp = 75.0;  % person + platform mass [kg]
p.Jp = 14.0;  % person + platform inertia [kg m^2]
p.lp = 0.9;  % center of mass [m]
p.d = 0.4;  % wheel diameter [m]
p.mw = 6;  % wheel mass [kg]
p.Jw = p.mw*(p.d/2)^2;  % wheel inertia [kg m^2]
p.T = 12;  % dc motor constant [Nm/A]
p.R = 8;  % dc motor winding resistance [O]
p.L = 0.5;  % dc motor wiinding inductance, [H]

%% calculate the state and input matrices
[A, B] = segway_state_space(p);

%% calculate the eigenvalues and eigenvectors of the state matrix
[evecs, evals] = eig(A);
display('Eigenvalues');
evals
display('Eigenvectors');
evecs

%% check to see if a simple proportional feedback of q8 will stabilize the
%% system
% create a SISO plant input: e, output: q8 and control: e=-k*q8.
C = [0, 0, 1, 0];  % i.e. y = q8
sys = ss(A, B(:, 1), C, 0);
[num, den] = ss2tf(sys);
q8_e = tf(num, den)
% see if proportional feedback can stabilize using root locus graph
figure;
rlocus(q8_e)

%% try a PID controller (manually selected gains)
pid_controller = pid(500, 50, 5);
feedback(q8_e, pid_controller)
display('Eigenvalues of PID controlled system')
eig(feedback(q8_e, pid_controller))


%% try a linear quadratic regulator controller
if rank(ctrb(A, B(:, 1))) == length(A)
    display('System is controllable with full state feedback')
end
Q = eye(4);
R = 1;
[G, X, L] = lqr(A, B(:, 1), Q, R);
display('Eigenvalues of PID controlled system')
L

%% simulate the system with the LQR controller
final_time = 6.0;
ts = linspace(0, final_time, num=final_time*60);

f = @(t, x) eval_segway_rhs(t, x, @eval_segway_input, p, A, B, G);

% set the initial forward lean angle to 20 degrees
x0 = [0.0; 0.0; -20*pi/180; 0.0; 0.0];

[ts, xs] = ode45(f, ts, x0);

% calculate the inputs and outputs of the simulation
us = zeros(length(ts), 2);
ys = zeros(length(ts), 5);
for i = 1:length(ts)
    us(i, :) = eval_segway_input(ts(i), xs(i, :)', p, G);
    ys(i, :) = eval_segway_output(ts(i), xs(i, :)', @eval_segway_input, p, G);
end

% save all simulation input and output data to a file
save('-v6', 'segway-sim-data.mat', 'ts', 'xs', 'ys', 'us', 'p');

%% plot the simulation results
figure(1);
plot(ts, xs);
legend('p3', 'p7', 'q8', 'p17', 'xw');

figure(2);
plot(ts, ys);
legend('xw', 'yw', 'xp', 'yp', 'P');

figure(3);

subplot(611)
plot(ts, us(:, 2));
ylabel('Wind force [N]');

subplot(612)
plot(ts, us(:, 1));
ylabel('Applied Voltage [V]');

subplot(613)
plot(ts, 180/pi*xs(:, 3));
ylabel('Angle [deg]');

subplot(614)
plot(ts, ys(:, 1));
ylabel('Wheel Location [m]');

subplot(615)
plot(ts, 180/pi*xs(:, 4)/p.Jw);
ylabel('Wheel Speed [deg/s]');

subplot(616)
plot(ts, ys(:, 5));
ylabel('Power [Watts]');
