folder='/Users/along/Documents/Alon/Msc/Research/Data/Theory/';
file='js_L_gg_lambda.txt';
red='#e34a33';
blue='#43a2ca';
purple='#756bb1';
grey='#bdbdbd';
fontsize=16;
fontcolor='k';
linewidth=2;
fig=figure;%create main figure
panelwidth=5.5;
panelheight=4;
yspacing=1;
xspacing=1;
set(fig,'Units','inches','Position',[0,0,xspacing+panelwidth+0.5,yspacing+panelheight*2+0.5],'Color','w')

jsTable=readtable(strcat(folder,file));

jsMat=cell2mat(table2cell(jsTable));
js=jsMat(:,1);
y=jsMat(:,2)*1e-4;

%parameters for transport current
It=0.4e-3; %transport current in Amps
Ic=0.5e-3; %critical current in Amps (not the de-pairing current)
L=15e-4; %width of the bridge in cm
d=8e-7; %thickness in cm
Jc=Ic*1e-6/(L*d);
a=0.5*L*sqrt(1-(It/Ic)^2);
jt=@(y) (2*Jc/pi)*atan((L^2/4-a^2)/(a^2-y^2));
%jt_neg=@(y) -(2*Jc/pi)*atan((L^2/4-a^2)./(a^2-y.^2));
jt_vec=zeros(length(y),1);
for i=1:length(y)
    if abs(y(i))>a
        jt_vec(i)=Jc;
    else
        jt_vec(i)=jt(y(i));
    end
end
plot1=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
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
        'Position',[xspacing,yspacing+panelheight,panelwidth,panelheight]);
plot(y,js,'LineWidth',linewidth,'Color',purple);
hold on
%plot positive transport
plot(y,jt_vec,'LineWidth',linewidth,'Color',blue);
%plot negative transport
plot(y,-jt_vec,'LineWidth',linewidth,'Color',red);
%plot field free region
plot([-a,-a],[-Jc,Jc],'Color',grey,'LineStyle','--','LineWidth',linewidth);
plot([a,a],[-Jc,Jc],'Color',grey,'LineStyle','--','LineWidth',linewidth);
plot([-8,8]*1e-4,[0,0],'Color','k','LineStyle','--','LineWidth',linewidth);

text(5.5e-4,0.47,'$j_t^+$','Interpreter','latex','Color',blue,'FontSize',fontsize)
text(5.5e-4,0.22,'$j_s$','Interpreter','latex','Color',purple,'FontSize',fontsize)
text(5.5e-4,-0.48,'$j_t^-$','Interpreter','latex','Color',red,'FontSize',fontsize)
text(0,-0.15,'$2a$','Interpreter','latex','Color',grey,'FontSize',fontsize)
annotation("doublearrow",[0.32,0.75],[0.7,0.7],'Color',grey,'LineWidth',linewidth)
ylim([-0.6,0.6])
set(plot1,'XTick',[-6:2:6]*1e-4,'XTicklabel',{},'YTick',[-0.4:0.2:0.4],'YTicklabel',{-0.4:0.2:0.4},'FontSize',fontsize)
xlim([-8,8]*1e-4)
text(-7.5e-4,0.5,'b','FontSize',fontsize,'Color',fontcolor);
%second plot
plot2=axes('Parent',fig,'ZColor',fontcolor,'YColor',fontcolor,...
        'XColor',fontcolor,...
        'FontSize',fontsize,...   
        'Color','none',...
        'Units','Inches',...
        'XTickLabel',[],...
        'YTicklabel',[],...
        'xtick',[],...
        'ytick',[],...
        'Box','on',...
        'ytick',[],...
        'Position',[xspacing,yspacing,panelwidth,panelheight]);

hold on
%plot positive transport
plot(y,js+jt_vec,'LineWidth',linewidth,'Color',blue);
%plot negative transport
plot(y,js-jt_vec,'LineWidth',linewidth,'Color',red);

text(5e-4,0.4,'$j_{tot}^+$','Interpreter','latex','Color',blue,'FontSize',fontsize)
%text(-7e-4,0.2,'j_s(y)','Color',purple,'FontSize',fontsize)
text(5e-4,-0.4,'$j_{tot}^-$','Interpreter','latex','Color',red,'FontSize',fontsize)
plot([-8,8]*1e-4,[0,0],'Color','k','LineStyle','--','LineWidth',linewidth)
ylim([-0.7,0.7])
set(plot2,'XTick',[-6:2:6]*1e-4,'XTicklabel',{-6:2:6},'YTick',[-0.6:0.2:0.6],'YTickLabel',{-0.6:0.2:0.6})
xlim([-8,8]*1e-4)
xlabel('y(\mum)','FontSize',fontsize,'Color',fontcolor)
ylabel('j_x(y)\times 10^6 (A/cm^2)','FontSize',fontsize,'Color',fontcolor,'Position',[-9.5*1e-4,0.71,-1])
text(-7.5e-4,0.6,'c','FontSize',fontsize,'Color',fontcolor);
%plot system diagram
%position3=[0.1,1.5,5,5];

    %set axis
    %p3=axes('Parent',fig,...
       % 'Units','inches','Position',position3);
    %text(1,1,'a','FontSize',fontsize,'Color',fontcolor,'Position',[100,22,1])
    %set(p3,'Visible','off')
    %imshow('model_diagram.png');
    