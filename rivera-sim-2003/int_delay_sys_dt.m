function [model, G] = int_delay_sys_dt(theta, Ts, option)
% [model, G] = int_delay_sys_dt(theta, Ts, option)
% Returns a state-space model and a discrete-time 
% transfer function for a system consisting of an
% integrator and a delay of duration theta.
%

    arguments
        theta {mustBeNumeric}
        Ts {mustBeNumeric}
        option {mustBeText} = 'default'
    end

    % Discrete-time transfer function
    G = tf(1, [1 -1], Ts, 'IODelay', theta, 'Variable', 'z^-1');

    switch option
        case 'simple'
            % This state-space model is equivalent to the
            % one below but easier to understand
            d = theta - 1;
            A = cat(2, [1; zeros(d, 1)], [eye(d); zeros(1, d)]);
            B = [zeros(d, 1); 1];
            C = [1 zeros(1, d)];
            D = 0;
            model = ss(A, B, C, D, Ts);

        otherwise
            model = ss(G);
            model = absorbDelay(model);
            model = minreal(model, [], false);

    end

end