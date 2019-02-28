function r = calc_inputs_step(t, x, p)
    % CALC_INPUTS_STEP - Returns the input vector at time t.
    %
    % Syntax: r = calc_inputs_step(t, x, p)
    %
    % Inputs:
    %   t - Scalar value of time, size 1x1.
    %   x - State vector at time t, size mx1 where m is the number of states.
    %   p - Constant parameter vector, size px1 were p is the number of parameters.
    % Outputs:
    %   r - Input vector at time t, size ox1..
     
    % unpack the state vector
    theta = x(1);
    omega = x(2);

    % unpack the parameters
    m = p(1);
    l = p(2);
    g = p(3);

    % calculate the inputs
    if t > 1.0
        tau = 0.5;
    else
        tau = 0.0;
    end

     % pack the input values into a ox1 vector  
     r = [tau];

end