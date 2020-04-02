function r = eval_input(t, x, p)
% EVAL_INPUT - Returns the input vector at any given time.
%
% Syntax: r = eval_input(t, x, p)
%
% Inputs:
%   t - A scalar value of time, size 1x1.
%   x - State vector at time t, size mx1 were m is the number of states.
%   p - Constant parameter structure with p items where p is the number of
%       parameters.
% Outputs:
%   r - Input vector at time t, size ox1 where o is the number of inputs.

% NOTE : x is not needed in this case, so no need to unpack it

% unpack the structure
m = p.m;
l = p.l;
g = p.g;

% define a sinusoidal time varying input
tau = m*g*l/2*sin(pi/20*t);

% pack the inputs into an 1x1 vector
r = [tau];

end
