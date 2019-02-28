function ys = eval_output_vectorized(ts, xs, rs, p)
    % EVAL_OUTPUT_VECTORIZED - Returns the output vector at the specified times.
    %
    % Syntax: ys = eval_output_vectorized(ts, xs, rs, p)
    %
    % Inputs:
    %   ts - Scalar values of time, size nx1.
    %   xs - State vector at each time, size nxm where m is the number of
    %        states.
    %   rs - Input vector at each time, size nxo were o is the number of inputs.
    %   p - Constant parameter vector, size px1 were p is the number of
    %       parameters.
    % Outputs:
    %   ys - Output vector at each time, size nxq where q is the number of outputs.
    
    if size(xs)(1) > 1
        xs = xs';
    end
    
    if size(rs)(1) > 1
        rs = rs';
    end

    % unpack the state trajectories
    theta = xs(:, 1);  % size n
    omega = xs(:, 2);  % size n

    m = p(1);
    l = p(2);
    g = p(3);

    % make sure to use elementwise operators, e.g. .* instead of *
    x_pos = l.*cos(theta);
    y_pos = l.*sin(theta);

    kinetic_energy = m.*l.^2.*omega.^2/2;
    potential_energy = m.*g.*y_pos;

    % pack the results so the function returns a size nxq result (use commas)
    ys = [x_pos, y_pos, kinetic_energy, potential_energy];
    
    % ensures this function returns a column vector if used with scalar t
    if length(ts) == 1
        ys = ys';
    end

end
