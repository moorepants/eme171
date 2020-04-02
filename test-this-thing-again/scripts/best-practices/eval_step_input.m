function r = eval_step_input(t, x, p)
% EVAL_STEP_INPUT - Returns the input vector at any given time.
%
% Syntax: r = eval_step_input(t, x, p)
%
% Inputs:
%   t - Scalar value of time, size 1x1.
%   x - State vector at time t, size mx1 where m is the number of states.
%   p - Constant parameter structure with p items where p is the number of
%       parameters.
% Outputs:
%   r - Input vector at time t, size ox1 where o is the number of inputs.

% NOTE : x and p are not used in this case

% calculate the step input
if t > 1.0
    tau = 0.5;  % [N]
else
    tau = 0.0; % [N]
end

% pack the input values into a ox1 vector
r = [tau];

end
