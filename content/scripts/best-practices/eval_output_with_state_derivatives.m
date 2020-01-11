function z = eval_output_with_state_derivatives(t, xdot, x, r, p)
% EVAL_OUTPUT_WITH_STATE_DERIVATIVES - Returns the output vector at the
% specified time.
%
% Syntax: z = eval_output_with_state_derivatives(t, xdot, x, r, p)
%
% Inputs:
%   t - Scalar value of time, size 1x1.
%   xdot - State derivative vector as time t, size mx1 where m is the number
%          of states.
%   x - State vector at time t, size mx1 where m is the number of states.
%   r - Input vector at time t, size ox1 were o is the number of inputs.
%   p - Constant parameter structure with p items where p is the number of
%       parameters.
% Outputs:
%   z - Output vector at time t, size qx1.

% unpack all of the vectors
thetadot = xdot(1);
omegadot = xdot(2);

theta = x(1);
omega = x(2);

m = p.m;
l = p.l;
g = p.g;

% calculate the radial and tangential accelerations
radial_acc = omega^2 * l;
tangential_acc = omegadot * l;

% pack the result into a qx1 vector
z = [radial_acc; tangential_acc];

end
