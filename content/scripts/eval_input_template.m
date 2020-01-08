function r = eval_input_template(t, x, c)
% EVAL_INPUT_TEMPLATE - Returns the road bump velocity at any given time.
%
% Syntax: r = eval_input_template(t, x, c)
%
% Inputs:
%   t - A scalar value of time, size 1x1.
%   x - State vector at time t, size 3x1 where the states are [mass momentum,
%       spring deflection, and road height].
%   c - Constant parameter structure with 4 items: K, B, M, A
% Outputs:
%   r - Input vector at time t, size 1x1, [vin].

% unpack parameter structure p
A = c.A

% define a triangular road bump input by transcribing the input mathematical
% equation into equivalent code

replace this line with your code lines for the bump

% pack the input into an 1x1 vector
r = [vin];

end
