      function r = eval_input_template(t, x, p)
      % EVAL_INPUT_TEMPLATE - Returns the input vector at any given time.
      %
      % Syntax: r = eval_input(t, x, p)
      %
      % Inputs:
      %   t - A scalar value of time, size 1x1.
      %   x - State vector at time t, size 3x1 where the states are mass momentum, spring deflection and road height.
      %   p - Constant parameter structure with p items where p is the number of
      %       parameters.
      % Outputs:
      %   r - Input vector at time t, size ox1 where o is the number of
      %       inputs.  In this case, 1.

      % NOTE : x is not needed in this case
      
      % unpack structure
      amp = p.amp;
      
      % define a triangular road bump input
  
      % pack the inputs into an 1x1 vector
      r = [vin];

  end

