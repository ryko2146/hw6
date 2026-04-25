% fin_BVP.m
k     = 30;
h     = 25;
T_inf = 20;
R     = 0.005;
L     = 0.10;
N     = 100;

Ac  = @(x) pi * R^2 * (1 - 0.9*x/L);
dAc = @(x) pi * R^2 * (-0.9/L);
P   = @(x) 2 * pi * R * (1 - 0.9*x/L);

p_fun = @(x) dAc(x) ./ Ac(x);
q_fun = @(x) -(P(x) * h) ./ (k * Ac(x));
r_fun = @(x) -(P(x) * h * T_inf) ./ (k * Ac(x));

domain   = [0, L];
bc_left  = [1, 0, 200];
bc_right = [0, 1, 0];

[x_sol, T_sol] = BVPsolver(p_fun, q_fun, r_fun, domain, bc_left, bc_right, N);
