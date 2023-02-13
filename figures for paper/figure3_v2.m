    %%
    %figure 2
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
        title(strcat('\mu_0H_x=',string(Field),'mT'),'Color',fontcolor,'FontSize',fontsize)
    else
        title(strcat('\mu_0H_y=',string(Field),'mT'),'Color',fontcolor,'FontSize',fontsize)
    end
    xlim(h(i,j),[min(min(X)),max(max(X))]);
    ylim(h(i,j),[min(min(Y)),max(max(Y))]);
    
    set(h(i,j),'XTicklabel',[],'YTicklabel',[])
    text(0.5,18,max(max(Z)),letterlabel{i,j},'FontSize',fontsize,'Color',fontcolor);
    if and(i==1,j==3)
        lw=1.5;
        hold on   
        plot3([1,3],[1,1],[1,1]*max(max(Z)),'Color',fontcolor,'LineWidth',lw);
        plot3([1,1],[0.75,1.25],[1,1]*max(max(Z)),'Color',fontcolor,'LineWidth',lw);
        plot3([3,3],[0.75,1.25],[1,1]*max(max(Z)),'Color',fontcolor,'LineWidth',lw);
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
    title(axcbar,strcat(num2str(round(max(max(Z))-min(min(Z)),1)),'mT'),'FontSize',8,'Color',fontcolor);

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
for i=1:len
    file_name=info.Name(i);
    Field=info.Field_Sweep(i);
    cindex=abs(Field-200)+1;
    Hall_Table=readtable(strcat(folder,char(file_name)));
    Hall_Mat=cell2mat(table2cell(Hall_Table));
    Vb=Hall_Mat(:,1)';
    Ib=Hall_Mat(:,2)';
    Vx=Hall_Mat(:,3)';
    avg_ind=find(abs(Ib)<25e-6);
    offset=mean(Vx(avg_ind));
    Vx=Vx-offset;
    Y=max(Vx)+min(Vx);
    if Y<2e-4
        PP(i)=Y;
    end
    
   
end
X=info.Field_Sweep';
X=X-35;
plot(X/10,PP*1e6,'.','Color','b','MarkerSize',10);
hold on
ylim([-40,40]);
xlim([-20,20]);
%plot transport data:
    folder='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_2.txt');

len=length(info.Name);
PP=zeros(1,len);

for i=1:len
    file_name=info.Name(i);
    Field=info.Field_Sweep(i);
    cindex=abs(Field-200)+1;
    Hall_Table=readtable(strcat(folder,char(file_name)));
    Hall_Mat=cell2mat(table2cell(Hall_Table));
    Vb=Hall_Mat(:,1)';
    Ib=Hall_Mat(:,2)';
    Vx=Hall_Mat(:,3)';
    avg_ind=find(abs(Ib)<25e-6);
    offset=mean(Vx(avg_ind));
    Vx=Vx-offset;
    Y=max(Vx)+min(Vx);
    if Y<2e-4
        PP(i)=Y;
    end
    
   
end
X=info.Field_Sweep';
%remove field offset
X=X-35;
plot(X/10,PP*1e6,'.','Color','r','MarkerSize',10);
annotation('arrow',[0.275,0.165],[0.93,0.92],'Color','b');
annotation('arrow',[0.155,0.153],[0.88,0.8],'Color','b');
annotation('arrow',[0.12,0.12],[0.75,0.59],'Color','b');
annotation('arrow',[0.1,0.18],[0.55,0.57],'Color','b');
annotation('arrow',[0.19,0.19],[0.6,0.75],'Color','b');
annotation('arrow',[0.24,0.24],[0.79,0.89],'Color','b');
annotation('doublearrow',[0.18,0.13],[0.72,0.73],'Color','r');
%annotation('arrow',[0.06,0.13],[0.5,0.51],'Color','r');
text(14.4,-24.5,'H\perpI','FontSize',fontsize,'Color','b');
text(14.4,6.3,'H_{||}I','FontSize',fontsize,'Color','r')
xlabel(transport1,'\mu_0H (mT)','FontSize',fontsize);
ylabel(transport1,'\eta (\muV)','FontSize',fontsize);
%legend({'Transverse','Longitudinal'});
title('a','FontSize',fontsize,'Color',fontcolor,'Position',[-18,-32,0]);
set(transport1,'YTick',[-30:15:30],'YTickLabel',{-30:15:30},'XTickLabel',{},'Ydir','reverse','FontSize',fontsize)
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
title('b','FontSize',fontsize,'Color',fontcolor,'Position',[-18,4*1e-4,0]);
annotation('arrow',[0.145,0.145],[0.35,0.25],'Color','k');
annotation('arrow',[0.21,0.21],[0.25,0.35],'Color','k');
%%