function z = eval_output_with_state_derivatives_template(t, xdot, x, r, c)
% EVAL_OUTPUT_WITH_STATE_DERIVATIVES_TEMPLATE - Returns the output vector at the
% specified time.
%
% Syntax: z = eval_output_with_state_derivatives_template(t, xdot, x, r, c)
%
% Inputs:
%   t - Scalar value of time, size 1x1.
%   xdot - State derivative vector as time t, size 3x1, [pdot, xdot, ydot].
%   x - State vector at time t, size 3x1, representing sprung mass momentum,
%       spring deflection and road input displacement.
%   r - Input vector at time t, size 1x1, [vin].
%   c - Constant parameter structure with 4 items: K, B, M, A.
% Outputs:
%   z - Output vector at time t, size 3x1, [Fspring, Fdamper, a].

% unpack xdot and x as needed

replace this line with your lines

% unpack the parameters
m = c.m;
k = c.k;
b = c.b;

% calculate the force applied to the spring

replace this line with your line(s)

% calculate the force applied to the damper

replace this line with your line(s)

% calculate the vertical acceleration of the mass

replace this line with your line(s)

% pack the outputs into a qx1 vector
z = [Fspring; Fdamper; a];

end
