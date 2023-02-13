    folder='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_3.txt');
    blue="#3182bd";
    red="#d95f0e";
len=length(info.Name);
PP=zeros(1,len);
twidth=3;theight=3;
xspace=1;
yspace=0.7;
fontcolor='k';
linewidth=2;
fontsize=14;
color=blue;
Icup=zeros(1,len);
Icdown=zeros(1,len);
threshold=2e-6;
filter='rloess';
avg=50;
fig=figure;
set(fig,'Units','inches','Position',[0,0,15,7])
curves=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
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

for i=1:len
    file_name=info.Name(i);
    Field=info.Field_Sweep(i);
    cindex=abs(Field-200)+1;
    Hall_Table=readtable(strcat(folder,char(file_name)));
    Hall_Mat=cell2mat(table2cell(Hall_Table));
    Vb=Hall_Mat(:,1)';
    Ib=Hall_Mat(:,2)';
    Vx=Hall_Mat(:,3)';
    Vx=Vx-Vx(1);
    
    Vup=Vx(1:floor(end/2));
    Vdown=Vx(floor(end/2)+1:end);
    
    
    Iup=Ib(1:floor(end/2));
    Idown=Ib(floor(end/2)+1:end);

    Vx=[flip(Vdown),Vup];
    Ib=[flip(Idown),Iup];
%smooth data
%      Vup=smoothdata(Vup,filter,avg);
%      Vdown=smoothdata(Vdown,filter,avg);
%      Iup=smoothdata(Iup,filter,avg);
%      Idown=smoothdata(Idown,filter,avg);
%differentiate    
%     dVup=diff(Vup)./diff(Iup);
%     dVup=dVup-dVup(1);
%remove linear trend
%     p=polyfit(Iup(1:15),Vup(1:15),1);
%     Vup=Vup-polyval(p,Iup);
% 
%     p=polyfit(Idown(1:15),Vdown(1:15),1);
%     Vdown=Vdown-polyval(p,Idown);
    
%     dVdown=diff(Vdown)./diff(Idown);
%     dVdown=dVdown-dVdown(1);
    
 %   find Ic
    indexup=find(Vup>threshold);
    Icup(i)=Iup(min(indexup));
    indexdown=find(Vdown<-threshold);
    Icdown(i)=Idown(min(indexdown));
    if Icup(i)+Icdown(i)>0.15e-3
        color=red;
    else
        if Icup(i)+Icdown(i)<-0.15e-3
            color=blue;
        else
            color='g';
        end
    end
    if i==10
        plot(Iup*1e3,Vup*1e6,'Color',color,'LineWidth',2);
        hold on
        plot(Idown*1e3,Vdown*1e6,'Color',color,'LineWidth',2);
        plot([0,max(Iup)]*1e3,[threshold,threshold]*1e6,'Color','k','LineStyle','--','LineWidth',2);
        plot([min(Idown),0]*1e3,[-threshold,-threshold]*1e6,'Color','k','LineStyle','--','LineWidth',2);
    end
end
xlabel('$I_b (mA)$','Interpreter','latex','FontSize',fontsize);
ylabel('$V_x (\mu V)$','Interpreter','latex','FontSize',fontsize);
text(-0.34,18.5,'b','FontSize',fontsize,'Color',fontcolor)
ylim([-40,20]);
xlim([-0.35,0.35]);
X=info.Field_Sweep';
X=X-35;

transport1=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
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
plot(X/10,(Icup+Icdown)*1e3,'.','Color',blue,'MarkerSize',10);
xlabel('$\mu_0H_y (mT)$','Interpreter','latex','FontSize',fontsize)
ylabel('$\Delta I_c (mA)$','Interpreter','latex','FontSize',fontsize)
hold on
ylim([-0.27,0.27]);
xlim([-20,20]);
text(-19,0.25,'a','FontSize',fontsize,'Color',fontcolor)
annotation('arrow',[0.23,0.23],[0.75,0.65],'Color',blue);
annotation('arrow',[0.16,0.16],[0.54,0.25],'Color',blue);
annotation('arrow',[0.3,0.3],[0.25,0.54],'Color',blue);
annotation('arrow',[0.38,0.38],[0.65,0.75],'Color',blue);
set(fig,'Color','w')
set(transport1,'Fontsize',fontsize)
set(curves,'Fontsize',fontsize)

