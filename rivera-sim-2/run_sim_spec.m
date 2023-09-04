%
% Single node inventory management problem
% Combined feedback-feedforward IMC solution with three degrees of freedom
% Contrasted with feedback-only 2 degree-of-freedom IMC design
%
% This code is adapted from code provided by D E Rivera, Arizona 
% State University in January 2023:
%  - inglenodescm2022.m
%  - contfeedforwardr12.slx
%
% This code was used for teaching in the following course:
%   ChE 494/561  Advanced Process Control, Spring 2022
%
% It can be used to reproduce the results in the paper:
%  - J.D. Schwartz and D.E. Rivera. “A process control approach to 
%    tactical inventory management in production-inventory systems," 
%    International Journal of Production Economics, Volume 125, 
%    Issue 1, Pages 111-124, 2010.
%


addpath("../yaml")

% Select simulation model to run
sim_name = "singlenodescm2022";
fprintf("Running sim_spec for '%s'\n", sim_name)

% Directories used
sim_dir = fullfile("simulations", sim_name);
results_dir = fullfile(sim_dir, "results");
if ~exist(results_dir, 'dir')
    mkdir(results_dir)
end

% Load simulation specification from Yaml file
sim_spec = yaml.loadFile(fullfile(sim_dir, "sim_spec.yaml"));

% Check all parameters loaded
sim_model = sim_spec.sim_model;
thetap = sim_spec.thetap;
thetad = sim_spec.thetad;
thetas = sim_spec.thetas;
vard = sim_spec.vard;
rchange = sim_spec.rchange;
dchange = sim_spec.dchange;
lamr = sim_spec.lamr;
stptfiltorder = sim_spec.stptfiltorder;
lamd = sim_spec.lamd;
distfiltorder = sim_spec.distfiltorder;
lamdf = sim_spec.lamdf;
fffiltorder = sim_spec.fffiltorder;

thetaptilde = thetap;
thetadtilde = (thetad - thetas);

% Define filter coefficients
switch stptfiltorder
    case 1  % First-order filter
        numqr =  [1 0];
        denqr =  [lamr 1];
    case 2  % Second-order filter
        numqr = conv([0 1],[1 0]);
        denqr = conv([lamr 1],[lamr 1]);
    otherwise
        error("ValueError: stptfiltorder")
end

switch distfiltorder
    case 1  % Third-order filter
        numqd = conv(conv([thetaptilde 1],[1 0]),[3*lamd 1]);
        denqd = conv(conv([lamd 1],[lamd 1]),[lamd 1]);
    case 2  % Fourth-order filter
        numqd = conv(conv([thetaptilde 1],[1 0]),[4*lamd 1]);
        denqd = conv(conv(conv([lamd 1],[lamd 1]),[lamd 1]),[lamd 1]);
    otherwise
        error("ValueError: distfiltorder")
end

switch fffiltorder
    case 1  % Second-order filter
        numqf = [2*lamdf 1];
        denqf = conv([lamdf 1],[lamdf 1]);
    case 2  % Third-order filter
        numqf = [3*lamdf 1];
        denqf = conv(conv([lamdf 1],[lamdf 1]),[lamdf 1]);
    otherwise
        error("ValueError: fffiltorder")
end

if thetaptilde > thetadtilde
	ffcase = 1;
	numqf = conv(numqf,[thetaptilde-thetadtilde 1]);
else
	ffcase = 0;
end


plot_titles = [
    "Feedback-only control"
    "Combined feedback-feedforward control"
];
ffswitch_values = [0 1];
% 0 = feedback-only control
% 1 = combined feedback-feedforward control

for i_sim = 1:numel(ffswitch_values)

    % Configure simulation
    ffswitch = ffswitch_values(i_sim);

    % Run Simulink simulation
    fprintf("Running simulation %d...\n", i_sim)
    warning off
    sim(sim_model, [0 120]);
    warning on

    % Save simulation outputs
    sim_out = table(t,r,u,d,d1,y);
    filename = sprintf("sim_out_%d.csv", ffswitch);
    writetable(sim_out, fullfile(results_dir, filename))

    % Save noise for replication purposes
    % (should be the same each simulation)
    e_out = table(e);
    filename = sprintf("sim_out_%d_e.csv", ffswitch);
    writetable(e_out, fullfile(results_dir, filename))

    % Make plot
    figure(i_sim)
    subplot(3,1,1)
    plot(tout,y,tout,r,'--','linewidth',2)
    xlabel('Time')
    ylabel('Inventory');
    title(plot_titles(i_sim));

    subplot(3,1,2)
    plot(tout,u,'linewidth',2)
    xlabel('Time');
    ylabel('Inflow');

    subplot(3,1,3);
    plot(tout,d1,'--',tout,d,'linewidth',2);
    xlabel('Time')
    ylabel('Outflow');
    legend('Sent','Received');

end
