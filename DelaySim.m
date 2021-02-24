% Plot Settings
m= {'+','o','*','x','v','d','^','s','>','<','o'};

N=10:10:100;
k = 100;
tSim = 10^6*(1:length(N));

E_Delay = cell(length(N),length(k));
E_DelaySim = cell(length(N),length(k));

beta = cell(length(N),length(k));
betaSim = cell(length(N),length(k));
gamma = cell(length(N),length(k));
gammaSim = cell(length(N),length(k));

S = zeros(length(N),length(k));
S_sim = zeros(length(N),length(k));
for i = 1:length(N)
for j = 1:length(k)
    [S(i,j),S_sim(i,j),E_Delay{i,j},E_DelaySim{i,j},beta{i,j},betaSim{i,j},gamma{i,j},gammaSim{i,j}] = DelaySimSyst(k(j),N(i),tSim(i));
end
end

plotUser = 1;
lSim = length(N);

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

hold all
grid on
plot(N,S(1:lSim,1),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
plot(N,S_sim(1:lSim,1),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
legend('Analytical','Simulation','FontSize',10)
annotation('textbox',[0.6,0.4,0.3,0.07],'String',"K(max attempts)= 100")
title('System Throughput','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Stations','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('System Throughput','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show

figure(2)

hold all
grid on
plot(N,E_DelayplotUser(1,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
hold on
plot(N,E_DelayplotUserSim(1,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
annotation('textbox',[0.6,0.4,0.3,0.07],'String',"K(max attempts)= 100")
legend('Analytical','Simulation','FontSize',10,'Location','southeast')
title('Average Delay','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Users','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('Average Delay($E[Delay]$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show

figure(3)

hold all
grid on
plot(N,beta_plotUser(1,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
plot(N,beta_plotUserSim(1,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
annotation('textbox',[0.6,0.4,0.3,0.07],'String',"K(max attempts)= 100")
legend('Analytical','Simulation','FontSize',10)
title('Transmission Probability','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Users','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('Transmission Probability($\beta$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show

figure(4)

hold all
grid on
plot(N,gamma_plotUser(1,:),append('-',m{1},'k'),'Linewidth',2,'MarkerSize',12);
plot(N,gamma_plotUserSim(1,:),append('-',m{2},'r'),'Linewidth',2,'MarkerSize',12);
annotation('textbox',[0.6,0.4,0.3,0.07],'String',"K(max attempts)= 100")
legend('Analytical','Simulation','FontSize',10,'Location','southeast')
title('Conditional Collision Probability','FontSize',16,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
xlabel('Number Of Contending Users','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
ylabel('Conditional Collision Probability($\gamma$)','FontSize',14,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
legend show




