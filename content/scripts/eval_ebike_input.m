function r = eval_ebike_input(t, s, p)
% EVAL_EBIKE_INPUT - Returns the angle of the sinusoidal road at time t and
% the voltage applied to the throttle.
%
% Syntax: r = eval_ebike_input(t, s, p)
%
% Inputs:
%   t - Scalar value of time, size 1x1.
%   s - State vector at time t, size 4x1.
%   p - Constant parameter structure with 14 constants: m, R, Cr, Cd, rho,
%       A, g, J, bm, Kt, L, Rw, X, H.
% Outputs:
%   r - Input vector at time t, size 2x1, [voltage, alpha]

% unpack the necessary states
x = s(4);  % x distance traveled [m]

% unpack the necessary constants
X = p.X;  % distance between sinusoidal road peaks [m]
H = p.H;  % amplitude of sinusoidal road peaks [m]

% voltage is constant with respect to time
voltage = p.V;  % voltage [V]

% calculate the road angle at this x location on the sine curve road
wr = 1/2/pi/X;  % road angular change per unit distance traveled [rad/m]
slope = H*wr*cos(wr*x);  % road slope at location x [m/m]
alpha = atan(slope);  % road angle at locatoin x [rad]

r = [voltage, alpha];

end
