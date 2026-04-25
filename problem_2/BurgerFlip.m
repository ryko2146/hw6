% BurgerFlip.m
alpha  = 1e-7;
T_0    = 20;
dt     = 0.01;
t_flip = 200;
t_done = 200;
T_H    = 300;
x      = linspace(0, 0.01, 40);

ic_values = T_0 * ones(1, 40);

bc_left  = [1, 0, T_H];
bc_right = [0, 1, 0];

T_phase1 = HeatEqnSolver(alpha, x, ic_values, dt, t_flip, bc_left, bc_right);

T_flipped = fliplr(T_phase1(end, :));

bc_left2  = [1, 0, T_H];
bc_right2 = [0, 1, 0];

T_phase2 = HeatEqnSolver(alpha, x, T_flipped, dt, t_done, bc_left2, bc_right2);

T_done = T_phase2(end, :);
