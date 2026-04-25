% fin_BVP.m
k   = 30;
h   = 25;
T_inf = 20;
R   = 0.005;
L   = 0.10;
N   = 100;

% Cross section, its derivative, and perimeter
Ac  = @(x) pi * R^2 * (1 - 0.9*x/L);
dAc = @(x) pi * R^2 * (-0.9/L);
P   = @(x) 2 * pi * R * (1 - 0.9*x/L);

% Rearrange fin equation to standard form: T'' + p(x)T' + q(x)T = r(x)
% k*Ac*T'' + k*dAc*T' - P*h*(T - T_inf) = 0
% T'' + (dAc/Ac)*T' - (P*h)/(k*Ac)*T = -(P*h*T_inf)/(k*Ac)

p_fun = @(x) dAc(x) ./ Ac(x);
q_fun = @(x) -(P(x) * h) ./ (k * Ac(x));
r_fun = @(x) -(P(x) * h * T_inf) ./ (k * Ac(x));

domain   = [0, L];
bc_left  = [1, 0, 200];   % T(0) = 200  (Dirichlet)
bc_right = [0, 1, 0];     % dT/dx(L) = 0 (Neumann)

[x_sol, T_sol] = BVPsolver(p_fun, q_fun, r_fun, domain, bc_left, bc_right, N);

% Plot (optional)
figure;
plot(x_sol, T_sol);
xlabel('x (m)'); ylabel('T (°C)');
title('Temperature Distribution Along Tapered Fin');
