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
    backcolor='k';
    blue="#9ecae1";
    red="#d95f0e";
    linewidth=1;
anotcolor='w';
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
Hpar=(Hpar-40)/10;

%get transverve transport data
%     folder='/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Transport/';
%     info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/Jul/06/Info_Batch_3.txt');
% 
% len=length(info.Name);
% Icup2=zeros(1,len);
% Icdown2=zeros(1,len);
% threshold=0.005;
% for i=1:len
%     file_name=info.Name(i);
%     Field=info.Field_Sweep(i);
%     cindex=abs(Field-200)+1;
%     Hall_Table=readtable(strcat(folder,char(file_name)));
%     Hall_Mat=cell2mat(table2cell(Hall_Table));
%     Vb=Hall_Mat(:,1)';
%     Ib=Hall_Mat(:,2)';
%     Vx=Hall_Mat(:,3)';
%     Y=max(Vx)+min(Vx);
%     Vup=Vx(1:floor(end/2));
%     Vdown=Vx(floor(end/2)+1:end);
%     Iup=Ib(1:floor(end/2));
%     Idown=Ib(floor(end/2)+1:end);
% %smooth data
%     Vup=smoothdata(Vup,'gaussian',30);
%     Vdown=smoothdata(Vdown,'gaussian',30);
% %differentiate    
%     dVup=diff(Vup)./diff(Iup);
%     dVup=dVup-dVup(1);
%     %plot(Iup(2:end),dVup);
%     dVdown=diff(Vdown)./diff(Idown);
%     dVdown=dVdown-dVdown(1);
%     %hold on
%     %plot(Idown(2:end),dVdown);
%     %find Ic
%     indexup=find(dVup>threshold);
%     Icup2(i)=Iup(min(indexup));
%     indexdown=find(dVdown>threshold);
%     Icdown2(i)=Idown(min(indexdown));
% end
% Hperp=info.Field_Sweep';
% Hperp=(Hperp-35)/10;
%start figure

pos1=[spacingx*2,spacingy*3,pwidth,pheight];
pos2=[spacingx*3.5+pwidth,spacingy*3,pwidth,pheight];
pos3=[spacingx*4.5+pwidth*2,spacingy*3,pwidth,pheight];
%pos4=[spacingx*4.5+pwidth*2,spacingy*2+pheight,pwidth,pheight];
%pos5=[spacingx*4.5+pwidth*2,spacingy,pwidth,pheight];
len=length(info1.Name);
  %first subplot
v=VideoWriter('movie.mp4','MPEG-4');
v.FrameRate=1;
open(v);
for i=1:len
    
    
        file_name1=info1.Name(i);
        img1=Proccess_Data.Create_IMG(folder1,char(file_name1),info1);
   
        file_name2=info2.Name(i);
        img2=Proccess_Data.Create_IMG(folder2,char(file_name2),info2);
   
        %plot
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img2,channel,sens);
    %convert to mT
    Z=Z/10;

    %start figure
    fig=figure;
    set(fig,'Units','inches','Position',[0,0,13,6.5])

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
        'Position',pos3);
      
     surf(X,Y,Z','FaceColor','interp',...
    'EdgeColor','none');
    view(2);
    shading interp;
    set(gcf,'colormap',[r g b],'Color','w')

    Field=img1.info.Field_Sweep;
    Field=(Field/2+60)/10;

    xlim(ax1,[min(min(X)),max(max(X))]);
    ylim(ax1,[min(min(Y)),max(max(Y))]);
    caxis([min(min(Z)),max(max(Z))]);
    set(ax1,'XTicklabel',[],'YTicklabel',[])
    title('B_z^{ac}(x,y)','Color',fontcolor,'FontSize',fontsize)
        lw=1.5;
    hold on
    annotation("doublearrow",[0.816,0.816],[0.13,0.19],'LineWidth',3,'Head1Style','vback1','Head2Style','vback1','Color',anotcolor)
    text(5,-2,max(max(Z)),'I_x^{ac}','FontSize',fontsize,'Color',anotcolor);
    annotation("doublearrow",[0.89,0.89],[0.13,0.19],'LineWidth',3,'Head1Style','vback1','Head2Style','vback1','Color',anotcolor)
    
    %plot3([12,14],[1,1],[1,1]*max(max(Z)),'Color',anotcolor,'LineWidth',lw);
    text(8.8,-2.3,max(max(Z)),'\mu_0H_x','Color',anotcolor,'FontSize',fontsize)
    %plot AC colorbar

        cbarpos=[pos3(1)+pwidth*0.8,pos3(2)+pheight*1.02,pwidth/5,pheight/40];
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
    title(axcbar,strcat(num2str(round(max(max(Z))-min(min(Z)),2)),'mT'),'FontSize',fontsize-2,'Color',fontcolor);
    %plot DC
    [X,Y,Z]=Proccess_Data.Get_Processed_Data(img2,'DC_(Vfb)',10);
    Z=Z/10;
        ax3=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
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



    xlim(ax3,[min(min(X)),max(max(X))]);
    ylim(ax3,[min(min(Y)),max(max(Y))]);
    caxis([min(min(Z)),max(max(Z))]);
    set(ax3,'XTicklabel',[],'YTicklabel',[])
    %ylabel('\mu_0H_{\perp}I','Color',fontcolor,'FontSize',fontsize)
    title('B_z^{dc}(x,y)','FontSize',fontsize,'Color',fontcolor)
    %add anotations
    hold on
    annotation("arrow",[0.425,0.425],[0.16,0.2],'Color',anotcolor)
    text(1,-0.5,max(max(Z)),'x','FontSize',fontsize,'Color',anotcolor);
    annotation("arrow",[0.425,0.445],[0.16,0.16],'Color',anotcolor)
    text(2.8,-2,max(max(Z)),'y','FontSize',fontsize,'Color',anotcolor);
    %plot3([12,14],[1,1],[1,1]*max(max(Z)),'Color',anotcolor,'LineWidth',lw);
    text(13,-2,max(max(Z)),'2\mum','Color',anotcolor,'FontSize',fontsize)
    annotation("line",[0.61,0.638],[0.19,0.19],'Color',anotcolor,'LineWidth',lw+1)
    %title('\mu_0H_{||}I','Color',fontcolor,'FontSize',fontsize)
    %title('B_z^{dc}(x,y) (mT)','Color',fontcolor,'FontSize',fontsize)

    %plot dc colorbar

        cbarpos=[pos2(1)+pwidth*0.8,pos2(2)+pheight*1.02,pwidth/5,pheight/40];
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
    title(axcbar,strcat(num2str(round(max(max(Z))-min(min(Z)),1)),'mT'),'FontSize',fontsize-2,'Color',fontcolor);


