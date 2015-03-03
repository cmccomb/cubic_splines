X = [1 2 3 4];
Y = [0 1 0 1];

f = cubic_spline(X, Y);

disp(f(1));
disp(f(4));