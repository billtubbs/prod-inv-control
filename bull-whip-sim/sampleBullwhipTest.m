
function y =sampleBullwhipTest() 
    % Beer Game simulation and Bullwhip effect with EOQ model  
    % clear; close all; clc;  
      
    % Parameters  
    n_weeks = 52;  % Number of weeks  
    lead_time = 2; % Lead time in weeks  
    n_players = 3; % Number of players in the supply chain (retailer, wholesaler, manufacturer)  
    init_inventory = 12; % Initial inventory for each player  
    init_demand = 4; % Initial demand  
    holding_cost = 10; % Holding cost per unit per week  
    order_cost = 5; % Order cost per order  
      
    % Random demand fluctuations  
    rng(0); % Seed for reproducibility  

    % Steady increase in demand for first 10 samples
    Nd=1; N=10;
    for i=2:N
        Nd(:,i) = Nd(:,i-1) + 0.1;
    end
    % After 10 samples random demand generation to replicate Bullwhip effect
    demand_fluctuation = [Nd 2*(randi([0 1], 1, n_weeks-length(Nd)) - 0.5)];   
      
    % Initialize variables  
    demand = init_demand * ones(1, n_weeks) + demand_fluctuation;  
    orders = zeros(n_players, n_weeks);  
    inventory = init_inventory * ones(n_players, n_weeks);  
      
     
    % Beer Game simulation  
    for t = 2:n_weeks  
        for p = 1:n_players  
            if p == 1  
                orders(p, t) = demand(t - 1);  
            else  
                orders(p, t) = eoq_order(inventory(p - 1, t - 1), holding_cost, order_cost);  
            end  
              
            if t > lead_time  
                incoming_orders = orders(p, t - lead_time);  
            else  
                incoming_orders = init_demand;  
            end  
              
            inventory(p, t) = inventory(p, t - 1) - orders(p, t) + incoming_orders;  
        end  
    end  
    
    % Plot results  
    figure;  
    plot(1:n_weeks, demand, 'LineWidth', 2);  
    hold on;  
    plot(1:n_weeks, inventory', 'LineWidth', 1.5);  
    xlabel('Week');  
    ylabel('Inventory Level');  
    title('Beer Game Simulation with EOQ Model and Bullwhip Effect');  
    legend('Customer Demand', 'Retailer', 'Wholesaler', 'Manufacturer', 'Location', 'NorthWest');  
    grid on;  
end

  
% EOQ order function  
function order_quantity = eoq_order(demand, holding_cost, order_cost)  
    order_quantity = sqrt((2 * demand * order_cost) / holding_cost);  
end 







