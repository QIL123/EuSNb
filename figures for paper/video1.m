folder1='/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/14/SXM/';
info1=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/14/Info_Batch_4.txt');
folder2='/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/16/SXM/';
info2=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Apr/16/Info_Batch_1.txt');
imin=find(info1.Field_Sweep==min(info1.Field_Sweep));
channel='Input_3';
sens=2e-3;
spacingx=0.5;
spacingy=0.5;
pwidth=3.5;
pheight=3.5;
load 'wyko.mat'
    fontsize=14;
    fontcolor='w';
    backcolor='g';
    blue="#9ecae1";
    red="#d95f0e";
    linewidth=1;
anotcolor='k';
%get longitudinal transport data
    folder='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_2.txt');

len=length(info.Name);
Icup1=zeros(1,len);
Icdown1=zeros(1,len);
threshold=0.001;
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
    Vup=smoothdata(Vup,'gaussian',30);
    Vdown=smoothdata(Vdown,'gaussian',30);
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
    Icup1(i)=Iup(min(indexup));
    indexdown=find(dVdown>threshold);
    Icdown1(i)=Idown(min(indexdown));  
end
Hpar=info.Field_Sweep';
%remove field offset
Hpar=(Hpar-35)/10;

%get transverve transport data
    folder='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
    info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_3.txt');

len=length(info.Name);
Icup2=zeros(1,len);
Icdown2=zeros(1,len);
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
    Vup=smoothdata(Vup,'gaussian',30);
    Vdown=smoothdata(Vdown,'gaussian',30);
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
    Icup2(i)=Iup(min(indexup));
    indexdown=find(dVdown>threshold);
    Icdown2(i)=Idown(min(indexdown));
end
Hperp=info.Field_Sweep';
Hperp=(Hperp-35)/10;
%start figure

pos1=[spacingx*4+pwidth,spacingy*2+pheight,pwidth,pheight];
pos2=[spacingx*4+pwidth,spacingy,pwidth,pheight];
pos3=[spacingx*2,spacingy*2+pheight/2,pwidth,pheight];
len=length(info1.Name);
%start video
v=VideoWriter('movie.mp4','MPEG-4');
v.FrameRate=1;
open(v);
for i=1:len
    
    
        file_name1=info1.Name(i);
        img1=Proccess_Data.Create_IMG(folder1,char(file_name1),info1);
   
        file_name2=info2.Name(i);
        img2=Proccess_Data.Create_IMG(folder2,char(file_name2),info2);
   
        %plot
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img1,channel,sens);
    %convert to mT
    Z=Z/10;

    %start figure
    fig=figure;
    set(fig,'Units','inches','Position',[0,0,10.5,8.5])

    %set axis
   
    ax1=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
        'XColor',fontcolor,...
        'LineWidth',linewidth,...
        'FontSize',fontsize,...   
        'Color',backcolor,...
        'Units','Inches',...
        'XTickLabel',[],...
        'YTicklabel',[],...
        'xtick',[],...
        'ytick',[],...
        'ytick',[],...
        'Position',pos1);
      
     surf(X,Y,Z','FaceColor','interp',...
    'EdgeColor','none');
    view(2);
    shading interp;
    set(gcf,'colormap',[r g b],'Color','w')

    Field=img1.info.Field_Sweep;
    Field=(Field/2+60)/10;

    xlim(ax1,[min(min(X)),max(max(X))]);
    ylim(ax1,[min(min(Y)),max(max(Y))]);
    caxis([-0.08,0.08]);
    set(ax1,'XTicklabel',[],'YTicklabel',[])
    %add anotations
    lw=1.5;
    hold on
    annotation("arrow",[0.555,0.555],[0.57,0.61],'Color',anotcolor)
    text(1.8,3.8,max(max(Z)),'x','FontSize',fontsize,'Color',anotcolor);
    annotation("arrow",[0.555,0.59],[0.57,0.57],'Color',anotcolor)
    text(3.8,1.8,max(max(Z)),'y','FontSize',fontsize,'Color',anotcolor);
    title('\mu_0H_{\perp}I','Color',fontcolor,'FontSize',fontsize)
    %plot second panel
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img2,channel,sens);
    %convert to mT
    Z=Z/10;
    
    %set axis
   
    ax2=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
        'XColor',fontcolor,...
        'LineWidth',linewidth,...
        'FontSize',fontsize,...   
        'Color',backcolor,...
        'Units','Inches',...
        'XTickLabel',[],...
        'YTicklabel',[],...
        'xtick',[],...
        'ytick',[],...
        'ytick',[],...
        'Position',pos2);
      
     surf(X,Y,Z','FaceColor','interp',...
    'EdgeColor','none');
    view(2);
    shading interp;
    set(gcf,'colormap',[r g b],'Color','w')

    Field=img1.info.Field_Sweep;
    Field=(Field/2+60)/10;

    xlim(ax2,[min(min(X)),max(max(X))]);
    ylim(ax2,[min(min(Y)),max(max(Y))]);
    caxis([-0.08,0.08]);
    set(ax2,'XTicklabel',[],'YTicklabel',[])
    hold on
    plot3([1,3],[1,1],[1,1]*max(max(Z)),'Color',anotcolor,'LineWidth',lw);
    text(1,2,max(max(Z)),'2\mum','Color',anotcolor,'FontSize',fontsize)
    title('\mu_0H_{||}I','Color',fontcolor,'FontSize',fontsize)
    %plot colorbar
    cbaxis=axes(fig,'visible','off');
    set(cbaxis,'colormap',[r g b],'Clim',[-0.08,0.08],'color','w')
    c=colorbar(cbaxis,'Position',[0.89,0.25,0.015,0.5],'FontSize',fontsize-2,'Color',fontcolor);
    c.Label.String='B_z^{ac} (mT)';

    %plot transport