%     %plot second panel
%     [X,Y,Z]=Proccess_Data.Get_Processed_Data(img2,channel,sens);
%     %convert to mT
%     Z=Z/10;
%     
%     %set axis
%    
%     ax2=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
%         'XColor',fontcolor,...
%         'LineWidth',linewidth,...
%         'FontSize',fontsize,...   
%         'Color',backcolor,...
%         'Units','Inches',...
%         'XTickLabel',[],...
%         'YTicklabel',[],...
%         'xtick',[],...
%         'ytick',[],...
%         'ytick',[],...
%         'Position',pos5);
%       
%      surf(X,Y,Z','FaceColor','interp',...
%     'EdgeColor','none');
%     view(2);
%     shading interp;
%     set(gcf,'colormap',[r g b],'Color','w')
% 
%     Field=img1.info.Field_Sweep;
%     Field=(Field/2+60)/10;
% 
%     xlim(ax2,[min(min(X)),max(max(X))]);
%     ylim(ax2,[min(min(Y)),max(max(Y))]);
%     caxis([-0.08,0.08]);
%     set(ax2,'XTicklabel',[],'YTicklabel',[])
%     hold on
%     plot3([1,3],[1,1],[1,1]*max(max(Z)),'Color',anotcolor,'LineWidth',lw);
%     text(1,2,max(max(Z)),'2\mum','Color',anotcolor,'FontSize',fontsize)
%     %title('\mu_0H_{||}I','Color',fontcolor,'FontSize',fontsize)
%     %plot colorbar
%     cbaxis=axes(fig,'visible','off');
%     set(cbaxis,'colormap',[r g b],'Clim',[-0.08,0.08],'color','w')
%     c=colorbar(cbaxis,'Position',[0.93,0.25,0.015,0.5],'FontSize',fontsize-2,'Color',fontcolor);
%     %c.Label.String='B_z^{ac} (mT)';
%     %plot DC
%         [X,Y,Z]=Proccess_Data.Get_Processed_Data(img2,'DC_(Vfb)',10);
%         Z=Z/10;
%             ax4=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
%         'XColor',fontcolor,...
%         'LineWidth',linewidth,...
%         'FontSize',fontsize,...   
%         'Color',backcolor,...
%         'Units','Inches',...
%         'XTickLabel',[],...
%         'YTicklabel',[],...
%         'xtick',[],...
%         'ytick',[],...
%         'ytick',[],...
%         'Position',pos3);
%       
%      surf(X,Y,Z','FaceColor','interp',...
%     'EdgeColor','none');
%     view(2);
%     shading interp;
%     set(gcf,'colormap',[r g b],'Color','w')
% 
% 
% 
%     xlim(ax4,[min(min(X)),max(max(X))]);
%     ylim(ax4,[min(min(Y)),max(max(Y))]);
%     caxis([min(min(Z)),max(max(Z))]);
%     set(ax4,'XTicklabel',[],'YTicklabel',[])
%     ylabel('\mu_0H_{||}I','FontSize',fontsize,'Color',fontcolor)
%           
%     %plot dc colorbar
%         cbarpos=[pos3(1)+pwidth*0.8,pos3(2)+pheight*1.02,pwidth/5,pheight/40];
%         axcbar=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
%         'XColor',fontcolor,...
%         'LineWidth',linewidth,...
%         'FontSize',fontsize,...   
%         'Color','none',...
%         'Units','Inches',...
%         'XTickLabel',[],...
%         'YTicklabel',[],...
%         'xtick',[],...
%         'ytick',[],...
%         'ytick',[],...
%         'Position',cbarpos);
% 
%         %plot plane with colorscale to match image
%         cbarA=linspace(min(min(Z)),max(max(Z)),100);
%         cbarB=ones(10,1);
%         x=1:100;
%         y=1:10;
%         cbar=cbarB*cbarA;
%      surf(x,y,cbar,'FaceColor','interp',...
%     'EdgeColor','none','Parent',axcbar);
% 
%     view(2);
%     shading interp;
%     set(gcf,'colormap',[r g b],'Color','w')
%     caxis([min(min(Z)),max(max(Z))]);
%     xlim([1,100]);
%     ylim([1,10]);
%     set(axcbar,'XTick',[],'XTicklabel',{},'YTick',[],'YTicklabel',{})
%     title(axcbar,strcat(num2str(round(max(max(Z))-min(min(Z)),1)),'mT'),'FontSize',fontsize-2,'Color',fontcolor);
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
        'Position',pos1);


