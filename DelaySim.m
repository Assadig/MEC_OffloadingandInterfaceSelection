% Plot Settings
m= {'+','o','*','x','v','d','^','s','>','<','o'};

N=10:10:100; % User array
k = [7 100]; % System simulated for two values of k
tSim = 10^6*(1:length(N)); % To keep the number of attempts constant per user across all N
                           % tSim is increased linearly
% Defining all the system parameters as cells since each system setting
% of (N,k) yields a different size array

% Delays
E_Delay =  cell(length(N),length(k)); 
E_DelaySim = cell(length(N),length(k));

% Transmission probability 
beta = cell(length(N),length(k));
betaSim = cell(length(N),length(k));

% Conditional probability
gamma = cell(length(N),length(k));
gammaSim = cell(length(N),length(k));

% Throughput
S = zeros(length(N),length(k));
S_sim = zeros(length(N),length(k));

for i = 1:length(N)
for j = 1:length(k)
    [S(i,j),S_sim(i,j),E_Delay{i,j},E_DelaySim{i,j},beta{i,j},betaSim{i,j},gamma{i,j},gammaSim{i,j}] = DelaySimSyst(k(j),N(i),tSim(i));
end
end

% Extract all the system parameters for a particular user as dtermined by
% the variable plotUser

plotUser = 4; % User number of 4 is picked to see the system performance
lSim = length(N);
k_plot=1;

E_DelayplotUser = zeros(length(k),lSim);
E_DelayplotUserSim = zeros(length(k),lSim);

beta_plotUser = zeros(length(k),lSim);
beta_plotUserSim = zeros(length(k),lSim);

gamma_plotUser = zeros(length(k),lSim);
gamma_plotUserSim = zeros(length(k),lSim);

for i = 1:length(k)
    for v=1:lSim
        E_DelayplotUserSim(i,v) = E_DelaySim{v,i}(plotUser);
        E_DelayplotUser(i,v) = E_Delay{v,i};
        
        beta_plotUserSim(i,v) = betaSim{v,i}(plotUser);
        beta_plotUser(i,v) = beta{v,i};
        
        gamma_plotUserSim(i,v) = gammaSim{v,i}(plotUser);
        gamma_plotUser(i,v) = gamma{v,i};
    end
end


figure(1)

subplot(211)

plot(N,S(1:lSim,k_plot),append('-',m{k_plot},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N,S_sim(1:lSim,k_plot),append('-',m{k_plot+1},'r'),'Linewidth',2,'MarkerSize',12);
legend(append("Analytical: K=",int2str(k(k_plot))),append("Simulation: K=",int2str(k(k_plot))),'FontSize',10)
title('System Throughput','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
%xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('System Throughput','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show
grid on
subplot(212)
plot(N,S(1:lSim,k_plot+1),append('-',m{k_plot},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N,S_sim(1:lSim,k_plot+1),append('-',m{k_plot+1},'r'),'Linewidth',2,'MarkerSize',12);
legend(append("Analytical: K=",int2str(k(k_plot+1))),append("Simulation: K=",int2str(k(k_plot+1))),'FontSize',10,'Location','best')
%title('System Throughput','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('System Throughput','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show
grid on

figure(2)

subplot(211)
plot(N,E_DelayplotUser(k_plot,:),append('-',m{k_plot},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N,E_DelayplotUserSim(k_plot,:),append('-',m{k_plot+1},'r'),'Linewidth',2,'MarkerSize',12);
legend(append("Analytical: K)=",int2str(k(k_plot))),append("Simulation: K=",int2str(k(k_plot))),'FontSize',10,'Location','best')
title('Average Delay','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
%xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('E[Delay]','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show
grid on

subplot(212)
plot(N,E_DelayplotUser(k_plot+1,:),append('-',m{k_plot},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N,E_DelayplotUserSim(k_plot+1,:),append('-',m{k_plot+1},'r'),'Linewidth',2,'MarkerSize',12);
legend(append("Analytical: K=",int2str(k(k_plot+1))),append("Simulation: K=",int2str(k(k_plot+1))),'FontSize',10,'Location','best')
%title('System Throughput','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('E[Delay]','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show
grid on

figure(3)

subplot(211)
plot(N,beta_plotUser(k_plot,:),append('-',m{k_plot},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N,beta_plotUserSim(k_plot,:),append('-',m{k_plot+1},'r'),'Linewidth',2,'MarkerSize',12);
legend(append("Analytical: K=",int2str(k(k_plot))),append("Simulation: K=",int2str(k(k_plot))),'FontSize',10,'Location','best')
title('Transmission Probability','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
%xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('$\beta$','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show
grid on

subplot(212)
plot(N,beta_plotUser(k_plot+1,:),append('-',m{k_plot},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N,beta_plotUserSim(k_plot+1,:),append('-',m{k_plot+1},'r'),'Linewidth',2,'MarkerSize',12);
legend(append("Analytical: K=",int2str(k(k_plot+1))),append("Simulation: K=",int2str(k(k_plot+1))),'FontSize',10,'Location','best')
%title('System Throughput','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('$\beta$','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show
grid on


figure(4)

subplot(211)
plot(N,gamma_plotUser(k_plot,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N,gamma_plotUserSim(k_plot,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
legend(append("Analytical: K=",int2str(k(k_plot))),append("Simulation: K=",int2str(k(k_plot))),'FontSize',10,'Location','best')
title('Conditional Collision Probability','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
%xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('$\gamma$','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show
grid on

subplot(212)
plot(N,gamma_plotUser(k_plot+1,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N,gamma_plotUserSim(k_plot+1,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
legend(append("Analytical: K=",int2str(k(k_plot+1))),append("Simulation: K=",int2str(k(k_plot+1))),'FontSize',10,'Location','best')
%title('System Throughput','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('$\gamma$','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show
grid on