transport1=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
        'XColor',fontcolor,...
        'LineWidth',linewidth,...
        'FontSize',fontsize,...   
        'Color',backcolor,...
        'Units','Inches',...
        'XTickLabel',[],...
        'YTicklabel',[],...
        'xtick',[],...
        'ytick',[],...
        'ytick',[],...
        'Position',pos3);


plot(Hperp,(Icup2+Icdown2)*1e3,'.','Color',blue,'MarkerSize',10);
hold on

%plot longitudinal transport data:

plot(Hpar,(Icup1+Icdown1)*1e3,'.','Color',red,'MarkerSize',10);
%annotation('arrow',[0.27,0.17],[0.94,0.94],'Color','b');
annotation('arrow',[0.24,0.24],[0.67,0.59],'Color',blue);
annotation('arrow',[0.18,0.18],[0.54,0.38],'Color',blue);
%annotation('arrow',[0.09,0.17],[0.55,0.55],'Color','b');
annotation('arrow',[0.3,0.3],[0.38,0.54],'Color',blue);
annotation('arrow',[0.37,0.37],[0.58,0.68],'Color',blue);
annotation('doublearrow',[0.27,0.21],[0.51,0.51],'Color',red);
%annotation('arrow',[0.06,0.13],[0.5,0.51],'Color','r');
text(14.4,0.15,'H\perpI','FontSize',fontsize,'Color',blue);
text(14.4,0.04,'H_{||}I','FontSize',fontsize,'Color',red)
xlabel(transport1,'\mu_0H (mT)','FontSize',fontsize);
ylabel(transport1,'\DeltaI_c (mA)','FontSize',fontsize);
%get coordinates for perp field
perpIndex=find(abs(Field-Hperp)<=0.25);
if i<=imin
    perpIndex=min(perpIndex);
else
    perpIndex=max(perpIndex);
end
xperp=Hperp(perpIndex);
yperp=(Icup2(perpIndex)+Icdown2((perpIndex)))*1e3;
%
parIndex=find(abs(Field-Hpar)<=1);
if i<=imin
    parIndex=min(parIndex);
else
    parIndex=max(parIndex);
end
xpar=Hpar(parIndex);
ypar=(Icup1(parIndex)+Icdown1((parIndex)))*1e3;
plot(xperp,yperp,'Color',blue,'LineStyle','none','Marker','diamond','MarkerSize',fontsize,'LineWidth',2);
plot(xpar,ypar,'Color',red,'LineStyle','none','Marker','diamond','MarkerSize',fontsize,'LineWidth',2);
ylim([-0.25,0.25]);
xlim([-20,20]);
set(fig,'Color',backcolor);
set(transport1,'XColor',fontcolor,'YColor',fontcolor,'Color',backcolor)
  pause(1)

    
   F=getframe(gcf);
   writeVideo(v,F)
   close all;

end
close(v)