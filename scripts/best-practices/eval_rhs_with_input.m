function xdot = eval_rhs_with_input(t, x, w, p)
% EVAL_RHS_WITH_INPUT - Returns the time derivative of the states, i.e.
% evaluates the right hand side of the explicit ordinary differential
% equations.
%
% Syntax: xdot = eval_rhs_with_input(t, x, w, p)
%
% Inputs:
%   t - Scalar value of time, size 1x1.
%   x - State vector at time t, size mx1 where m is the number of states.
%   w - Anonymous function, w(t, x, p), that returns the input vector at
%       time t, size ox1 were o is the number of inputs.
%   p - Constant parameter structure with p items where p is the number of
%       parameters.
% Outputs:
%   xdot - Time derivative of the states at time t, size mx1.

% unpack the states into useful variable names
theta = x(1);
omega = x(2);

% evaluate the input function
r = w(t, x, p);

% unpack the inputs into useful variable names
tau = r;
% if more than one input, then tau = r(1);, ...

% unpack the parameters into useful variable names
m = p.m;
l = p.l;
g = p.g;

% calculate the state derivatives
thetadot = omega;
omegadot = (-m*g*l*sin(theta) + tau)/(m*l^2);

% pack the state derivatives into an mx1 vector
xdot = [thetadot; omegadot];

end
