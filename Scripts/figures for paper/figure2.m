    %%
    %figure 2
    current_folder=pwd;
folder1='/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/14/SXM/';
%folder1=strcat(current_folder,'\Data\2022\Apr\14\SXM\');
info1=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/14/Info_Batch_4.txt');
%info1=readtable(strcat(current_folder,'\Data\2022\Apr\14\Info_Batch_4.txt');
folder2='/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/16/SXM/';
%folder2=strcat(current_folder,'\Data\2022\Apr\16\SXM\');
info2=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/16/Info_Batch_1.txt');
%info2=readtable(strcat(current_folder,'\Data\2022\Apr\16\Info_Batch_1.txt');
channel='Input_3';
sens=2e-3;
spacingx=0.5;
spacingy=0.5;
pwidth=2.5;
pheight=2.5;
load 'wyko.mat'
index_list=[2,25,18;2,25,18];
fig=figure;
set(fig,'Units','inches','Position',[0,0,14.8,7])
h=[];
letterlabel={'f','g','h';'c','d','e'};
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
    
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img,channel,sens);
    %convert to mT
    Z=Z/10;
    

    %set axis
    fontsize=14;
    fontcolor='k';
    linewidth=1;
    position=[4.5+spacingx*j+pwidth*(j-1),0.3+spacingy*i+pheight*(i-1),pwidth,pheight];
   
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
    caxis([-0.08,0.08]);
    set(h(i,j),'XTicklabel',[],'YTicklabel',[])
    text(0.5,18,max(max(Z)),letterlabel{i,j},'FontSize',fontsize,'Color',fontcolor);
    if and(i==2,j==1)
        lw=1.5;
        hold on
        plot3([1,3],[1,1],[1,1]*max(max(Z)),'Color',fontcolor,'LineWidth',lw);

        text(1,2,max(max(Z)),'2\mum','Color',fontcolor,'FontSize',fontsize)
    end
    if and(i==1,j==1)   
        hold on
        annotation("arrow",[0.35,0.35],[0.15,0.2],'Color',fontcolor,'HeadLength',5,'HeadWidth',5)
        text(1.8,3.8,max(max(Z)),'x','FontSize',fontsize);
        annotation("arrow",[0.35,0.375],[0.15,0.15],'Color',fontcolor,'HeadLength',5,'HeadWidth',5)
        text(3.8,1.8,max(max(Z)),'y','FontSize',fontsize);        
    end
    end
end
ax1=axes(fig,'visible','off');
set(ax1,'colormap',[r g b],'Clim',[-0.08,0.08],'color','w')
c=colorbar(ax1,'Position',[0.92,0.25,0.01,0.5],'FontSize',fontsize-2);
c.Label.String='B_z^{ac} (mT)';
%xlabel('Y [\mum]','Visible','on','Position',[0.66,-0.02],'FontSize',fontsize)
%ylabel('X [\mum]','Visible','on','Position',[0.25,0.5],'FontSize',fontsize)

%plot transport data:

    %IV transport
    folder='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    %folder=strcat(current_folder,'\Data\2022\Jul\06\Transport\');
    info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_3.txt');
    %info=readtable(strcat(current_folder,'\Data\2022\Jul\06\Info_Batch_3.txt');
len=length(info.Name);
% deltaH=max(info.Field_Sweep)-min(info.Field_Sweep);
% jetcustom=jet(deltaH+1);

colors={'#d7191c','#1a9641','#2b83ba'};
text_pos=[0.1,0.1;0.35,0.6;0.55,0.85];
text_pos2=[0.1,0.1;0.35,0.6;0.5,0.9];
twidth=3.3;theight=2.8;
xspace=0.75;
yspace=0.8;
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
n=1;
for i=[22,167,140]
    file_name=info.Name(i);
    Field=info.Field_Sweep(i)-35;
    Field=Field/10;
%    cindex=abs(Field-(max(info.Field_Sweep)-50))+1;
    Hall_Table=readtable(strcat(folder,char(file_name)));
    Hall_Mat=cell2mat(table2cell(Hall_Table));
    Vb=Hall_Mat(:,1)';
    Ib=Hall_Mat(:,2)';
    Vx=Hall_Mat(:,3)';
    avg_ind=find(abs(Ib)<25e-6);
    offset=mean(Vx(avg_ind));
    if max(abs(Vx))<1e-3
        plot(Ib*1e3,(Vx-offset)*1e6,'.','Color',colors{n});
        text(text_pos(n,1),text_pos(n,2),strcat('$\mu_0H_y=',string(Field),'$mT'),'Interpreter','latex','FontSize',fontsize, ...
            'Units','normalized','Color',colors{n})
    end
    hold on
    n=n+1;
   
end
set(transport1,'YTick',[-40:20:40],'YTickLabel',{-40:20:40},...
        'XTicklabel',{},'FontSize',fontsize)
%colormap(transport1,jetcustom);
% cb=colorbar;
%caxis([-300,200]);
%cb=colorbar(transport1,'Position',[0.275,0.25,0.01,0.5],'FontSize',fontsize-2);
%cb.Label.String='\mu_0H [G]';
%x1=transport1.XLim(1);x2=transport1.XLim(2);y1=transport1.YLim(1);y2=transport1.YLim(2);
%text(x1+0.05*(x2-x1),y2-0.05*(y2-y1),'a','FontSize',fontsize,'Color',fontcolor)
text(0.05,0.95,'a','Units','normalized','FontSize',fontsize,'Color',fontcolor)
annotation("arrow",[0.175,0.195],[0.7,0.7],'Color',fontcolor,'LineWidth',linewidth+1,'HeadStyle','vback1','HeadLength',5,'HeadWidth',5)
annotation("arrow",[0.155,0.135],[0.725,0.725],'Color',fontcolor,'LineWidth',linewidth+1,'HeadStyle','vback1','HeadLength',5,'HeadWidth',5)
%second transport plot
    folder='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    %folder=strcat(current_folder,'\Data\2022\Jul\06\Transport\');
    info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_2.txt');
    %info=readtable(strcat(current_folder,'\Data\2022\Jul\06\Info_Batch_2.txt'));
len=length(info.Name);
% deltaH=max(info.Field_Sweep)-min(info.Field_Sweep);
% jetcustom=jet(deltaH+1);

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
        'Position',[xspace,yspace,twidth,theight]);
n=1;
for i=[4,47,14]
    file_name=info.Name(i);
    Field=info.Field_Sweep(i)-35;
    Field=Field/10;
    %cindex=abs(Field-(max(info.Field_Sweep)-50))+1;
    Hall_Table=readtable(strcat(folder,char(file_name)));
    Hall_Mat=cell2mat(table2cell(Hall_Table));
    Vb=Hall_Mat(:,1)';
    Ib=Hall_Mat(:,2)';
    Vx=Hall_Mat(:,3)';
    avg_ind=find(abs(Ib)<25e-6);
    offset=mean(Vx(avg_ind));
    if max(abs(Vx))<1e-3
        plot(Ib*1e3,(Vx-offset)*1e6,'.','Color',colors{n});
        text(text_pos2(n,1),text_pos2(n,2),strcat('$\mu_0H_x=',string(Field),'$mT'),'Interpreter','latex','FontSize',fontsize,'Units','normalized','Color',colors{n})
    end
    n=n+1;
    hold on
   
end

%colormap(transport2,jetcustom);
set(transport2,'YTicklabel',{-30:15:30},...
      'ytick',(-30:15:30),'XTickLabelMode','auto','FontSize',fontsize);

text(0.05,0.95,'b','Units','normalized','FontSize',fontsize,'Color',fontcolor)
annotation("arrow",[0.17,0.19],[0.3,0.3],'Color',fontcolor,'LineWidth',linewidth+1,'HeadStyle','vback1','HeadLength',5,'HeadWidth',5)
annotation("arrow",[0.16,0.14],[0.325,0.325],'Color',fontcolor,'LineWidth',linewidth+1,'HeadStyle','vback1','HeadLength',5,'HeadWidth',5)
xlabel(transport2,'I_x^{dc}(mA)','FontSize',fontsize,'Color',fontcolor)
ylabel(transport2,'V_x^{dc}(\muV)','FontSize',fontsize,'Color',fontcolor,'Position',[-0.479105263157895,39.897115384615404,0])
%cb=colorbar
%caxis([-200,200]);
%%