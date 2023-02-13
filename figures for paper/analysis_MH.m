load MH_data.mat;
blue='#43a2ca';
red='#e34a33';
green='#2ca25f';
fontcolor='k';
fontsize=14;
fig=figure;
linewidth=1;
V=6.9*10^-7;
set(fig,'Color','w','Units','inches','Position',[0,0,15,7])
%plot MH
MH_ax=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
        'XColor',fontcolor,...
        'LineWidth',linewidth,...
        'FontSize',fontsize,...   
        'Color','none',...
        'Units','Inches',...
        'XTickLabel',[],...
        'YTicklabel',[],...
        'xtick',[],...
        'ytick',[],...
        'ytick',[],'Position',[1,1,6,5]);
%4K data
H1=MH_table.H2;
M1=V*MH_table.KM2;
%5K data
H2=MH_table.H3;
M2=V*MH_table.KM3;
%6K data
H3=MH_table.H4;
M3=V*MH_table.KM4;

%plot data
plot(H1/10,M1*1e4,'Color',red,'LineWidth',1)
hold on
plot(H2/10,M2*1e4,'Color',blue,'LineWidth',1)
plot(H3/10,M3*1e4,'Color',green,'LineWidth',1)

xlabel('$\mu_0H (mT)$','Interpreter','latex','FontSize',fontsize)
ylabel('$\mu\times10^{-4} (emu)$','Interpreter','latex','FontSize',fontsize)
legend('4.2K','5K','6K','Position',[0.4,0.18,0.056,0.075])
xlim([-20,20])
text(-39,760,'a','Color',fontcolor,'FontSize',fontsize)

%plot MT
MT_ax=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
        'XColor',fontcolor,...
        'LineWidth',linewidth,...
        'FontSize',fontsize,...   
        'Color','none',...
        'Units','Inches',...
        'XTickLabel',[],...
        'YTicklabel',[],...
        'xtick',[],...
        'ytick',[],...
        'ytick',[],'Position',[8,1,6,5]);
load MT_data.mat;
T=MT_table.T;
M=V*MT_table.MAt500Oe;
red='#e34a33';

plot(T,M*1e4,'Color',red,'LineWidth',2)
xlabel('$T (K)$','Interpreter','latex','FontSize',fontsize)
ylabel('$\mu\times10^{-4} (emu)$','Interpreter','latex','FontSize',fontsize)
text(0.5,780,'b','Color',fontcolor,'FontSize',fontsize)
set(MT_ax,'Fontsize',fontsize)
set(MH_ax,'Fontsize',fontsize)
set(fig,'Color','w')