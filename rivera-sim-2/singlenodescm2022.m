%
% ChE 494/561  Advanced Process Control
%
% Spring 2022
%
% Single node inventory management problem
% Combined feedback-feedforward IMC solution with three degrees of freedom
% Contrasted with feedback-only 2 degree-of-freedom IMC design
%
% Control implementation per the paper, 
% 
% J.D. Schwartz and D.E. Rivera. “A process control approach to tactical inventory management in production-inventory systems,” 
% International Journal of Production Economics, Volume 125, Issue 1, Pages 111-124, 2010.
%
% Developed by D E Rivera, Arizona State University
% 
%
warning off

thetap = input('Enter the production lead time (thetap) [10 time units]: ');
if isempty(thetap), thetap =10; end;

thetad = input('Enter the disturbance forecast horizon (thetaf) [20 time units]: ');
if isempty(thetad), thetad =20; end;

thetas = input('Enter the supply stream delivery time (thetad) [2 time units]: ');
if isempty(thetas), thetas =2; end;
	
vard  = input('Enter the unforecasted demand variance (vard) [1000]: ');
if isempty(vard), vard=1000; end;

thetaptilde = thetap;
thetadtilde = (thetad-thetas);

rchange = input('Enter the inventory setpoint [20000 units]: ');
if isempty(rchange), rchange =20000; end;

dchange = input('Enter the demand change [2000 units]: ');
if isempty(dchange), dchange =2000; end;

lamr  =  input('Enter the setpoint filter lambda [5 time units]: ');
if isempty(lamr), lamr =5; end;
	
stptfiltorder = menu('Enter the setpoint filter order ','n=1','n=2');
if stptfiltorder == 1  % First-order filter
  numqr =  [1 0];
  denqr =  [lamr 1];
elseif stptfiltorder == 2  % Second-order filter
  numqr = conv([0 1],[1 0]);
  denqr = conv([lamr 1],[lamr 1]);
end;

lamd  =  input('Enter the unmeasured disturbance filter lambda [1 time units]: ');
if isempty(lamd), lamd =1; end;
	
distfiltorder = menu('Enter the unmeasured disturbance filter order ','n=3','n=4');
if distfiltorder == 1  % Third-order filter
  numqd = conv(conv([thetaptilde 1],[1 0]),[3*lamd 1]);
  denqd = conv(conv([lamd 1],[lamd 1]),[lamd 1]);
elseif distfiltorder == 2  % Fourth-order filter
  numqd = conv(conv([thetaptilde 1],[1 0]),[4*lamd 1]);
  denqd = conv(conv(conv([lamd 1],[lamd 1]),[lamd 1]),[lamd 1]);
end;

lamdf  =  input('Enter the measured disturbance (feedforward) filter lambda [1 time units]: ');
if isempty(lamdf), lamdf =1; end;
	
fffiltorder = menu('Enter the measured disturbance filter order ','n=2','n=3');
if fffiltorder == 1  % Second-order filter
  numqf = [2*lamdf 1];
  denqf = conv([lamdf 1],[lamdf 1]);
elseif fffiltorder == 2  % Third-order filter
  numqf = [3*lamdf 1];
  denqf = conv(conv([lamdf 1],[lamdf 1]),[lamdf 1]);
end;

if thetaptilde > thetadtilde
	ffcase = 1;
	numqf = conv(numqf,[thetaptilde-thetadtilde 1]);
else
	ffcase = 0;
end;
	
ffswitch = 0 ; % feedback-only control
sim('contfeedforwardr12',[0 120]);

figure(1)
subplot(3,1,1)
plot(tout,y,tout,r,'--','linewidth',2)
xlabel('Time')
ylabel('Inventory');
title(' Feedback-only control');

subplot(3,1,2)
plot(tout,u,'linewidth',2)
xlabel('Time');
ylabel('Inflow');

subplot(3,1,3);
plot(tout,d1,'--',tout,d,'linewidth',2);
xlabel('Time')
ylabel('Outflow');
legend('Sent','Received');

ffswitch = 1; % combined feedback-feedforward control
sim('contfeedforwardr12',[0 120]);

figure(2)
subplot(3,1,1)
plot(tout,y,tout,r,'--','linewidth',2)
xlabel('Time')
ylabel('Inventory');
title(' Combined feedback-feedforward control');

subplot(3,1,2)
plot(tout,u,'linewidth',2)
xlabel('Time');
ylabel('Inflow');

subplot(3,1,3);
plot(tout,d1,'--',tout,d,'linewidth',2);
xlabel('Time')
ylabel('Outflow');
legend('Sent','Received');

warning on
 