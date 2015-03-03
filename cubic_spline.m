function f = cubic_spline(x, y)
% CUBIC_SPLINE Cubic splines fit to a data set
% For CUBIC_SPLINE(X, Y)
%   Inputs:
%     X: a vector of values for the independent variable
%     Y: a vector of values for the dependent variable
%   Outputs: 
%     f: an inline function that computes the fitted piecewise cubic polynomial

    % Check to make sure data is equally space
    if length(unique(diff(x))) > 1
        error('Values of indendepdent variables must be equally spaced.');
    end

    %create matrix
    N = length(x);
    delta = abs(x(1)-x(2));
    for i=1:1:N
        if i==1
            A(1,1) = 1;
            B(1) = 0;
        elseif i==N
            A(N, N) = 1;
            B(N) = 0;
        else
            A(i,i-1) = 1/6;
            A(i,i) = 2/3;
            A(i,i+1) = 1/6;
            B(i) = (y(i+1)-2*y(i)+y(i-1))/(delta^2);
        end
    end
            
    %solve matrix
    G = A\(B');
    
    % Create function
    j = @(yy) interp1(x, 1:1:N, min(yy, N-1), 'previous'); 
    f = @(xx) (G(j(xx))/6)*(((x(j(xx)+1)-xx)^3)/delta-delta*(x(j(xx)+1)-xx)) ...
        + (G(j(xx)+1)/6)*(((xx-x(j(xx)))^3)/delta-delta*(xx-x(j(xx)))) ...
        + y(j(xx))*(x(j(xx)+1)-xx)/delta + y(j(xx)+1)*(xx-x(j(xx)))/delta;
end
