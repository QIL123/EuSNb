
%% Transport IV(H)

[Volt,Curr]=Keithley.Sweep_I_Meas_V_4P(4,0, 4.5e-4, 4.5e-6, 1e-3)

hold on
plot(Curr,Volt)

%%
V_Bias=1
X=linspace(0,V_Bias,201)   % on 1K ohm

    [voltages_Up] = DAC.Ramp(1, 1, 0, V_Bias, 201, 1,avg);%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)
    pause(0.01)
    [voltages_Down] = DAC.Ramp(1, 1, V_Bias, 0, 201, 1,avg);%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)
    
    figure
plot(X,voltages_Up)
hold on
plot(X,voltages_Down)

    
%%
    
Field_Sweep=[linspace(0,1300,131),linspace(1300,0,131)]

V_Bias=1
X=linspace(0,V_Bias,201)   % on 1K ohm

avg=200







Sweep_Up_Filename=General.Add_Time2File('IV_H_Dev5_Up_NT');
Sweep_Down_Filename=General.Add_Time2File('IV_H_Dev5_Down_NT');
General.File_Make(Sweep_Up_Filename,{});
General.File_Make(Sweep_Down_Filename,{});
%%

% Going to -1 T and back to zero
Magnet.Set(1,-10000,0)
Magnet.Set(1,0,0)




% Mesure Iv 0,1300,0 G
for i=1:length(Field_Sweep)
    Magnet.Set(1,Field_Sweep(i),0)

    [voltages_Up] = DAC.Ramp(1, 1, 0, V_Bias, 201, 1,avg);%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)
    pause(0.01)
    [voltages_Down] = DAC.Ramp(1, 1, V_Bias, 0, 201, 1,avg);%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)

    General.Save(Sweep_Up_Filename,{voltages_Up});
    General.Save(Sweep_Down_Filename,{voltages_Down});
   
end

%%
% Going to 1 T and back to zero

Magnet.Set(1,10000,0)
Magnet.Set(1,0,0)


Sweep_Up_Filename=General.Add_Time2File('IV_H_Dev5_Up_PT');
Sweep_Down_Filename=General.Add_Time2File('IV_H_Dev5_Down_PT');
General.File_Make(Sweep_Up_Filename,{});
General.File_Make(Sweep_Down_Filename,{});

% Mesure Iv 0,1300,0 G
for i=1:length(Field_Sweep)
    
    Magnet.Set(1,Field_Sweep(i),0)

    [voltages_Up] = DAC.Ramp(1, 1, 0, V_Bias, 201, 1,avg);%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)
    pause(0.01)
    [voltages_Down] = DAC.Ramp(1, 1, V_Bias, 0, 201, 1,avg);%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)

    General.Save(Sweep_Up_Filename,{voltages_Up});
    General.Save(Sweep_Down_Filename,{voltages_Down});
   
end
%% 210719

% Semi SP
F_Names=[-10000 0 200 300 400 600 800 1000 -1300]
F_Fields=[0 0 200 300 400 600 800 1000 0]
for i=1:length(F_Fields)
    
    if i>1&i<length(F_Names)
        Magnet.Set(1,1300,0)  % Poloraized to 1300 G
    elseif i==length(F_Names)
        Magnet.Set(1,-1300,0)  % Poloraized to 1300 G
    end
    Magnet.Set(1,F_Fields(i),0)  % Go back to...

    Sweep_Up_Filename=General.Add_Time2File(['IV_H_Dev5_Up_PT_',num2str(F_Names(i)),'G']);
    Sweep_Down_Filename=General.Add_Time2File(['IV_H_Dev5_Down_PT_',num2str(F_Names(i)),'G']);
    General.File_Make(Sweep_Up_Filename,{});
    General.File_Make(Sweep_Down_Filename,{});
    
    Num_Field=(1300-F_Fields(i))/20+1;
    Field_Sweep=[linspace(F_Fields(i),1300,Num_Field),linspace(1300,F_Fields(i),Num_Field)];
    % Mesure Iv 0,1300,0 G
    for j=1:length(Field_Sweep)

        Magnet.Set(1,Field_Sweep(j),0)

        [voltages_Up] = DAC.Ramp(1, 1, 0, V_Bias, 201, 1,avg);%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)
        pause(0.01)
        [voltages_Down] = DAC.Ramp(1, 1, V_Bias, 0, 201, 1,avg);%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)

        General.Save(Sweep_Up_Filename,{voltages_Up});
        General.Save(Sweep_Down_Filename,{voltages_Down});

    end