%%
%plot longitudinal transport data:
    folder='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_2.txt');

len=length(info.Name);
PP=zeros(1,len);
Icup=zeros(1,len);
Icdown=zeros(1,len);
threshold=1.5e-6;
for i=1:len
    file_name=info.Name(i);
    Field=info.Field_Sweep(i);
    cindex=abs(Field-200)+1;
    Hall_Table=readtable(strcat(folder,char(file_name)));
    Hall_Mat=cell2mat(table2cell(Hall_Table));
    Vb=Hall_Mat(:,1)';
    Ib=Hall_Mat(:,2)';
    Vx=Hall_Mat(:,3)';
    Vx=Vx-Vx(1);
    Y=max(Vx)+min(Vx);
    Vup=Vx(1:floor(end/2));
    Vdown=Vx(floor(end/2)+1:end);
    Iup=Ib(1:floor(end/2));
    Idown=Ib(floor(end/2)+1:end);
    indexup=find(Vup>threshold);
    Icup(i)=Iup(min(indexup));
    indexdown=find(Vdown<-threshold);
    Icdown(i)=Idown(min(indexdown));
    if Icup(i)+Icdown(i)>0.15e-3
        color=red;
    else
        if Icup(i)+Icdown(i)<-0.15e-3
            color=blue;
        else
            color='g';
        end
    end
    plot(Iup,Vup,'Color',color);
    hold on
    plot(Idown,Vdown,'Color',color);
    plot([0,max(Iup)],[threshold,threshold],'Color','k','LineStyle','--','LineWidth',2);
    plot([min(Idown),0],[-threshold,-threshold],'Color','k','LineStyle','--','LineWidth',2);
    xlim([-3e-4,3e-4]);
    ylim([-2e-5,2e-5]);

end
X=info.Field_Sweep';
%remove field offset
X=X-35;
fig=figure;
transport1=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
        'XColor',fontcolor,...
        'LineWidth',linewidth,...
        'FontSize',fontsize,...   
        'Color','none',...
        'Units','Inches',...
        'XTickLabel',[],...
        'YTicklabel',[],...
        'xtick',[],...
        'ytick',[],...
        'ytick',[]);
plot(X/10,(Icup+Icdown)*1e3,'.','Color',red,'MarkerSize',10);

%annotation('arrow',[0.27,0.17],[0.94,0.94],'Color',blue);
%annotation('arrow',[0.16,0.16],[0.89,0.77],'Color',blue);
%annotation('arrow',[0.125,0.125],[0.73,0.6],'Color',blue);
%annotation('arrow',[0.09,0.17],[0.548,0.548],'Color',blue);
%annotation('arrow',[0.2,0.2],[0.58,0.73],'Color',blue);
%annotation('arrow',[0.246,0.246],[0.77,0.89],'Color',blue);
%annotation('doublearrow',[0.19,0.14],[0.72,0.72],'Color',red);
%annotation('arrow',[0.06,0.13],[0.5,0.51],'Color','r');
hold on
plot([-25,25],[0,0],'Color','k','LineStyle','--','LineWidth',2);
xlabel(transport1,'\mu_0H (mT)','FontSize',fontsize);
ylabel(transport1,'\DeltaI_c (mA)','FontSize',fontsize);
%legend({'Transverse','Longitudinal'});
text(0.05,0.94,'a','Units','normalized','FontSize',fontsize,'Color',fontcolor)
%set(transport1,'YTick',[-0.2:0.1:0.2],'YTickLabel',{-0.2:0.1:0.2},'XTickLabel',{},'FontSize',fontsize)
%plot MH