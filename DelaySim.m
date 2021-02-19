% Plot Settings
m= {'+','o','*','x','v','d','^','s','>','<','o'};
plotVar=0;

% Slot settings for each case
DIFS=5;      % Distributed InterFrame Spacing
tColl = 10;  % Number Of Slots Collision b/w stations take up 
tPacket = 20;% Average duration of each packet, same for all stations
tSim = 10*10^6; % Total simulation time in slots
timeColl = 0;% Counter for succesfull tr channel busy duration
timeSucc = 0;% Counter for collision on channel busy duration
c=0;
n=0;
x=50:10:50;
E_Delay = cell(length(x),2);
E_DelaySim = cell(length(x),2);

beta = cell(length(x),2);
betaSim = cell(length(x),2);
gamma = cell(length(x),2);
gammaSim = cell(length(x),2);

S = zeros(length(x),2);
S_sim = zeros(length(x),2);
for N = 50:10:50
for k = [7]
plotVar = plotVar+1;



end
plotVar = 0;
end

plotUser = 10;
N_plot = 50:10:50 ;
lSim = length(N_plot);

E_DelayplotUser = zeros(2,lSim);
E_DelayplotUserSim = zeros(2,lSim);

beta_plotUser = zeros(2,lSim);
beta_plotUserSim = zeros(2,lSim);

gamma_plotUser = zeros(2,lSim);
gamma_plotUserSim = zeros(2,lSim);

for x = 1:1
    for v=1:lSim
        E_DelayplotUserSim(x,v) = E_DelaySim{v,x}(plotUser);
        E_DelayplotUser(x,v) = E_Delay{v,x};
        
        beta_plotUserSim(x,v) = betaSim{v,x}(plotUser);
        beta_plotUser(x,v) = beta{v,x};
        
        gamma_plotUserSim(x,v) = gammaSim{v,x}(plotUser);
        gamma_plotUser(x,v) = gamma{v,x};
    end
end

figure(1)

hold all
grid on
plot(N_plot,S(1:lSim,1),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
plot(N_plot,S_sim(1:lSim,1),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
legend('Analytical','Simulation','FontSize',10)
annotation('textbox',[0.65,0.4,0.25,0.07],'String',"K(max attempts)= 7")
title('System Throughput','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('System Throughput','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show

figure(2)

hold all
grid on
plot(N_plot,E_DelayplotUser(1,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N_plot,E_DelayplotUserSim(1,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
annotation('textbox',[0.65,0.4,0.25,0.07],'String',"K(max attempts)= 7")
legend('Analytical','Simulation','FontSize',10,'Location','southeast')
title('Average Delay','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Users','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('Average Delay($E[Delay]$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show

figure(3)

hold all
grid on
plot(N_plot,beta_plotUser(1,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
plot(N_plot,beta_plotUserSim(1,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
annotation('textbox',[0.65,0.4,0.25,0.07],'String',"K(max attempts)= 7")
legend('Analytical','Simulation','FontSize',10)
title('Transmission Probability','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Users','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('Transmission Probability($\beta$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show

figure(4)

hold all
grid on
plot(N_plot,gamma_plotUser(1,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
plot(N_plot,gamma_plotUserSim(1,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
annotation('textbox',[0.65,0.4,0.25,0.07],'String',"K(max attempts)= 7")
legend('Analytical','Simulation','FontSize',10,'Location','southeast')
title('Conditional Collision Probability','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Users','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('Conditional Collision Probability($\gamma$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show




