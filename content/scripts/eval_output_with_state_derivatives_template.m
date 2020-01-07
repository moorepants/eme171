function z = eval_output_with_state_derivatives_template(t, xdot, x, r, p)
    % EVAL_OUTPUT_WITH_STATE_DERIVATIVES_TEMPLATE - Returns the output vector at the
    % specified time.
    %
    % Syntax: z = eval_output_with_state_derivatives(t, xdot, x, r, p)
    %
    % Inputs:
    %   t - Scalar value of time, size 1x1.
    %   xdot - State derivative vector as time t, size mx1 where m is the
    %          number of states
    %   x - State vector at time t, size 3x1 where m is the number of
    %       states. Representing sprung mass momentum, spring deflection and road input displacement.
    %   r - Input vector at time t, size ox1 were o is the number of inputs.
    %   p - Constant parameter structure with p items where p is the number
    %       of parameters.
    % Outputs:
    %   z - Output vector at time t, size 3x1.

    % unpack all the vectors
     
    % unpack the parameters
    m = p.m;
    k = p.k;
    b = p.b;

    % calculate the force applied to the spring
     = ;

    % calculate the force applied to the damper
     = ;
       
    % calculate the vertical acceleration of the mass 
     = ;
      
    % pack the outputs into a qx1 vector
    z = [ ];

  end

