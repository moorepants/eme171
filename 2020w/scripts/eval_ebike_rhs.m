function sdot = eval_ebike_rhs(t, s, w, p)
% EVAL_EBIKE_RHS - Returns the time derivative of the states, i.e. evaluates
% the right hand side of the explicit ordinary differential equations.
%
% Syntax: sdot = eval_rhs(t, s, r, p)
%
% Inputs:
%   t - Scalar value of time, size 1x1.
%   s - State vector at time t, size 5x1: [theta, omega, i, x, e]'.
%   w - Function that returns the road angle input.
%   p - Constant parameter structure with 14 constants: m, R, Cr, Cd, rho,
%       A, g, J, bm, Kt, L, Rw, X, H.
% Outputs:
%   sdot - Time derivative of the states at time t, size mx1.

% unpack the states
theta = s(1);  % rotation angle of the wheel [rad]
omega = s(2);  % angular rate of the wheel [rad/s]
i = s(3);  % motor current [A]
x = s(4);  % x distance traveled [m]
e = s(5);  % energy [J]

% unpack the constant parameters
m = p.m;
R = p.R;
Cr = p.Cr;
Cd = p.Cd;
rho = p.rho;
A = p.A;
g = p.g;
J = p.J;
bm = p.bm;
Kt = p.Kt;
L = p.L;
Rw = p.Rw;

% calculate the road angle using the provided input function
r = w(t, s, p);

% unpack the input vector
V = r(1);
alpha = r(2);

% calculate some intermediate quantities for evaluating the ODEs
v = omega*R;  % v-omega relationship from no-slip tires
Fd = 1/2*rho*Cd*A*v^2;  % drag force [N]
Fr = Cr*m*g*cos(alpha);  % rolling resistant [N]
Fg = m*g*sin(alpha);  % gravity force [N]

% evaluate the four 1st order explicit ordinary differential equations
thetadot = omega;
omegadot = (Kt*i - bm*omega - Fd*R - Fr*R - Fg*R) / (2*J + m*R^2);
idot = (-Rw*i - Kt*omega + V)/L;
xdot = v*cos(alpha);
edot = V*i;

% pack the state derivatives in a vector
sdot = [thetadot; omegadot; idot; xdot; edot];

end
