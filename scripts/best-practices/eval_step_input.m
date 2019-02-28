function r = eval_step_input(t, x, p)
    % EVAL_STEP_INPUT - Returns the input vector at any given time.
    %
    % Syntax: r = eval_step_input(t, x, p)
    %
    % Inputs:
    %   t - A scalar value of time, size 1x1.
    %   x - State vector at time t, size mx1 were m is the number of states.
    %   p - Constant parameter vector, size px1 were p is the number of parameters.
    % Outputs:
    %   r - Input vector at time t, size ox1.

    if t > 1.0
        tau = 5.0;
    else
        tau = 0.0;
    end

    r = [tau];

end
