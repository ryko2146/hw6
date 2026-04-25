% BurgerFlip.m
alpha  = 1e-7;
T_0    = 20;
dt     = 0.01;
t_flip = 200;
t_done = 200;
T_H    = 300;
x      = linspace(0, 0.01, 40);

% Initial condition: uniform room temperature
ic_values = T_0 * ones(1, 40);

% Phase 1: cook from t=0 to t_flip
% Left (x=0): T = T_H  =>  bc = [1, 0, T_H]
% Right (x=L): dT/dx = 0  =>  bc = [0, 1, 0]
bc_left  = [1, 0, T_H];
bc_right = [0, 1, 0];

T_phase1 = HeatEqnSolver(alpha, x, ic_values, dt, t_flip, bc_left, bc_right);

% Temperature profile just after flipping (spatially reversed)
T_flipped = fliplr(T_phase1(end, :));

% Phase 2: cook from t=0 to t_done after flip
% Now left side (formerly the cold/adiabatic side) hits the griddle
bc_left2  = [1, 0, T_H];
bc_right2 = [0, 1, 0];

T_phase2 = HeatEqnSolver(alpha, x, T_flipped, dt, t_done, bc_left2, bc_right2);

T_done = T_phase2(end, :);

% Optional plot
figure;
plot(x, T_done);
xlabel('x (m)'); ylabel('T (°C)');
title('Burger Temperature Distribution at t_{done}');