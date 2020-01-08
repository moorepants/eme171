function xdot = eval_rhs_with_input_template(t, x, w, c)
% EVAL_RHS_WITH_INPUT_TEMPLATE - Returns the time derivative of the states,
% i.e.  evaluates the right hand side of the explicit ordinary differential
% equations for the 1 DoF quarter car model.
%
% Syntax: xdot = eval_rhs_with_input_template(t, x, w, c)
%
% Inputs:
%   t - Scalar value of time, size 1x1.
%   x - State vector at time t, size 3x1, [p, q, yin]
%   w - Anonymous function, w(t, x, p), that returns the input vector
%       at time t, size 1x1.
%   c - Constant parameter structure with 4 items: K, B, M, A.
% Outputs:
%   xdot - Time derivative of the states at time t, size 3x1.

% unpack the states into useful variable names
% replace the question marks with useful variable names
? = x(1);
? = x(2);
? = x(3);

% evaluate the input function
r = w(t, x, c);

% unpack the inputs into useful variable names
vin = r(1);

% unpack the parameters into useful variable names
m = c.m;
k = c.k;
b = c.b;

% calculate the derivatives of the state variables

replace this line of code with your lines of code

% pack the state derivatives into an mx1 vector
xdot = [pdot; qdot; ydot];

end
