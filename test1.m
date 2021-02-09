i=1;
m= {'+','o','*','x','v','d','^','s','>','<','o'};
for N=10:10:100
    k=50;
    hold on 
    hold all
    grid on
    y=Test(k,N);
    fplot(y,(0:1),append('-',m{i}),'LineWidth',2)
    xlabel("Collision Probability ($\gamma$)",'FontSize',12,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
    ylabel("Collision Probability($G(\Gamma(\gamma))$)",'FontSize',12,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
    Info{i} = append("Number Of Contending Users =",num2str(N));
    title("802.11 Collision Probability with k =50")
    i=i+1;
end
hold on 
fplot(@(x)x,(0:1),'--k','LineWidth',2)
Info{i} = 'y=x';
legend(Info,'Location','southeastoutside')
legend show