%plot(Hperp,(Icup2+Icdown2)*1e3,'LineWidth',linewidth,'Marker','.','Color',blue,'MarkerSize',10);
hold on

%plot longitudinal transport data:

plot(Hpar,(Icup1+Icdown1)*1e3,'.','Color',red,'MarkerSize',10);
%annotation('arrow',[0.27,0.17],[0.94,0.94],'Color','b');
%annotation('arrow',[0.18,0.18],[0.67,0.59],'Color',blue);
%annotation('arrow',[0.13,0.13],[0.54,0.38],'Color',blue);
%annotation('arrow',[0.09,0.17],[0.55,0.55],'Color','b');
%annotation('arrow',[0.225,0.225],[0.38,0.54],'Color',blue);
%annotation('arrow',[0.28,0.28],[0.58,0.68],'Color',blue);
%annotation('doublearrow',[0.21,0.15],[0.51,0.51],'Color',red);
%annotation('arrow',[0.06,0.13],[0.5,0.51],'Color','r');
%text(14.4,0.15,'H\perpI','FontSize',fontsize,'Color',blue);
%text(14.4,0.04,'H_{||}I','FontSize',fontsize,'Color',red)
xlabel(transport1,'\mu_0H_x (mT)','FontSize',fontsize);
ylabel(transport1,'\DeltaI_c (mA)','FontSize',fontsize);
%get coordinates for perp field
% perpIndex=find(abs(Field-Hperp)<=0.25);
% if i<=imin
%     perpIndex=min(perpIndex);
% else
%     perpIndex=max(perpIndex);
% end
% xperp=Hperp(perpIndex);
% yperp=(Icup2(perpIndex)+Icdown2((perpIndex)))*1e3;
% get coordinates for par field
parIndex=find(abs(Field-Hpar)<=1);
if i<=imin
    parIndex=min(parIndex);
else
    parIndex=max(parIndex);
end
xpar=Hpar(parIndex);
ypar=(Icup1(parIndex)+Icdown1((parIndex)))*1e3;
%plot(xperp,yperp,'Color','w','LineStyle','none','Marker','diamond','MarkerSize',fontsize+2,'LineWidth',4);
plot(xpar,ypar,'Color','w','LineStyle','none','Marker','diamond','MarkerSize',fontsize+2,'LineWidth',4);
ylim([-0.25,0.25]);
xlim([-20,20]);

set(fig,'Color',backcolor);
set(transport1,'XTick',[-20:10:20],'XTickLabel',{-20:10:20},'YTick',[-0.2:0.1:0.2],'YTickLabel',{-0.2:0.1:0.2},'XColor',fontcolor,'YColor',fontcolor,'Color',backcolor,'FontSize',fontsize,'Box','on')
  pause(1)

    
   F=getframe(gcf);
   writeVideo(v,F)
   close all;

end
close(v)