# MCEN 3030 Homework 6


This assignment will be auto-graded, but you have to tell GitHub to check your work. Within your repository, click on "Actions" towards the top, and on the left-hand side you should see "Click here to run grader". Then, you should see "Run workflow" to the right.

If you click on the most recent autograder run, you should be able to scroll down to see "Autograder Feedback". This will let you know what tests you have passed and (hopefully) give you some meaningful feedback about how to fix your code for the tests you have not passed. I encourage you to evaluate your own work before submitting, e.g.: make sure the array has the correct number of elements. 

## Problem 1

(a) Write a function ```BVPsolver(p, q, r, domain, bc_left, bc_right, N)``` that solves a differential equation of the form

$$
y''+p(x)y' + q(x) y = r(x)
$$

using a central-differencing scheme. The inputs are:
- ```p```, ```q```, and ```r```, anonymous functions of $x$ described mathematically above.
- ```domain```, a length-two array that describes the left and right bounds of the domain, e.g. ```[-2,2]``` or ```[0,10]```.
- ```bc_left```, a length-three array that describes the boundary conditions. Generically, we can write a boundary condition as $uy + vy' = w$ (all evaluated at the boundary), and ```bc_left``` will be the array ```[u,v,w]```. (The basic Dirichlet boundary condition will have $u=1$, $v=0$, and $w=\text{something}$.)
- ```bc_right```, same, but for the right boundary.
- ```N``` the number of nodes. There will be ```N-2``` interior nodes and ```2``` boundary nodes.

The function returns ```x,y```, where ```x``` is an array of the node locations and ```y``` is the solution to the differential equation at each of those nodes. You may use built-in matrix inversion tools to solve the system. Your file should be named ```BVPsolver```.


(b) Regarding the heat transfer fin problem from the video: here is the full "fin equation":

$$
k A_c \frac{d^2 T}{dx^2} + k \frac{dA_c}{dx} \frac{dT}{dx} -Ph(T-T_\infty) = 0.
$$

We will solve this equation for a tapered circular fin with parameters $k=30$, $h=25$, $T_\infty=20$, $R=0.005$, and $L=0.10$. Involved are functions for the cross section, $A_\text{c}(x)=\pi R^2 (1-0.9x/L)$; the derivative of the cross-section $dA_\text{c}/dx$ (you can calculate this and implement it as an anonymous function of ```x```), and the perimeter $P(x)=2\pi R(1-0.9x/L)$. The boundary conditions are

$$ 
T(0)=T_0=200 \qquad \frac{dT}{dx}(L)=0.
$$

Use 100 nodes, and make sure the variable you store the solution in is called ```T_sol```. Your file should be named ```fin_BVP```.


## Problem 2

The 1D heat equation is:

$$
\frac{\partial T}{\partial t}=\alpha \frac{\partial^2 T}{\partial x^2}.
$$

This describes the way that the temperature profile on a spatial domain (e.g., a rod of length $L$) evolves with time, $T(x,t)$, with $\alpha$ being the thermal diffusivity (a material property). Note that this equation has one time derivative, meaning we'll need to supply one initial condition $T(x,0)$, and two spatial derivatives, meaning we'll need to supply two boundary conditions, e.g. $T(0,t)$ and $T(L,t)$.

(a) Write a function ```HeatEqnSolver(alpha, x, ic_values, dt, t_final, bc_left, bc_right)```. The inputs are:

- ```alpha``` is the thermal diffusivity, a scalar.
- ```x``` is an array of positions to be used in the calculation, e.g. ```[-2,-1.5,-1,-0.5, 0, .5, 1, 1.5, 2, 2.5]```.
- ```ic_values``` are the initial condition values at each of the locations in ```x```. An array.
- ```dt``` is the time step size.
- ```t_final``` is the final time value, assuming the initial time value is zero.
- ```bc_left```, a length-three array that describes the boundary conditions. Generically, we can write the boundary condition as $uy + vy' = w$, and ```bc_left``` will be the array ```[u,v,w]```.
- ```bc_right```, same, but for the right boundary.

The function should return an array where each row gives the temperature profile $T(x)$ at a different time value: first row $t=0$, last row, $t=t_\text{final}$. Your file should be named ```HeatEqnSolver```.

(b) Now we will apply this to cooking a burger patty (cow, tempeh, black bean, beyond meat, ostrich, ground-up Cheetos, whatever).

Assume the patty is initially at a constant room temperature, $T(x,0)=T_0$. As it is cooking, it is exposed to a constant temperature on the cooking side, $T(0,t)=T_\text{hot}$. The other side is adiabatic, meaning the derivative is zero: $T'(L,t)=0$. After a certain amount of time $t_\text{flip}$, the patty is instantaneously flipped over such that the "cold side" is now exposed to the hot griddle, and the other side now experiences the adiabatic boundary condition. Then cooking continues until $t_\text{done}$. (This is defined such that, if we flip and then immediately remove the patty, $t_\text{done}=0$. That is, the timer starts again at zero.)

Write a script that returns the temperature distribution at ```t_done```. Call this 1D array ```T_done``` (and be careful with upper/lower case, always!). Parameter values are listed below. Your file should be named ```BurgerFlip```. 

You may use a built-in command to reverse the order of the vector after ```t_flip```. In MATLAB the command is ```flip(z)```, in Python it is ```np.flip(z)```, in Julia it is ```reverse(z)```. After flipping, your initial condition for the next call to ```HeatEqnSolver``` will have its smallest value at index 1 (0 for Python).


If you'd like to check it out, here is the paper that inspired this problem: ["The mathematics of burger flipping"](https://arxiv.org/abs/2206.13900).

```
alpha=10^-7
T_0=20
dt=.01
t_flip=200
t_done=200
T_H=300
x from 0 to .01 with 40 elements
```



