 
File_Name='C:\Users\Owner\Google Drive\4K microscope\data\2021\Jun\20\Tc_Dev6.txt'
File_Name='C:\Users\Owner\Google Drive\4K microscope\data\2021\Jun\24\IV.txt'

IV_Table=readtable(File_Name);

IV_Data=IV_Table;

%% Tc meas



% 
% % Rxx
% 
Num=unique(IV_Data.Batch_Num)

figure()
hold on

Leg={};
for i=1:length(Num)
    
    [F]=find(IV_Data.Batch_Num==Num(i))
    try
        Vsc=mean(IV_Data{F,5:9}');
        
        plot(IV_Data.Mag(F),Vsc,'-','LineWidth',0.5)
        Leg{i}=['I= ',num2str(round(IV_Data.Ibias(F(1)),5)),' [uA]'];
    end
end
grid on
legend(Leg)
%%

round(IV_Data.Ibias(F(1)),5)
%%
title('IV curves')
grid on
legend(Leg)

%%


plot(IV_Table(F,:).Mag,IV_Table(F,:).Vsc.*-1./(IV_Table(F,:).Ibias))
plot(IV_Table(F,:).Mag,IV_Table(F,:).Vfb)

for i=3
    
    F=1+480*i+120*3:1+480*(i+1)-120*0%:960
    
%     F=1+480*i+120:1+480*(i+1)-120*2%:960

    plot(IV_Table(F,:).Mag,IV_Table(F,:).Vsc.*-1./(Ic))
end
for i=1:13
    
    F=1+480*i+120*0:1+480*(i+1)-120*0%:960
    
%     F=1+480*i+120:1+480*(i+1)-120*2%:960

    plot(IV_Table(F,:).Mag,IV_Table(F,:).Vsc.*-1./(Ic))
end



%%
figure
hold on
i=3
    
F=1+480*i:480*(i)+122%:960

plot(IV_Table(F,:).Mag,IV_Table(F,:).Vsc.*-1./(IV_Table(F(1),1).Ibias))

F=480*(i)+120:480*(i)+120+240%:960
plot(IV_Table(F,:).Mag,IV_Table(F,:).Vsc.*-1./(IV_Table(F(1),1).Ibias))

%%
 
File_Name='C:\Users\Owner\Google Drive\4K microscope\data\2021\Jun\13\IV_Dev3.txt'

IV_Table=readtable(File_Name);

IV=IV_Table(1:481,:);
figure
hold on
for i=0:3
F=1+120*i:480-120*(3-i);

plot(IV(F,:).Mag,IV(F,:).Vsc.*-1./(IV(F(1),1).Ibias))
end
title('I=590 \muA')
xlabel('H [G]')
ylabel('Rxx [\Omega]')

IV=IV_Table(482:961,:);
hold on
for i=0:3
F=1+120*i:480-120*(3-i);

plot(IV(F,:).Mag,IV(F,:).Vsc.*-1./(IV(F(1),1).Ibias))
end
title('I=590 \muA')
xlabel('H [G]')
ylabel('Rxx [\Omega]')

IV=IV_Table(962:962+480,:);
hold on
for i=0:3
F=1+120*i:480-120*(3-i);

plot(IV(F,:).Mag,IV(F,:).Vsc.*-1./(IV(F(1),1).Ibias))
end
title('I=590 \muA')
xlabel('H [G]')
ylabel('Rxx [\Omega]')



%%
IV_Table=readtable(File_Name);

IV=IV_Table(1683:end,:);
figure
F=1:length(IV.Mag);

plot(IV(F,:).Mag,IV(F,:).Vsc.*1./(IV(F(1),1).Ibias))

title('I=600 \muA')
xlabel('H [G]')
ylabel('Rxx [\Omega]')


%% Load IP

 
File_Name='C:\Users\Owner\Google Drive\4K microscope\data\2021\Jun\15\IP_Tip_210511_SJ.txt'

IP_Table=readtable(File_Name);
figure
plot(IP_Table.Mag,IP_Table.Vfb)



%%


Folde_SXM='C:\Users\Owner\Google Drive\4K microscope\data\2021\Jun\05\SXM'

Dir=dir(Folde_SXM)
Info=readtable('C:\Users\Owner\Google Drive\4K microscope\data\2021\Jun\05\Info_Batch_29.txt');

% Load SXM files
% 49

K=3;

SXM_Loc1=fullfile(Folde_SXM,Dir(end-4).name)
SXM_Loc2=fullfile(Folde_SXM,Dir(end-2).name)

SXM1=sxm.load.loadProcessedSxM(SXM_Loc1)
SXM2=sxm.load.loadProcessedSxM(SXM_Loc2)

M1=SXM1.channels(1).rawData;
M1=flipud(M1);

M2=SXM2.channels(1).rawData;
M2=flipud(M2)

[M_Diff,~]=Image_Diff.ABdiff2(M1,M2);
Diff_Cell={M1,M2,M_Diff};


newfig={Analyze_Plot.Plot_Image_Diff(Diff_Cell,Info,SXM_Loc1)};




