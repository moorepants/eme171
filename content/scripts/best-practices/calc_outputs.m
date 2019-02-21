   function y = calc_outputs(t, x, r, p)

     theta = x(:, 1);
     ometa = x(:, 2);

     l = p(2);

     x_pos = l.*cos(theta);
     y_pos = l.*sin(theta);
     
     y = [x_pos y_pos];

   end