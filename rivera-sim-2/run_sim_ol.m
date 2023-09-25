%
% Single node inventory management problem
%
% Single production unit with inventory system.
%

clear all

% Select simulation model to run
sim_name = "prodinvsys_ol";
fprintf("Running '%s' simulation\n", sim_name)

% Directories used
sim_dir = fullfile("simulations", sim_name);
if ~exist(sim_dir, 'dir')
    mkdir(sim_dir)
end
results_dir = fullfile(sim_dir, "results");
if ~exist(results_dir, 'dir')
    mkdir(results_dir)
end

% Load simulation specification from Yaml file
% Don't need this
%sim_spec = yaml.loadFile(fullfile(sim_dir, "sim_spec.yaml"));

% Simulation model parameters
sim_model = "prodinvsys_ol";
thetap = 10;  % Disturbance forecast horizon (thetap) [time units]
thetaf = 20;  % Demand forecast horizon (thetaf) [time units]
thetas = 2;  % Supply stream delivery time (thetas) [time units]
vard = [100, 200];  % Unforecasted demand variance (vard) [time, quantity units^2]
rchange = [10, 1000];  % Inventory setpoint [time, quantity]
dchange = [60, 150];  % Demand change [quantity, time]
Ts = 1;  % sampling interval


% Run Simulink simulation
fprintf("Running '%s' model.\n", sim_model)
warning off
sim(sim_model, [0 150]);
warning on

% Save simulation outputs
sim_out = table(t,r,u,d1,d2,d3,y);
filename = "sim_out.csv";
writetable(sim_out, fullfile(results_dir, filename))

% Save noise for replication purposes
% (should be the same each simulation)
e_out = table(e);
filename = "sim_out_e.csv";
writetable(e_out, fullfile(results_dir, filename))


%% Make plot

plot_title = "Open Loop Simulation";

figure(1); clf
colors = get(gca,'colororder');

subplot(3,1,1)
stairs(t,r,'r--','Linewidth',2); hold on
plot(t,y,'b-','Linewidth',2)
ylim([-100 2100])
xlabel('Time')
ylabel('Inventory');
grid on
legend({'Target','Actual'},'Location','best');
title(plot_title);

subplot(3,1,2)
stairs(t,u,'color',colors(5,:),'Linewidth',2)
y_lims = ylim;
ylim([-50 max(250,y_lims(2))])
xlabel('Time');
ylabel('Factory Starts');
grid on

subplot(3,1,3);
stairs(t,d1,'k--'); hold on
stairs(t,d2,'k','linewidth',2)
y_lims = ylim;
ylim([-50 max(250,y_lims(2))])
xlabel('Time')
ylabel('Customer demand');
grid on
legend({'Forecast','Actual'},'Location','best');

