%%
%% Code to simulate Beer Game for supply chain with three echelons 
%% Bhagyesh Patil, IFAC Indsutry Task Force 
%% Last modified, 28/09/2023
%%

% Beer Game simulation and Bullwhip effect with non-negative orders and different lead times  
clear;   
close all;   
clc;  
  
% Parameters    
n_weeks = 52;                   % Number of weeks    
n_players = 3;                  % Number of players in the supply chain    
init_inventory = [20, 10, 30];  % Initial inventory for each player    
lead_times = [1, 3, 1];         % Lead time for each player  
  
% % demand = 4;                 % Constant demand  
N=5;
% demand = [1*ones(1,N) 3*ones(1,n_weeks-N)];
% demand = [1*ones(1,N) 5*ones(1,2*N) 3*ones(1,n_weeks-(N + 2*N))];
demand = [1*ones(1,N) 5*ones(1,2*N) 2*ones(1,3*N) 3*ones(1,n_weeks-(N + 2*N + 3*N))];

% Initialize variables    
orders = zeros(n_players, n_weeks);    
inventory = zeros(n_players, n_weeks);    
inventory(:, 1) = init_inventory';    
    
% Beer Game simulation    
for t = 2:n_weeks    
    for p = 1:n_players    
        if p == 1    
            orders(p, t) = demand(t);    
        else    
            orders(p, t) = max(0, inventory(p - 1, t - 1));    
        end    
            
        if t > lead_times(p)    
            incoming_orders = orders(p, t - lead_times(p));    
        else    
            incoming_orders = demand(t);    
        end    
            
        inventory(p, t) = max(0, inventory(p, t - 1) - orders(p, t) + incoming_orders);           
    end    
end    
    
% Plot results    
figure
plot(1:n_weeks, demand, 'LineWidth', 2);    
xlabel('Week');    
ylabel('Demand Value');    
title('Demand Profile');    
legend('Customer Demand');    

figure;    
% plot(1:n_weeks, demand, 'LineWidth', 2);    
% hold on;    
plot(1:n_weeks, orders', 'LineWidth', 1.5);    
xlabel('Week');    
ylabel('Order Quantity');    
title('Ordering Policy Profile');    
legend('Customer Demand', 'Retailer', 'Wholesaler', 'Manufacturer');    
% grid on;  


figure;    
% plot(1:n_weeks, demand, 'LineWidth', 2);    
% hold on;    
plot(1:n_weeks, inventory', 'LineWidth', 1.5);    
xlabel('Week');    
ylabel('Inventory Value');    
title('Inventory Levels');    
legend('Customer Demand', 'Retailer', 'Wholesaler', 'Manufacturer');    
% grid on;  
