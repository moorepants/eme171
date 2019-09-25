function sdot = eval_ebike_rhs(t, s, r, p)
% EVAL_EBIKE_RHS - Returns the time derivative of the states, i.e. evaluates
% the right hand side of the explicit ordinary differential equations.
%
% Syntax: sdot = eval_rhs(t, s, r, p)
%
% Inputs:
%   t - Scalar value of time, size 1x1.
%   s - State vector at time t, size mx1 where m is the number of
%       states.
%   r - Input vector at time t, size ox1 were o is the number of
%       inputs.
%   p - Constant parameter vector, size px1 were p is the number of
%       parameters.
% Outputs:
%   sdot - Time derivative of the states at time t, size mx1.

% unpack the states
theta = s(1);  % rotation angle of the wheel [rad]
omega = s(2);  % angular rate of the wheel [rad/s]
i = s(3);  % motor current [A]
x = s(4);  % x distance traveled [m]

% unpack the input
V = r(1);  % voltage applied to motor [V]

% unpack the constant parameters
m = p(1);
R = p(2);
Cr = p(3);
Cd = p(4);
rho = p(5);
A = p(6);
g = p(7);
J = p(8);
bm = p(9);
Kt = p(10);
L = p(11);
Rw = p(12);
X = p(13);
H = p(14);

% calculate the road angle at this x location on the sine curve road
wr = 1/2/pi/X;
slope = H*wr*cos(wr*x);
alpha = atan(slope);

% caculate some intermediate quantities for evaluating the ODEs
v = omega*R;  % v-omega relationship from no-slip tires

% forces acting on e-bicyclist
Fd = 1/2*rho*Cd*A*v^2;  % drag force [N]
Fr = Cr*m*g*cos(alpha);  % rolling resistant [N]
Fg = m*g*sin(alpha);  % gravity force [N]

% evaluate the four 1st order explicit ordinary differential equations
thetadot = omega;
omegadot = (Kt*i - bm*omega - Fd*R - Fr*R - Fg*R) / (2*J + m*R^2);
idot = (-Rw*i - Kt*omega + V)/L;
xdot = v*cos(alpha);

% pack the state derivatives in a vector
sdot = [thetadot; omegadot; idot; xdot];

end
