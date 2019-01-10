function simulate_ebike()
  % This m file simulates the linear motion of a simple electric bicycle model.
  % The states are wheel angle theta, wheel angular rate omega, motor current i,
  % and distance traveled x. The no-slip constraint provides that the forward
  % speed v is equal to the angular rate time the wheel speed.

  % integrate the dynamic equations over 20 seconds
  [t, res] = ode45(@rhs, linspace(0, 20), [0, 0, 0, 0]);

  % extract the states from the integration results
  theta = res(:, 1);
  omega = res(:, 2);
  i = res(:, 3);
  x = res(:, 4);

  % plot the variables of interest versus time
  subplot(5, 1, 1);
  plot(t, 180/pi*theta);
  ylabel('\theta [deg]');
  xlabel('Time [s]');

  subplot(5, 1, 2);
  plot(t, 180/pi*omega);
  ylabel('\omega [deg/s]');
  xlabel('Time [s]');

  subplot(5, 1, 3);
  plot(t, i);
  ylabel('i [A]');
  xlabel('Time [s]');

  subplot(5, 1, 4);
  plot(t, x);
  ylabel('x [m]');
  xlabel('Time [s]');

  R = 0.3;  % wheel radius [m] (change in rhs function too)
  subplot(5, 1, 5);
  plot(t, omega*R);
  ylabel('v [m/s]');
  xlabel('Time [s]');

end

function dy = rhs(t, y)
  % evaluates the right hand side of the first order ordinary differential equations

  % define numerical constants
  m = 100;  % mass [kg]
  R = 0.3;  % wheel radius [m]
  Cr = 0.005;  % coefficient of rolling resistance [unitless]
  Cd = 1.1;  % coefficient of drag [unitless]
  rho = 1.2;  % density of air [kg/m^3]
  A = 0.5;  % frontal area [m^2]
  g = 9.81;  % acceleration due to gravity [m/s^2]
  J = 0.24;  % wheel moment of inertia [kg m^2]
  bm = 0.2;  % hub friction coefficient [N*m*s]
  Kt = 1.5;  % motor torque constant [N*m/A]
  L = 0.5;  % motor inductance [H]
  Rw = 1;  % motor winding resistance [Ohm]

  % extract the states
  theta = y(1);
  omega = y(2);
  i = y(3);
  x = y(4);

  % apply a constant voltage (throttle applies 50 volts)
  V = 50;  % voltage [V]

  % evaluate the right hand side of the ode's
  v = omega*R;  % v-omega relationship from no-slip tires

  Fd = 1/2*rho*Cd*A*v^2;  % drag force [N]
  Fr = Cr*m*g;  % rolling resistant [N]

  % four 1st order ordinary differential equations in explicit form
  thetadot = omega;
  omegadot = (Kt*i - bm*omega - Fd*R - Fr*R) / (2*J + m*R^2);
  idot = (-Rw*i - Kt*omega + V)/L;
  xdot = v;

  % store the result in a vector
  dy(1) = thetadot;
  dy(2) = omegadot;
  dy(3) = idot;
  dy(4) = xdot;

end