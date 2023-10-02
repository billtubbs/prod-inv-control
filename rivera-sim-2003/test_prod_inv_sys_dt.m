% Test the model construction functions
% prod_inv_sys_dt.m and int_delay_sys_dt.m


%% Test int_delay_sys_dt

theta = 3;
Ts = 1;
[model1, G] = int_delay_sys_dt(theta, Ts, 'simple');
assert(isequal(G.numerator, {[1 0]}))
assert(isequal(G.denominator, {[1 -1]}))
assert(G.IODelay == 3)

assert(isequal(model1.A, [
     1     1     0
     0     0     1
     0     0     0    
]))
assert(isequal(model1.B, [
     0
     0
     1    
]))
assert(isequal(model1.C, [
     1     0     0    
]))
assert(model1.D == 0)

[model2, G] = int_delay_sys_dt(theta, Ts);
assert(isequal(G.numerator, {[1 0]}))
assert(isequal(G.denominator, {[1 -1]}))
assert(G.IODelay == 3)

assert(isequal(round(model2.A, 4), [
    1.0000    0.7071   -0.0000
    0.0000    0.0000    1.0000
   -0.0000    0.0000    0.0000 
]))
assert(isequal(round(model2.B, 4), [
    0.0000
   -0.0000
    1.0000    
]))
assert(isequal(round(model2.C, 4), [
     1.4142   -0.0000   -0.0000  
]))
assert(model2.D == 0)

% Check both models are equivalent
y1 = impulse(model1, 10);
y2 = impulse(model2, 10);
assert(all(abs(y1 - y2) < 1e-14))


%% Test prod_inv_sys_dt

theta = 3;
Ts = 1;
[model1, G] = prod_inv_sys_dt(theta, Ts, 'simple');
assert(isequal(G.numerator, {[1 0], [-1 0]}))
assert(isequal(G.denominator, {[1 -1], [1 -1]}))
assert(isequal(G.IODelay, [3 0]))

assert(isequal(model1.A, [
     1     1     0
     0     0     1
     0     0     0    
]))
assert(isequal(model1.B, [
     0    -1
     0     0
     1     0  
]))
assert(isequal(model1.C, [
     1     0     0    
]))
assert(isequal(model1.D, [0  -1]))

[model2, G] = prod_inv_sys_dt(theta, Ts);
assert(isequal(G.numerator, {[1 0], [-1 0]}))
assert(isequal(G.denominator, {[1 -1], [1 -1]}))
assert(isequal(G.IODelay, [3 0]))

assert(isequal(round(model2.A, 4), [
    1.0000    0.4472    0.0000
   -0.0000    0.0000    1.0000
   -0.0000    0.0000   -0.0000
]))
assert(isequal(round(model2.B, 4), [
    0.0000   -0.4472
   -0.0000    0.0000
    1.0000    0.0000  
]))
assert(isequal(round(model2.C, 4), [
    2.2361   -0.0000   -0.0000 
]))
assert(isequal(round(model2.D, 4), [0  -1]))

% Check both models are equivalent
y1 = impulse(model1, 10);
y2 = impulse(model2, 10);
assert(all(all(abs(y1 - y2) < 1e-14)))
