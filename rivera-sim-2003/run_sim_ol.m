%
% Simulation of a two-node inventory management problem 
% with decentralized controllers.
%
%  1. Factory with inventory with MPC
%  2. Retail unit with inventory with MPC
%
% Based on
%  - M.W. Braun, D.E. Rivera, M.E. Flores, W.M. Carlyle, 
%    K.G. Kempf (2003). A Model Predictive Control framework 
%    for robust management of multi-product, multi-echelon 
%    demand networks, Annual Reviews in Control, Volume 27, 
%    Issue 2, Pages 229-245.
%

clear all


%% Define plant simulation models

% Sampling period
Ts = 1;

% Parameters
% Factory production lead time [time units]
thetap1 = 3;

% Shipping delay between the Factory and Retailer [time units]
thetap2 = 1;  

% Simulation parameters
t_stop = 250;
nT = floor(t_stop / Ts);
t = Ts*(0:nT)';

% Demand forecast
demand_changes = [
           0       10000
          50       11000
         100       12000
         150       11000
         200       10000
];
% Demand forecast
df = [t make_step_sequence(t, demand_changes)];

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
sim_model = "prodinvsys_sim_ol";
thetap = 10;  % Disturbance forecast horizon (thetap) [time units]
thetad = 20;  % Demand forecast horizon (thetaf) [time units]
thetas = 2;  % Supply stream delivery time (thetas) [time units]
vard = [85, 1000];  % Unforecasted demand variance (vard) [time, quantity units^2]
rchange = [10, 20000];  % Inventory setpoint [time, quantity]
dchange = [60, 2000];  % Demand change [quantity, time]
Ts = 1;  % sampling interval

% Run Simulink simulation
fprintf("Running '%s' model.\n", sim_model)
warning off
sim(sim_model, [0 t(end)]);
warning on

% Save simulation outputs
sim_out = table(t,r,u,d,y);
filename = "sim_out.csv";
writetable(sim_out, fullfile(results_dir, filename))

% Save noise for replication purposes
% (should be the same each simulation)
%e_out = table(e);
%filename = "sim_out_e.csv";
%writetable(e_out, fullfile(results_dir, filename))


%% Make plot

plot_title = "Open Loop Simulation";

figure(1); clf
colors = get(gca,'colororder');

subplot(3,1,1)
stairs(t,r,'r--','Linewidth',2); hold on
plot(t,y,'b-','Linewidth',2)
%ylim([-100 2100])
xlabel('Time')
ylabel('Inventory');
grid on
legend({'Target','Actual'},'Location','best');
title(plot_title);

subplot(3,1,2)
stairs(t,u,'color',colors(5,:),'Linewidth',2)
y_lims = ylim;
%ylim([-50 max(250,y_lims(2))])
xlabel('Time');
ylabel('Orders');
grid on

subplot(3,1,3);
stairs(t,df,'k--'); hold on
stairs(t,d,'k','linewidth',2)
%y_lims = ylim;
ylim([-50 max(250,y_lims(2))])
xlabel('Time')
ylabel('Demand');
grid on
legend({'Forecast', 'Actual'}, 'Location', 'best');




