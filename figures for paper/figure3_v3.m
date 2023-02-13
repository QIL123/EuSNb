    %%
    %figure 3
folder1='/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/14/SXM/';
info1=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/14/Info_Batch_4.txt');
folder2='/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/16/SXM/';
info2=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/16/Info_Batch_1.txt');

channel='DC_(Vfb)';
sens=10;
spacingx=0.5;
spacingy=0.5;
pwidth=2.5;
pheight=2.5;
load 'wyko.mat'
index_list=[2,11,18;2,11,18];
fig=figure;
set(fig,'Units','inches','Position',[0,0,14,7])
h=[];
letterlabel={'f','g','h';'c','d','e'};
    blue="#3182bd";
    red="#d95f0e";
%gmin=0;
%gmax=0;
%first subplot
for i=1:2
    for j=1:3
    if i==2
        file_name=info1.Name(index_list(i,j));
        img=Proccess_Data.Create_IMG(folder1,char(file_name),info1);
    else
        file_name=info2.Name(index_list(i,j));
        img=Proccess_Data.Create_IMG(folder2,char(file_name),info2);
    end
    
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img,channel,sens,-50);
    Z=Z/10;
    

    %set axis
    fontsize=14;
    fontcolor='k';
    linewidth=1;
    position=[4+spacingx*j+pwidth*(j-1),0.4+spacingy*i+pheight*(i-1),pwidth,pheight];
   
    h(i,j)=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
        'XColor',fontcolor,...
        'LineWidth',linewidth,...
        'FontSize',fontsize,...   
        'Color','none',...
        'Units','Inches',...
        'XTickLabel',[],...
        'YTicklabel',[],...
        'xtick',[],...
        'ytick',[],...
        'ytick',[],...
        'Position',position);
      
     surf(X,Y,Z','FaceColor','interp',...
    'EdgeColor','none');

    view(2);
    shading interp;
    set(gcf,'colormap',[r g b],'Color','w')
    caxis([min(min(Z)),max(max(Z))]);
    set(h(i,j),'colormap',[r g b],'Clim',[min(min(Z)),max(max(Z))],'color','w')
    %c=colorbar(h(i,j),'Color',fontcolor,'Location','northoutside','Units','inches','Ticks',[]);
    %c.Label.String='mT';
    
    % Create colorbar
    % c=colorbar(subplot1,'Color',fontcolor);
    % c.Label.String='B_z^{AC}(x,y)';
    %     % Create ylabel
    % ylabel('Y [\mum]');
    % 
    % % Create xlabel
    % xlabel('X [\mum]');
    % %title
    Field=img.info.Field_Sweep;
    Field=(Field/2+60)/10;
    if i==1
        title(strcat('$\mu_0H_x=',string(Field),'$mT'),'Interpreter','latex','Color',fontcolor,'FontSize',fontsize)
    else
        title(strcat('$\mu_0H_y=',string(Field),'$mT'),'Interpreter','latex','Color',fontcolor,'FontSize',fontsize)
    end
    xlim(h(i,j),[min(min(X)),max(max(X))]);
    ylim(h(i,j),[min(min(Y)),max(max(Y))]);
    
    set(h(i,j),'XTicklabel',[],'YTicklabel',[])
    text(0.5,18,max(max(Z)),letterlabel{i,j},'FontSize',fontsize,'Color',fontcolor);
    if and(i==1,j==3)
        lw=1.5;
        hold on   
        plot3([1,3],[1,1],[1,1]*max(max(Z)),'Color',fontcolor,'LineWidth',lw);
        text(1,2,max(max(Z)),'2\mum','Color',fontcolor,'FontSize',fontsize)
    end
    if and(i==1,j==1)   
        hold on
        annotation("arrow",[0.34,0.34],[0.16,0.21],'Color',fontcolor)
        text(2,4,max(max(Z)),'x','FontSize',fontsize);
        annotation("arrow",[0.34,0.36],[0.16,0.16],'Color',fontcolor)
        text(3.8,2,max(max(Z)),'y','FontSize',fontsize);        
    end
    %plot colorbar
        cbarpos=[position(1)+pwidth*0.8,position(2)+pheight*1.02,pwidth/5,pheight/40];
        axcbar=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
        'XColor',fontcolor,...
        'LineWidth',linewidth,...
        'FontSize',fontsize,...   
        'Color','none',...
        'Units','Inches',...
        'XTickLabel',[],...
        'YTicklabel',[],...
        'xtick',[],...
        'ytick',[],...
        'ytick',[],...
        'Position',cbarpos);

        %plot plane with colorscale to match image
        cbarA=linspace(min(min(Z)),max(max(Z)),100);
        cbarB=ones(10,1);
        x=1:100;
        y=1:10;
        cbar=cbarB*cbarA;
     surf(x,y,cbar,'FaceColor','interp',...
    'EdgeColor','none','Parent',axcbar);

    view(2);
    shading interp;
    set(gcf,'colormap',[r g b],'Color','w')
    caxis([min(min(Z)),max(max(Z))]);
    xlim([1,100]);
    ylim([1,10]);
    set(axcbar,'XTick',[],'XTicklabel',{},'YTick',[],'YTicklabel',{})
    title(axcbar,strcat('$',num2str(round(max(max(Z))-min(min(Z)),1)),'$mT'),'Interpreter','latex','FontSize',8,'Color',fontcolor);

    end
