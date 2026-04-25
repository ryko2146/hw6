function [x, y] = BVPsolver(p, q, r, domain, bc_left, bc_right, N)
    a = domain(1);
    b = domain(2);
    x = linspace(a, b, N)';
    h = x(2) - x(1);

    % Build the interior coefficient matrix (N-2 interior nodes)
    n = N - 2;
    A = zeros(N, N);
    rhs = zeros(N, 1);

    % Left boundary: u*y + v*y' = w  =>  u*y(1) + v*(y(2)-y(0))/(2h) = w
    % Since y(0) doesn't exist, use forward difference: y'(1) ≈ (-3y1 + 4y2 - y3)/(2h)
    u = bc_left(1); v = bc_left(2); w = bc_left(3);
    A(1,1) = u + v*(-3)/(2*h);
    A(1,2) = v*(4)/(2*h);
    A(1,3) = v*(-1)/(2*h);
    rhs(1) = w;

    % Right boundary: u*y + v*y' = w
    % Use backward difference: y'(N) ≈ (y(N-2) - 4y(N-1) + 3y(N))/(2h)
    u = bc_right(1); v = bc_right(2); w = bc_right(3);
    A(N,N-2) = v*(1)/(2*h);
    A(N,N-1) = v*(-4)/(2*h);
    A(N,N)   = u + v*(3)/(2*h);
    rhs(N) = w;

    % Interior nodes: central differencing
    for i = 2:N-1
        xi = x(i);
        % y''  => (y(i-1) - 2y(i) + y(i+1)) / h^2
        % y'   => (y(i+1) - y(i-1)) / (2h)
        A(i, i-1) = 1/h^2 - p(xi)/(2*h);
        A(i, i)   = -2/h^2 + q(xi);
        A(i, i+1) = 1/h^2 + p(xi)/(2*h);
        rhs(i) = r(xi);
    end

    y = A \ rhs;
end
