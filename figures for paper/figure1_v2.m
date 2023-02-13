%figure 1
folder='/Users/along/Documents/Alon/Msc/Research/Data/2021/Oct/26/SXM/';
info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2021/Oct/26/Info_Batch_2.txt');
channel='TF_X';
sens=10e-3;
    fontsize=12;
    fontcolor='k';
linewidth=1;
load 'wyko.mat'

fig=figure;
set(fig,'Units','inches','Position',[0,0,15,7.5])
%first subplot
    i=2;
    file_name=info.Name(i);
    img=Proccess_Data.Create_IMG(folder,char(file_name),info);
    
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img,channel,sens);
    
    position2=[7,0.5,6,3];

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
c2.Label.String='B_z^{AC}(x,y)';
    % Create ylabel
ylabel('X [\mum]','Position',[-0.53,9.3,-1],'FontSize',fontsize);

% Create xlabel
xlabel('Y [\mum]','FontSize',fontsize);
%title
text(0.05,1.05,'c','FontSize',fontsize,'Units','normalized')
xlim(p2,[min(min(X)),max(max(X))]);
ylim(p2,[min(min(Y)),max(max(Y))]);
set(p2,'XTicklabel',[],'YTicklabel',[])
%second subplot
i=28;
    file_name=info.Name(i);
    img=Proccess_Data.Create_IMG(folder,char(file_name),info);
    
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img,channel,sens);
    
    

    %set axis

    position3=[7,4,6,3];

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
c3.Label.String='B_z^{AC}(x,y)';
    % Create ylabel
%ylabel('Y [\mum]','FontSize',fontsize);

% Create xlabel
%xlabel('X [\mum]','FontSize',fontsize);
%title
text(0.05,1.05,'b','FontSize',fontsize,'Units','normalized')
xlim(p3,[min(min(X)),max(max(X))]);
ylim(p3,[min(min(Y)),max(max(Y))]);
set(p3,'XTicklabel',[],'YTicklabel',[])
%
%third subplot
i=2;
    channel='DC_(Vfb)';
    sens=10;
    file_name=info.Name(i);
    img=Proccess_Data.Create_IMG(folder,char(file_name),info);
    
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img,channel,sens);
    
    position2=[0.3,0.5,6,3];

    %set axis
    p4=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
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
c2=colorbar(p4,'Color',fontcolor,'FontSize',fontsize);
c2.Label.String='B_z^{DC}(x,y)';
    % Create ylabel
ylabel('X [\mum]','FontSize',fontsize);

% Create xlabel
xlabel('Y [\mum]','FontSize',fontsize);
%title
text(0.05,1.05,'d','FontSize',fontsize,'Units','normalized')
xlim(p4,[min(min(X)),max(max(X))]);
ylim(p4,[min(min(Y)),max(max(Y))]);
set(p4,'XTicklabel',[],'YTicklabel',[])
%plot system diagram
 position3=[1,3.2,4.5,4.5];

    %set axis
    p1=axes('Parent',fig,...
        'Units','inches','Position',position3);
    imshow('system_diagram.png');
    text(0.02,0.9,'a','FontSize',fontsize,'Units','normalized')
 