end
%ax1=axes(fig,'visible','off');
%set(ax1,'colormap',[r g b],'Clim',[gmin,gmax],'color','w')
%c=colorbar(ax1,'Position',[0.94,0.25,0.01,0.5],'FontSize',fontsize-2);
%c.Label.String='B_z [G]';
%xlabel('Y [\mum]','Visible','on','Position',[0.66,-0.075],'FontSize',fontsize)
%ylabel('X [\mum]','Visible','on','Position',[0.3,0.5],'FontSize',fontsize)

%plot transport data:
    folder='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_3.txt');

len=length(info.Name);
PP=zeros(1,len);
twidth=3;theight=3;
xspace=1;
yspace=0.7;
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
        'ytick',[],...
        'Position',[xspace,yspace+theight,twidth,theight]);

Icup=zeros(1,len);
Icdown=zeros(1,len);
threshold=0.002;
filter='rloess';
avg=50;
for i=1:len
    file_name=info.Name(i);
    Field=info.Field_Sweep(i);
    cindex=abs(Field-200)+1;
    Hall_Table=readtable(strcat(folder,char(file_name)));
    Hall_Mat=cell2mat(table2cell(Hall_Table));
    Vb=Hall_Mat(:,1)';
    Ib=Hall_Mat(:,2)';
    Vx=Hall_Mat(:,3)';
    Y=max(Vx)+min(Vx);
    Vup=Vx(1:floor(end/2));
    Vdown=Vx(floor(end/2)+1:end);
    Iup=Ib(1:floor(end/2));
    Idown=Ib(floor(end/2)+1:end);
%smooth data
    Vup=smoothdata(Vup,filter,avg);
    Vdown=smoothdata(Vdown,filter,avg);
    Iup=smoothdata(Iup,filter,avg);
    Idown=smoothdata(Idown,filter,avg);
%differentiate    
    dVup=diff(Vup)./diff(Iup);
    dVup=dVup-dVup(1);
    %
    %plot(Iup(2:end),dVup);
    dVdown=diff(Vdown)./diff(Idown);
    dVdown=dVdown-dVdown(1);
    %hold on
    %plot(Idown(2:end),dVdown);
    %find Ic
    indexup=find(dVup>threshold);
    Icup(i)=Iup(min(indexup));
    indexdown=find(dVdown>threshold);
    Icdown(i)=Idown(min(indexdown));
end
X=info.Field_Sweep';
X=X-35;
plot(X/10,(Icup+Icdown)*1e3,'.','Color',blue,'MarkerSize',10);
hold on
ylim([-0.27,0.27]);
xlim([-20,20]);
%plot longitudinal transport data:
    folder='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_2.txt');

