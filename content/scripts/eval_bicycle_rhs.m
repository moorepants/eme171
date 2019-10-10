function xdot = eval_bicycle_rhs(t, x, r, p)

% unpack states
omega = x(1);
theta = x(2);
psi = x(3);

% unpack inputs
beta = r(1); % steer rate
delta = r(2); % steer angle

% unpack parameters
m = p(1);
g = p(2);
h = p(3);
a = p(4);
b = p(5);
v = p(6);
I = p(7);

% calculate the state derivatives
omegadot = (m*g*h*theta - m*h/b*(a*v*beta + v^2*delta))/(I + m*h^2);
thetadot = omega;
psidot = v/b*tan(delta);

% pack up the results
xdot = [omegadot; thetadot; psidot];
    
end