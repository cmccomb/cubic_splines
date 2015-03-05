% Make a random data set
X = [1 2 3 4];
Y = [0 1 0 1];

% Make a cubic spline
f = cubic_spline(X, Y);

% Test the 4 data points
for i=1:1:length(X)
    assert(f(X(i)) == Y(i));
end
