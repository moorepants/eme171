function y = eval_output(t, x, r, p)
    % EVAL_OUTPUT - Returns the output vector at the specified time.
    %
    % Syntax: y = eval_output(t, x, r, p)
    %
    % Inputs:
    %   t - Scalar value of time, size 1x1.
    %   x - State vector at time t, size mx1 where m is the number of
    %       states.
    %   r - Input vector at time t, size ox1 where o is the number of
    %       inputs.
    %   p - Constant parameter structure with p items where p is the number
    %       of parameters.
    % Outputs:
    %   y - Output vector at time t, size qx1 where q is the number of
    %       outputs.

    % unpacke the states
    theta = x(1);
    omega = x(2);

    % unpack the parameters
    m = p.m;
    l = p.l;
    g = p.g;

    % calculate the Cartesian position of the pendulum bob
    x_pos = l*sin(theta);
    y_pos = l - l*cos(theta);  % position relative to stable equilibrium

    % calculate the kinetic and potential energies
    kinetic_energy = m*l^2*omega^2/2;
    potential_energy = m*g*y_pos;

    % pack the outputs into a qx1 vector
    y = [x_pos; y_pos; kinetic_energy; potential_energy];

end
