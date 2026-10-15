# cubic_spline: natural interpolation as a MATLAB function handle

`cubic_spline(x, y)` returns a function handle. Fit once, then evaluate it
like any MATLAB function:

```matlab
f = cubic_spline([0 1 3], [0 1 0]);
f(2)                 % 0.875
f([0 0.5; 1 3])    % keeps the query array's shape
```

This is a small, toolbox-free **natural cubic spline**: its second
derivative is zero at the endpoints. MATLAB's built-in `spline` uses
different default endpoint conditions and returns a piecewise polynomial
unless you evaluate it with `ppval`. Use those built-ins when a piecewise
polynomial or their endpoint behavior is what you need.

## Inputs and behavior

- `x` and `y` are finite, real vectors of equal length with at least two
  elements. `x` must be strictly increasing; spacing may vary.
- The returned handle accepts scalar or array-valued real, finite queries
  in the closed range `[x(1), x(end)]` and preserves the query shape.
- Queries outside that range raise `cubic_spline:QueryOutOfRange`. This
  function does not extrapolate.
- With two knots, the interpolant is a straight line.

Place `cubic_spline.m` on your MATLAB path. Run `test_cubic_spline` from the
repository folder to check representative cases. The GitHub Actions workflow
runs the test on pushes and pull requests.

Also available on [MATLAB File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/49773-cubic-splines-made-easy).
Licensed under BSD 3-Clause; see [LICENSE](LICENSE).
