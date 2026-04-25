function T_out = HeatEqnSolver(alpha, x, ic_values, dt, t_final, bc_left, bc_right)
    x = x(:);
    N = length(x);
    h = x(2) - x(1);
    nSteps = round(t_final / dt);

    % Build spatial second-derivative matrix (N x N)
    A = zeros(N, N);

    % Left BC: u*y + v*y' = w  (one-sided forward diff for y')
    u = bc_left(1); v = bc_left(2);
    A(1,1) = u + v*(-3)/(2*h);
    A(1,2) = v*(4)/(2*h);
    A(1,3) = v*(-1)/(2*h);

    % Right BC: backward diff for y'
    u = bc_right(1); v = bc_right(2);
    A(N,N-2) = v*(1)/(2*h);
    A(N,N-1) = v*(-4)/(2*h);
    A(N,N)   = u + v*(3)/(2*h);

    % Interior rows: second derivative stencil
    for i = 2:N-1
        A(i, i-1) = 1/h^2;
        A(i, i)   = -2/h^2;
        A(i, i+1) = 1/h^2;
    end

    % RHS forcing for BCs (w values)
    bc_rhs = zeros(N, 1);
    bc_rhs(1) = bc_left(3);
    bc_rhs(N) = bc_right(3);

    % Crank-Nicolson matrices
    % (I - alpha*dt/2 * A_int) * T_new = (I + alpha*dt/2 * A_int) * T_old + dt*alpha*bc_terms
    % For boundary rows we enforce BC directly each step.

    % Separate interior rows from BC rows
    I = eye(N);
    A_int = A;
    A_int(1,:) = 0;   % zero out BC rows in the evolution matrix
    A_int(N,:) = 0;

    LHS = I - alpha * dt/2 * A_int;
    RHS_mat = I + alpha * dt/2 * A_int;

    % Enforce BCs in LHS by replacing boundary rows
    LHS(1,:) = A(1,:);
    LHS(N,:) = A(N,:);

    T_cur = ic_values(:);
    T_out = zeros(nSteps + 1, N);
    T_out(1,:) = T_cur';

    for step = 1:nSteps
        rhs = RHS_mat * T_cur;
        % Override boundary rows with BC right-hand sides
        rhs(1) = bc_rhs(1);
        rhs(N) = bc_rhs(N);
        T_cur = LHS \ rhs;
        T_out(step+1, :) = T_cur';
    end
end