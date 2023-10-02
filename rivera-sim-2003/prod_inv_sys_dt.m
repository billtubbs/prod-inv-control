function [model, G] = prod_inv_sys_dt(theta, Ts, option)
% [model, G] = prod_inv_sys_dt(theta, Ts)
% Returns a state-space model and a discrete-time 
% transfer function representing a simple 
% production-inventory system model.
%

    arguments
        theta {mustBeNumeric}
        Ts {mustBeNumeric}
        option {mustBeText} = 'default'
    end

    % Discrete-time transfer function for the sub-system:
    % input: orders -> output: inventory 
    G1 = tf(1, [1 -1], Ts, 'IODelay', theta, 'Variable', 'z^-1');

    % Discrete-time transfer function for the sub-system:
    % input: shipments -> output: inventory
    G2 = tf(-1, [1 -1], Ts, 'Variable', 'z^-1');

    % Combined system
    G = [G1 G2];

    switch option
        case 'simple'
            % This state-space model is equivalent to the
            % one below but easier to understand
            d = theta - 1;
            A = cat(2, [1; zeros(d, 1)], [eye(d); zeros(1, d)]);
            B = cat(2, [zeros(d, 1); 1], [-1; zeros(d, 1)]);
            C = [1 zeros(1, d)];
            D = [0 -1];
            model = ss(A, B, C, D, Ts);

        otherwise
            model = ss(G);
            model = absorbDelay(model);
            model = minreal(model, [], false);

    end

end