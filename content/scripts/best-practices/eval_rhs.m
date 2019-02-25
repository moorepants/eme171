function xdot = eval_rhs(t, x, r, p)
     % EVAL_RHS - Returns the time derivative of the states, i.e. evaluates the
     % right hand side of the explicit ordinary differential equations.
     %
     % Syntax: xdot = eval_rhs(t, x, r, p)
     %
     % Inputs:
     %   t - Scalar value of time, size 1x1.
     %   x - State vector at time t, size mx1 where m is the number of states.
     %   r - Input vector at time t, size nx1 were n is the number of inputs.
     %   p - Constant parameter vector, size ox1 were p is the number of parameters.
     % Outputs:
     %   xdot - Time derivative of the states at time t, size mx1.

     % unpack the states into useful variable names
     theta = x(1);
     omega = x(2);

     % unpack the inputs into useful variable names
     tau = r(1);

     % unpack the parameters into useful variable names
     m = p(1);
     l = p(2);
     g = p(3);

     % calculate the state derivatives
     thetadot = omega;
     omegadot = (-m*g*l*sin(theta) + tau)/(m*l^2);

     % pack the state derivatives into an mx1 vector
     xdot = [thetadot; omegadot];

end
