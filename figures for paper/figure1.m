%figure 1
folder='/Users/along/Documents/Alon/Msc/Research/Data/2021/Oct/26/SXM/';
info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2021/Oct/26/Info_Batch_2.txt');
channel='TF_X';
sens=10e-3;
    fontsize=14;
    fontcolor='k';
linewidth=1;
load 'wyko.mat'

fig=figure;
set(fig,'Units','inches','Position',[0,0,13,7])
pwidth=6;
pheight=3;
yspace=0.5
%first subplot
    i=2;
    file_name=info.Name(i);
    img=Proccess_Data.Create_IMG(folder,char(file_name),info);
    
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img,channel,sens);
    
    position2=[5.8,yspace,pwidth,pheight];

    %set axis
    p2=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
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
        'Position',position2);

    surf(X,Y,Z','FaceColor','interp',...
    'EdgeColor','none');
    view(2);
    shading interp;
    set(gcf,'colormap',[r g b],'Color','w')
    pbaspect([2,1,1]);
    

% Create colorbar
c2=colorbar(p2,'Color',fontcolor,'FontSize',fontsize);
c2.Label.String='B_z^{AC}(mT)';
    % Create ylabel
%ylabel('X [\mum]','Position',[-0.53,9.3,-1],'FontSize',fontsize);

% Create xlabel
%xlabel('Y [\mum]','FontSize',fontsize);
%title
text(p2,0.02,1.08,'c','FontSize',fontsize,'Units','normalized')
xlim(p2,[min(min(X)),max(max(X))]);
ylim(p2,[min(min(Y)),max(max(Y))]);
set(p2,'XTicklabel',[],'YTicklabel',[])
%second subplot
i=28;
    file_name=info.Name(i);
    img=Proccess_Data.Create_IMG(folder,char(file_name),info);
    
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img,channel,sens);
    
    

    %set axis

    position3=[5.8,yspace*1.5+pheight,pwidth,pheight];

    %set axis
    p3=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
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
        'Position',position3);

    surf(X,Y,Z','FaceColor','interp',...
    'EdgeColor','none');
    view(2);
    shading interp;
    set(gcf,'colormap',[r g b],'Color','w')
    pbaspect([2,1,1]);
    

% Create colorbar
c3=colorbar(p3,'Color',fontcolor,'FontSize',fontsize);
c3.Label.String='B_z^{AC}(mT)';
    % Create ylabel
%ylabel('Y [\mum]','FontSize',fontsize);

% Create xlabel
%xlabel('X [\mum]','FontSize',fontsize);
%title
text(p3,0.02,1.08,'b','FontSize',fontsize,'Units','normalized')
xlim(p3,[min(min(X)),max(max(X))]);
ylim(p3,[min(min(Y)),max(max(Y))]);
set(p3,'XTicklabel',[],'YTicklabel',[])
%
    
        lw=1.5;
        hold on   
        plot3([13,14],[0.7,0.7],[1,1]*max(max(Z)),'Color',fontcolor,'LineWidth',lw);
        text(13,1.2,max(max(Z)),'1\mum','Color',fontcolor,'FontSize',fontsize)
    
       
        hold on
        annotation("arrow",[0.5,0.5],[0.6,0.65],'Color',fontcolor)
        text(2,2.4,max(max(Z)),'x','FontSize',fontsize);
        annotation("arrow",[0.5,0.525],[0.6,0.6],'Color',fontcolor)
        text(3.2,1,max(max(Z)),'y','FontSize',fontsize);        
    
%plot system diagram
 position3=[0.1,1.2,5.2,5.2];

    %set axis
    p3=axes('Parent',fig,...
        'Units','inches','Position',position3);
    imshow('system_diagram.png');
    text(p3,0.1,0.9,'a','FontSize',fontsize,'Units','normalized')

%plot R(T)
