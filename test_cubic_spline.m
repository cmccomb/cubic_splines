% Basic interpolation, including both endpoints and vector-valued queries.
f = cubic_spline([0 1 2], [0 1 0]);
assert(max(abs(f([0 1 2]) - [0 1 0])) < 1e-12);
assert(abs(f(0.5) - 0.6875) < 1e-12);
assert(isequal(size(f([0 0.5; 1 2])), [2 2]));

% Nonuniform knots and column-vector inputs use the same natural spline.
g = cubic_spline([0; 1; 3], [0; 1; 0]);
assert(abs(g(0.5) - 0.59375) < 1e-12);
assert(abs(g(2) - 0.875) < 1e-12);
assert(isequal(size(g([0; 1; 3])), [3 1]));

% More than one interior knot exercises the coupled spline system.
fourKnots = [0 1 2 4];
fourValues = [0 1 -1 2];
multi = cubic_spline(fourKnots, fourValues);
assert(max(abs(multi(fourKnots) - fourValues)) < 1e-12);
matrixValues = multi([0 1.5; 2 4]);
assert(isequal(size(matrixValues), [2 2]));
assert(max(abs(matrixValues(:) - multi([0; 2; 1.5; 4]))) < 1e-12);

% Two points reduce to a straight line.
line = cubic_spline([2 5], [4 10]);
assert(abs(line(3) - 6) < 1e-12);

% Reject ambiguous data and queries rather than returning wrong values.
assertError(@() cubic_spline([0 1 1], [0 1 2]), ...
    'cubic_spline:KnotsNotIncreasing');
assertError(@() cubic_spline([0 1], [0]), 'cubic_spline:InputSize');
assertError(@() f(-0.1), 'cubic_spline:QueryOutOfRange');
assertError(@() f(2.1), 'cubic_spline:QueryOutOfRange');

function assertError(action, identifier)
    try
        action();
    catch exception
        assert(strcmp(exception.identifier, identifier));
        return
    end
    error('test_cubic_spline:ExpectedError', ...
        'Expected an error with identifier %s.', identifier);
end
