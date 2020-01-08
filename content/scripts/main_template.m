% integrate the ODEs as defined above
x0 = [ ; ; ];
ts = ;
p.m = ;
p.k = ;
p.b = ;
p.amp = ;
f_anon = @(t, x) eval_rhs_with_input(t, x, @eval_input, p);
[ts, xs] = ode45(f_anon, ts, x0);

% to compute the outputs at each time, loop through time evaluating f(t, x,
% r, p) and then h(t, x', x, r, p)
zs = zeros(length(ts), 3);  % place to store outputs
xdot = zeros(length(ts), 3);  % place to store outputs
for i=1:length(ts)
    % calculate x' at the given time
    xdot = eval_rhs_with_input(ts(i), xs(i, :), @eval_input, p);
    % calculate the outputs that depend on x' and store them
    zs(i, :) = eval_output_with_state_derivatives(ts(i), xdot, xs(i, :), @eval_input, p);
end