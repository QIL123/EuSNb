    %%
    %figure 2
folder1='/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/14/SXM/';
info1=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/14/Info_Batch_4.txt');
folder2='/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/16/SXM/';
info2=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/16/Info_Batch_1.txt');

channel='Input_3';
sens=2e-3;
spacingx=0.5;
spacingy=0.5;
pwidth=2.5;
pheight=2.5;
load 'wyko.mat'
index_list=[2,10,18;2,10,18];
fig=figure;
set(fig,'Units','inches','Position',[0,0,11,10])
h=[];
letterlabel={'d','e','f';'a','b','c'};
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
    
    

    %set axis
    fontsize=12;
    fontcolor='k';
    linewidth=1;
    position=[0.5+spacingx*j+pwidth*(j-1),3.5+spacingy*i+pheight*(i-1),pwidth,pheight];
   
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
    Field=Field/2+60;
    if i==1
        title(strcat('\mu_0H_x=',string(Field),'G'),'Color',fontcolor,'FontSize',fontsize)
    else
        title(strcat('\mu_0H_y=',string(Field),'G'),'Color',fontcolor,'FontSize',fontsize)
    end
    xlim(h(i,j),[min(min(X)),max(max(X))]);
    ylim(h(i,j),[min(min(Y)),max(max(Y))]);
    caxis([-0.8,0.8]);
    set(h(i,j),'XTicklabel',[],'YTicklabel',[])
    text(0.5,18,max(max(Z)),letterlabel{i,j},'FontSize',fontsize,'Color',fontcolor);
    if and(i==2,j==1)
        lw=1.5;
        hold on
        plot3([1,3],[1,1],[1,1]*max(max(Z)),'Color',fontcolor,'LineWidth',lw);
        plot3([1,1],[0.75,1.25],[1,1]*max(max(Z)),'Color',fontcolor,'LineWidth',lw);
        plot3([3,3],[0.75,1.25],[1,1]*max(max(Z)),'Color',fontcolor,'LineWidth',lw);
        text(1,2,max(max(Z)),'2\mum','Color',fontcolor,'FontSize',fontsize)
    end
    end
end
ax1=axes(fig,'visible','off');
set(ax1,'colormap',[r g b],'Clim',[-0.8,0.8],'color','w')
c=colorbar(ax1,'Position',[0.9,0.42,0.015,0.5],'FontSize',fontsize-2);
c.Label.String='B_z^{AC} [G]';
xlabel('Y [\mum]','Visible','on','Position',[0.4,0.33],'Units','normalized','FontSize',fontsize)
ylabel('X [\mum]','Visible','on','Position',[-0.1,0.7],'Units','normalized','FontSize',fontsize)

%plot transport data:

    %IV transport
    folder1='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    info1=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_3.txt');
    folder2='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    info2=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_2.txt');
h=[];
letterlabel={'g','h','i'};
index_mat=[19,3;50,11;143,34];
% deltaH=max(info.Field_Sweep)-min(info.Field_Sweep);
% jetcustom=jet(deltaH+1);
for i=1:3
    %set axis
    fontsize=12;
    fontcolor='k';
    linewidth=1;
    position=[0.5+spacingx*i+pwidth*(i-1),0.3+spacingy,pwidth,pheight];
   
    h(i)=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
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
      
    
 
    

    % Create colorbar
    % c=colorbar(subplot1,'Color',fontcolor);
    % c.Label.String='B_z^{AC}(x,y)';
    %     % Create ylabel
    % ylabel('Y [\mum]');
    % 
    % % Create xlabel
    % xlabel('X [\mum]');
    % %title

    file_name=info1.Name(index_mat(i,1));
    Field=info1.Field_Sweep(index_mat(i,1))-50;
%    cindex=abs(Field-(max(info.Field_Sweep)-50))+1;
    Hall_Table=readtable(strcat(folder,char(file_name)));
    Hall_Mat=cell2mat(table2cell(Hall_Table));
    Vb=Hall_Mat(:,1)';
    Ib=Hall_Mat(:,2)';
    Vx=Hall_Mat(:,3)';
    if max(abs(Vx))<1e-3
        plot(Ib*1e3,Vx,'.','Color','r');
        text(0.1,0.6,'H\perp I','Units','normalized','Color','r')
    end
    hold on
    file_name=info2.Name(index_mat(i,2));
    Field=info2.Field_Sweep(index_mat(i,2))-50;
%    cindex=abs(Field-(max(info.Field_Sweep)-50))+1;
    Hall_Table=readtable(strcat(folder,char(file_name)));
    Hall_Mat=cell2mat(table2cell(Hall_Table));
    Vb=Hall_Mat(:,1)';
    Ib=Hall_Mat(:,2)';
    Vx=Hall_Mat(:,3)';
    if max(abs(Vx))<1e-3
        plot(Ib*1e3,Vx,'.','Color','b');
        text(0.3,0.3,'H_{||}I','Units','normalized','Color','b')
    end
   text(0.05,0.9,letterlabel{i},'Units','normalized',"FontSize",fontsize)
   if i==1
       ylabel('V_x[V]','FontSize',fontsize)
   end
   if i==2
     xlabel('I_x[mA]','FontSize',fontsize)
   end
end

%%