len=length(info.Name);
PP=zeros(1,len);
Icup=zeros(1,len);
Icdown=zeros(1,len);
threshold=0.005;
for i=1:len
    file_name=info.Name(i);
    Field=info.Field_Sweep(i);
    cindex=abs(Field-200)+1;
    Hall_Table=readtable(strcat(folder,char(file_name)));
    Hall_Mat=cell2mat(table2cell(Hall_Table));
    Vb=Hall_Mat(:,1)';
    Ib=Hall_Mat(:,2)';
    Vx=Hall_Mat(:,3)';
    Y=max(Vx)+min(Vx);
    Vup=Vx(1:floor(end/2));
    Vdown=Vx(floor(end/2)+1:end);
    Iup=Ib(1:floor(end/2));
    Idown=Ib(floor(end/2)+1:end);
%smooth data
    Vup=smoothdata(Vup,filter,avg);
    Vdown=smoothdata(Vdown,filter,avg);
    Iup=smoothdata(Iup,filter,avg);
    Idown=smoothdata(Idown,filter,avg);

%differentiate    
    dVup=diff(Vup)./diff(Iup);
    dVup=dVup-dVup(1);
    %plot(Iup(2:end),dVup);
    dVdown=diff(Vdown)./diff(Idown);
    dVdown=dVdown-dVdown(1);
    %hold on
    %plot(Idown(2:end),dVdown);
    %find Ic
    indexup=find(dVup>threshold);
    Icup(i)=Iup(min(indexup));
    indexdown=find(dVdown>threshold);
    Icdown(i)=Idown(min(indexdown));  
end
X=info.Field_Sweep';
%remove field offset
X=X-35;
plot(X/10,(Icup+Icdown)*1e3,'.','Color',red,'MarkerSize',10);
annotation('arrow',[0.27,0.17],[0.94,0.94],'Color',blue);
annotation('arrow',[0.16,0.16],[0.89,0.77],'Color',blue);
annotation('arrow',[0.125,0.125],[0.73,0.6],'Color',blue);
annotation('arrow',[0.09,0.17],[0.548,0.548],'Color',blue);
annotation('arrow',[0.2,0.2],[0.58,0.73],'Color',blue);
annotation('arrow',[0.246,0.246],[0.77,0.89],'Color',blue);
annotation('doublearrow',[0.19,0.14],[0.72,0.72],'Color',red);
%annotation('arrow',[0.06,0.13],[0.5,0.51],'Color','r');
text(14.4,0.15,'$H_y$','Interpreter','latex','FontSize',fontsize,'Color',blue);
text(14.4,0.04,'$H_x$','Interpreter','latex','FontSize',fontsize,'Color',red)
xlabel(transport1,'\mu_0H (mT)','FontSize',fontsize);
ylabel(transport1,'\DeltaI_c (mA)','FontSize',fontsize);
%legend({'Transverse','Longitudinal'});
text(0.05,0.94,'a','Units','normalized','FontSize',fontsize,'Color',fontcolor)
set(transport1,'YTick',[-0.2:0.1:0.2],'YTickLabel',{-0.2:0.1:0.2},'XTickLabel',{},'FontSize',fontsize)
%plot MH
transport2=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
        'XColor',fontcolor,...
        'LineWidth',linewidth,...
        'FontSize',fontsize,...   
        'Color','none',...
        'Units','Inches',...
        'XTickLabel',[],...
        'YTicklabel',[],...
        'xtick',[],...
        'ytick',[],...
        'ytick',[],...
        'Position',[xspace,yspace,twidth,theight]);
folder='/Users/along/Documents/Alon/Msc/Research/Data/Cambridge Data/';
file='In plane MH 4p2K minor for plotting.txt';
MHtable=readtable(strcat(folder,file));

MHmat=cell2mat(table2cell(MHtable));
H=MHmat(:,1)/10;
M=MHmat(:,2);
plot(H,M,'Color','k','LineWidth',2);
xlim([-20,20]);
ylabel('\mu\times10^{-4} (emu)','FontSize',fontsize,'Color',fontcolor)
xlabel('\mu_0H (mT)','FontSize',fontsize,'Color',fontcolor)
set(transport2,'YTick',[-4:2:4]*1e-4,'YTickLabel',{-4:2:4},'FontSize',fontsize)
text(0.05,0.94,'b','Units','normalized','FontSize',fontsize,'Color',fontcolor);
annotation('arrow',[0.145,0.145],[0.35,0.25],'Color','k');
annotation('arrow',[0.21,0.21],[0.25,0.35],'Color','k');
%%