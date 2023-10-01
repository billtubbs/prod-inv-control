function [model, G] = int_delay_sys_dt(theta, Ts)
% [model, G] = int_delay_sys_dt(theta, Ts)
% Returns a discrete-time transfer function and a 
% state-space model of a system consisting of an
% integrator and a delay of duration theta.
%

    % Discrete-time transfer function
    G = tf(1, [1 -1], Ts, 'IODelay', theta, 'Variable', 'z^-1');

    % The state-space model below is equivalent to that
    % which you would get with the following:
    %model = ss(G);
    %model = absorbDelay(model);
    %model = minreal(model);

    d = theta - 1;

    A = cat(2, [1; zeros(d, 1)], [eye(d); zeros(1, d)]);
    B = [zeros(d, 1); 1];
    C = [1 zeros(1, d)];
    D = 0;
    model = ss(A, B, C, D, Ts);

end