j=1;
m= {'+','o','*','x','v','d','^','s','>','<','o'};
N=10:10:100;
x = [];
for i = 1:10
    k=7;
    hold on 
    hold all
    grid on
    %y=Test(k,N);
    %fplot(y,(0:1),append('-',m{j}),'LineWidth',2)
    for l = 1:10
        x  = [x E_DelaySim{l,1}(i)];
    end
    plot(N,x,'Linewidth',2)
    xlabel("Number of Users",'FontSize',12,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
    ylabel("Average Delay for User 5",'FontSize',12,'FontWeight','bold','Color','k','Fontname', 'Arial','Interpreter', 'latex')
    Info{i} = append("User Number =",num2str(N));
    title("802.11 Collision Probability with k =7")
    j=j+1;
end
hold on 
%fplot(@(x)x,(0:1),'--k','LineWidth',2)
%Info{i} = 'y=x';
legend(Info,'Location','southeastoutside')
legend show
