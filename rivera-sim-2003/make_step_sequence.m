function d = make_step_sequence(t, step_changes)
% d = make_step_sequence(t, changes)
% Generates a sequence of values of the same size as t
% where the values change at certain points specified in
% 'step_changes'. If the first step change is not at the
% first time instant t(1), the value is zero until the 
% first change.
%
% Example
% >> t = 0:10;
% >> step_changes = [1 100; 5 0];
% >> u = make_step_sequence(t, step_changes)
%
% u =
%
%     0   100   100   100   100     0     0     0     0     0     0
%

    d = zeros(size(t));
    for row = step_changes'
        t0 = find(t == row(1));
        d(t0:end) = row(2);
    end
end