end

%% 210701
% SP dev 6 
Field_Sweep=[linspace(0,1300,131),linspace(1300,0,131)]

V_Bias=0.7;
X=linspace(0,V_Bias,201)   % on 1K ohm

avg=200







Sweep_Up_Filename=General.Add_Time2File('IV_H_Dev6_Up_NT');
Sweep_Down_Filename=General.Add_Time2File('IV_H_Dev6_Down_NT');
General.File_Make(Sweep_Up_Filename,{});
General.File_Make(Sweep_Down_Filename,{});

%%
% Going to -1 T and back to zero
Magnet.Set(1,-10000,0)
Magnet.Set(1,0,0)

% Mesure Iv 0,1300,0 G
for i=1:length(Field_Sweep)
    Magnet.Set(1,Field_Sweep(i),0)

    [voltages_Up] = DAC.Ramp(1, 1, 0, V_Bias, 201, 1,avg)%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)
    pause(0.01)
    [voltages_Down] = DAC.Ramp(1, 1, V_Bias, 0, 201, 1,avg)%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)

    General.Save(Sweep_Up_Filename,{voltages_Up});
    General.Save(Sweep_Down_Filename,{voltages_Down});
   
end


% Going to 1 T and back to zero

Magnet.Set(1,10000,0)
Magnet.Set(1,0,0)


Sweep_Up_Filename=General.Add_Time2File('IV_H_Dev6_Up_PT');
Sweep_Down_Filename=General.Add_Time2File('IV_H_Dev6_Down_PT');
General.File_Make(Sweep_Up_Filename,{});
General.File_Make(Sweep_Down_Filename,{});

% Mesure Iv 0,1300,0 G
for i=1:length(Field_Sweep)
    
    Magnet.Set(1,Field_Sweep(i),0)

    [voltages_Up] = DAC.Ramp(1, 1, 0, V_Bias, 201, 1,avg)%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)
    pause(0.01)
    [voltages_Down] = DAC.Ramp(1, 1, V_Bias, 0, 201, 1,avg)%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)

    General.Save(Sweep_Up_Filename,{voltages_Up});
    General.Save(Sweep_Down_Filename,{voltages_Down});
   
end


%% 210704
% SP dev 6 
% On 1 KOhm
Field_Sweep=[linspace(0,1300,131),linspace(1300,0,131)]

V_Bias=0.7;
X=linspace(0,V_Bias,201);   % on 1K ohm

avg=200







Sweep_Up_Filename=General.Add_Time2File('IV_H_Dev6_Up_PT');
Sweep_Down_Filename=General.Add_Time2File('IV_H_Dev6_Down_PT');
General.File_Make(Sweep_Up_Filename,{});
General.File_Make(Sweep_Down_Filename,{});

%%
% After 1 T and back to zero

% Measure the way up and down

% Mesure Iv 0,1300,0 G
for i=1:length(Field_Sweep)
    Magnet.Set(1,Field_Sweep(i),0)

    [voltages_Up] = DAC.Ramp(1, 1, 0, V_Bias, 201, 1,avg);%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)
    pause(0.01)
    [voltages_Down] = DAC.Ramp(1, 1, V_Bias, 0, 201, 1,avg);%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)

    General.Save(Sweep_Up_Filename,{voltages_Up});
    General.Save(Sweep_Down_Filename,{voltages_Down});
   
end

%%
% Going to 1 T and back to zero

Magnet.Set(1,10000,0)
Magnet.Set(1,0,0)


Sweep_Up_Filename=General.Add_Time2File('IV_H_Dev6_Up_PT');
Sweep_Down_Filename=General.Add_Time2File('IV_H_Dev6_Down_PT');
General.File_Make(Sweep_Up_Filename,{});
General.File_Make(Sweep_Down_Filename,{});

% Mesure Iv 0,1300,0 G
for i=1:length(Field_Sweep)
    
    Magnet.Set(1,Field_Sweep(i),0)

    [voltages_Up] = DAC.Ramp(1, 1, 0, V_Bias, 201, 1,avg)%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)
    pause(0.01)
    [voltages_Down] = DAC.Ramp(1, 1, V_Bias, 0, 201, 1,avg)%(DAC_ch, ADC_ch, iV, fV, n, delay,avgR)

    General.Save(Sweep_Up_Filename,{voltages_Up});
    General.Save(Sweep_Down_Filename,{voltages_Down});
   
end
