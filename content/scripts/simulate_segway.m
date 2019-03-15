% store all parameters in a structure
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

[A, B] = segway_state_space(p);

[evecs, evals] = eig(A);

% Create a SISO plant input: e, output: q8
C = [0, 0, 1, 0];
sys = ss(A, B(:, 1), C, 0);
[num, den] = ss2tf(sys);
q8_e = tf(num, den)

% see if proportional feedback can stabilize
figure;
rlocus(q8_e)

% try a PID controller
pid_controller = pid(800, 200, 50);
feedback(q8_e, pid_controller)
eig(feedback(q8_e, pid_controller))

rank(ctrb(A, B(:, 1)))

% try a linear quadratic regulator
Q = eye(4);
%Q(2,2) = 1000;
%Q(3,3) = 1000;

[G, X, L] = lqr(A, B(:, 1), Q, 1);


f = @(t, x) eval_segway_rhs(t, x, @eval_segway_input, p, A, B, G);

final_time = 8.0;
ts = linspace(0, final_time, num=final_time*60);

x0 = [0.0; 0.0; 0.0; 0.0; 0.0];
x0 = [0.0; 0.0; -30*pi/180; 0.0; 0.0];

[ts, xs] = ode45(f, ts, x0);

us = zeros(length(ts), 2);
ys = zeros(length(ts), 5);
for i = 1:length(ts)
    us(i, :) = eval_segway_input(ts(i), xs(i, :)', p, G);
    ys(i, :) = eval_segway_output(ts(i), xs(i, :)', @eval_segway_input, p, G);
end

figure(1);
plot(ts, xs);
legend('p3', 'p7', 'q8', 'p17', 'xw');
%
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

save('-v6', 'segway-sim-data.mat', 'ts', 'xs', 'ys', 'us', 'p');

% create circle data
%th = 0:pi/50:2*pi;
%xunit = p.d/2 * cos(th) + ys(1, 1);
%yunit = p.d/2 * sin(th) + ys(1, 2);

%h1 = plot(xunit, yunit, 'b');
%hold on;
%h = plot([ys(1, 1), ys(1, 3)], [ys(1, 2), ys(1, 4)], 'k');
%
%xlim([min(ys(:, 3)) - p.d/2, max(ys(:, 3)) + p.d/2]);
%axis equal;
%
%for i = 1:length(ts)
    %set(h, 'XData', [ys(i, 1), ys(i, 3)]);
    %set(h, 'YData', [ys(i, 2), ys(i, 4)]);
    %xunit = p.d/2 * cos(th) + ys(i, 1);
    %set(h1, 'XData', xunit);
%end

