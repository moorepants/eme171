   % create an initial condition vector, mx1
   x0 = [5*pi/180; 0];

   % create time values
   ts = linspace(0, 10, 500);

   % 3x1 constant parameter vector.
   % p = [m, l, g];
   p = [1; 1; 9.81];
   
   % check if the input function works
   calc_inputs_step(5.0, x0, p)
   
   % check if the eval_rhs funciton works
   eval_rhs(5.0, x0, @calc_inputs_step, p)

   % create an anonymous function with the required inputs for ode45(), i.e. (t, x).
   f_anon = @(t, x) eval_rhs(t, x, @calc_inputs_step, p);

   % Now the equations can be integrated.
   [ts, xs] = ode45(f_anon, ts, x0);
   
   % ts 500 x 1
   % xs 500 x 2

   ys = calc_outputs(ts, xs, @calc_inputs_step, p);