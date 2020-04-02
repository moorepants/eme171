function ys = eval_output_vectorized(ts, xs, rs, p)
% EVAL_OUTPUT_VECTORIZED - Returns the output vector at the specified times.
%
% Syntax: ys = eval_output_vectorized(ts, xs, rs, p)
%
% Inputs:
%   ts - Scalar values of time, size nx1.
%   xs - State vector at each time, size nxm where m is the number of states
%        or mx1 if n=1.
%   rs - Input vector at each time, size nxo where o is the number of inputs
%        or ox1 if n=1.
%   p - Constant parameter structure with p items where p is the number of
%       parameters.
% Outputs:
%   ys - Output vector at each time, size nxq where q is the number of
%        outputs or qx1 if n=1.

% for n=1, tranpose
if length(ts) == 1
    xs = xs';  % 1xm
    rs = rs';  % 1xo
end

% unpack the state trajectories
theta = xs(:, 1);  % size n
omega = xs(:, 2);  % size n

% unpack the parameters
m = p.m;
l = p.l;
g = p.g;

% NOTE : rs is not used in this case

% make sure to use elementwise operators, e.g. .* instead of * for
% vectorized calculations
x_pos = l.*sin(theta);
y_pos = l - l.*cos(theta);

kinetic_energy = m.*l.^2.*omega.^2./2;
potential_energy = m.*g.*y_pos;

% pack the results so the function returns a size nxq result (use commas)
ys = [x_pos, y_pos, kinetic_energy, potential_energy];

% ensures this function returns a column vector if n=1
if length(ts) == 1
    ys = ys';
end

end
