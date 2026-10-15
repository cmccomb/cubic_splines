function f = cubic_spline(x, y)
%CUBIC_SPLINE Return a function handle for natural cubic interpolation.
%   F = CUBIC_SPLINE(X,Y) interpolates the data at strictly increasing,
%   finite knots X and returns a function handle F. F accepts scalar or
%   array-valued queries inside [X(1), X(end)] and preserves their shape.
%   The second derivative is zero at both endpoints. Querying outside the
%   knot range raises an error rather than extrapolating silently.

    validateattributes(x, {'numeric'}, ...
        {'vector', 'real', 'finite', 'nonempty'}, mfilename, 'x', 1);
    validateattributes(y, {'numeric'}, ...
        {'vector', 'real', 'finite', 'nonempty'}, mfilename, 'y', 2);

    if numel(x) ~= numel(y) || numel(x) < 2
        error('cubic_spline:InputSize', ...
            'x and y must have the same number of elements (at least two).');
    end

    x = double(x(:).');
    y = double(y(:).');
    h = diff(x);
    if any(h <= 0)
        error('cubic_spline:KnotsNotIncreasing', ...
            'x must contain distinct, strictly increasing knots.');
    end

    n = numel(x);
    second = zeros(1, n);
    if n > 2
        interiorCount = n - 2;
        diagonal = 2 * (h(1:end-1) + h(2:end));
        system = sparse(1:interiorCount, 1:interiorCount, ...
            diagonal, interiorCount, interiorCount);
        if n > 3
            offDiagonal = h(2:end-1);
            upper = sparse(1:interiorCount-1, 2:interiorCount, ...
                offDiagonal, interiorCount, interiorCount);
            system = system + upper + upper.';
        end
        slopes = diff(y) ./ h;
        rhs = 6 * diff(slopes);
        second(2:end-1) = (system \ rhs(:)).';
    end

    f = @(query) evaluateSpline(query, x, y, h, second);
end

function values = evaluateSpline(query, x, y, h, second)
    validateattributes(query, {'numeric'}, {'real', 'finite'}, ...
        'cubic_spline function handle', 'query');
    if any(query(:) < x(1) | query(:) > x(end))
        error('cubic_spline:QueryOutOfRange', ...
            'Query points must lie within the knot range.');
    end
    if isempty(query)
        values = zeros(size(query));
        return
    end

    shape = size(query);
    q = double(query(:));
    interval = min(numel(x) - 1, interp1(x, 1:numel(x), q, 'previous'));
    width = reshape(h(interval), [], 1);
    left = (reshape(x(interval + 1), [], 1) - q) ./ width;
    right = (q - reshape(x(interval), [], 1)) ./ width;
    v = left .* reshape(y(interval), [], 1) ...
        + right .* reshape(y(interval + 1), [], 1) ...
        + ((left.^3 - left) .* reshape(second(interval), [], 1) ...
        + (right.^3 - right) .* reshape(second(interval + 1), [], 1)) ...
        .* (width.^2 / 6);
    values = reshape(v, shape);
end
