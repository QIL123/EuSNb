
addpath('C:\Users\Owner\Google Drive\Scripts\4K project\CGT');

General.Connect()

General.SetMail();
emailto='avia.noah@mail.huji.ac.il';

%%
% Code for scan
%%
% Set field to zero
Batch_Num=1;
Mag_Inst=1;
Vbias=-0.3;
Response=1;

Nanonis_Def={'CST',4.9176, -1.3368,4, 4,128, 128, 1.28, -25};
%Nanonis_Def{Filke_Name,Xcenter[um],Ycenter[um],Width[um],Hight[um],Pixels,Lines,SpeedPerLine,Angle}

Folder_SXM=General.Add_Time2File('SXM');
Folder_SXM=Folder_SXM(1:end-4);

Info_Title={'Name','Batch_Num','Z_Encoder','Z_Scan', 'Field_Sweep', 'Field_Measured','Vbias','Vfb', 'Response', 'Time','Pixels','Lines','Xrange','Yrange','Xcenter','Ycenter','Angle'};
Info_Name=General.Add_Time2File(['Info_Batch_',num2str(Batch_Num)]);
General.File_Make(Info_Name,Info_Title);

Field_Sweep=[linspace(0,2000,41),linspace(1000,-2000,61),linspace(-1000,0,21)]

%%

for i=1:length(Field_Sweep)
    
    if ~mod(i,2)
        % Retract 1 nm in the end of the scan
        try
            Zs=Nanonis.Get_Scanner_Z();
            while or(Zs>12,Zs<1)
                Zs=Nanonis.Get_Scanner_Z();
            end
            Nanonis.Set_Scanner_Z(Zs-0.001)
        catch err
           disp(err.message) 
        end
    end
    Magnet.Set(Mag_Inst,Field_Sweep(i),1)  % Set field
    pause(5)

    DAC.Blink(2)
    pause(2)
    
    % Blink if needed
    try
        Vfb=Nanonis.Get(1);
        if abs(Vfb)>9.85
            DAC.Blink(2)
        end
    catch err
        disp(err.message)
    end
    
    % Scan
    [Time_Of_Scan,Scan_Name]=Nanonis.Scan(Nanonis_Def);
    Scan_Name=[Scan_Name,'002.sxm'];

    % Check if Vfb jump if so blink
    try
        while Nanonis.If_Scan()   
            try
                Vfb=Nanonis.Get(1); 
                if abs(Vfb)>9.85
                    DAC.Blink(2)
                end
                pause(0.5)
            catch err
                disp(err.message)
            end
        end

    catch err
        while Nanonis.If_Scan()   
            try
                Vfb=Nanonis.Get(1); 
                if abs(Vfb)>9.85
                    DAC.Blink(2)
                end
                pause(0.5)
            catch err
                disp(err.message)
            end
        end
    end

    pause(5)
    try 
        CGT_Measure.Save(Info_Name,Scan_Name,Batch_Num,Field_Sweep(i),Vbias,Response,Nanonis_Def);  % Save the data
        [Name_Of_Fig]=CGT_Measure.Save_Raw_Data(Info_Name,Folder_SXM);  % Plot the fig
        sendmail( emailto , 'Image' ,'You got a new fig',Name_Of_Fig); % Send fig to Tal
     catch err
        disp(err.message)
    end
    disp(['percentage of run is:',num2str(round(100*i./length(Field_Sweep))),' %'])
end

% Retract 300 nm in the end of the scan
Zs=Nanonis.Get_Scanner_Z()
Nanonis.Set_Scanner_Z(Zs-0.3)

%% June 27

%%
% Set field to zero
Batch_Num=2;
Mag_Inst=1;
Vbias=-0.3;
Response=1;

Nanonis_Def={'CST',3.9238,-4.9537,4, 4,128, 128, 1.28, -80};
%Nanonis_Def{Filke_Name,Xcenter[um],Ycenter[um],Width[um],Hight[um],Pixels,Lines,SpeedPerLine,Angle}

Folder_SXM=General.Add_Time2File('SXM');
Folder_SXM=Folder_SXM(1:end-4);

Info_Title={'Name','Batch_Num','Z_Encoder','Z_Scan', 'Field_Sweep', 'Field_Measured','Vbias','Vfb', 'Response', 'Time','Pixels','Lines','Xrange','Yrange','Xcenter','Ycenter','Angle'};
Info_Name=General.Add_Time2File(['Info_Batch_',num2str(Batch_Num)]);
General.File_Make(Info_Name,Info_Title);

Field_Sweep=[linspace(0,1650,56),linspace(1020,0,35)]

%%

for i=1:length(Field_Sweep)
    
    if ~mod(i,2)
        % Retract 1 nm in the end of the scan
        try
            Zs=Nanonis.Get_Scanner_Z();
            while or(Zs>12,Zs<1)
                Zs=Nanonis.Get_Scanner_Z();
            end
            Nanonis.Set_Scanner_Z(Zs-0.001)
        catch err
           disp(err.message) 
        end
    end
    Magnet.Set(Mag_Inst,Field_Sweep(i),1)  % Set field
    pause(5)

    DAC.Blink(2)
    pause(2)
    
    % Blink if needed
    try
        Vfb=Nanonis.Get(1);
        if abs(Vfb)>9.85
            DAC.Blink(2)
        end
    catch err
        disp(err.message)
    end
    
    % Scan
    [Time_Of_Scan,Scan_Name]=Nanonis.Scan(Nanonis_Def);
    Scan_Name=[Scan_Name,'002.sxm'];

    % Check if Vfb jump if so blink
    try
        while Nanonis.If_Scan()   
            try
                Vfb=Nanonis.Get(1); 
                if abs(Vfb)>9.85
                    DAC.Blink(2)
                end
                pause(0.5)
            catch err
                disp(err.message)
            end
        end

    catch err
        while Nanonis.If_Scan()   
            try
                Vfb=Nanonis.Get(1); 
                if abs(Vfb)>9.85
                    DAC.Blink(2)
                end
                pause(0.5)
            catch err
                disp(err.message)
            end
        end
    end

    pause(5)
    try 
        CGT_Measure.Save(Info_Name,Scan_Name,Batch_Num,Field_Sweep(i),Vbias,Response,Nanonis_Def);  % Save the data
        [Name_Of_Fig]=CGT_Measure.Save_Raw_Data(Info_Name,Folder_SXM);  % Plot the fig
        sendmail( emailto , 'Image' ,'You got a new fig',Name_Of_Fig); % Send fig to Tal
     catch err
        disp(err.message)
    end
    disp(['percentage of run is:',num2str(round(100*i./length(Field_Sweep))),' %'])
end

% Retract 300 nm in the end of the scan
Zs=Nanonis.Get_Scanner_Z()
Nanonis.Set_Scanner_Z(Zs-0.3)

%% June 28

%%
% Set field to zero
Batch_Num=3;
Mag_Inst=1;
Vbias=-0.3;
Response=1;

Nanonis_Def={'CST', -11.433, 9.2203, 4, 4,128, 128, 1.3, 150};
%Nanonis_Def{Filke_Name,Xcenter[um],Ycenter[um],Width[um],Hight[um],Pixels,Lines,SpeedPerLine,Angle}

Folder_SXM=General.Add_Time2File('SXM');
Folder_SXM=Folder_SXM(1:end-4);

Info_Title={'Name','Batch_Num','Z_Encoder','Z_Scan', 'Field_Sweep', 'Field_Measured','Vbias','Vfb', 'Response', 'Time','Pixels','Lines','Xrange','Yrange','Xcenter','Ycenter','Angle'};
Info_Name=General.Add_Time2File(['Info_Batch_',num2str(Batch_Num)]);
General.File_Make(Info_Name,Info_Title);

Field_Sweep=[linspace(0,510,18),linspace(570,990,8),linspace(1600,1600,1),linspace(990,570,8),linspace(510,-510,35),linspace(-570,-990,8),linspace(-1600,-1600,1),linspace(-990,-570,8),linspace(-510,0,18)]

%%

for i=1:length(Field_Sweep)
    
    if ~mod(i,4)
        % Retract 1 nm in the end of the scan
        try
            Zs=Nanonis.Get_Scanner_Z();
            while or(Zs>12,Zs<1)
                Zs=Nanonis.Get_Scanner_Z();
            end
            Nanonis.Set_Scanner_Z(Zs-0.001)
        catch err
           disp(err.message) 
        end
    end
    Magnet.Set(Mag_Inst,Field_Sweep(i),1)  % Set field
    pause(5)

    DAC.Blink(2)
    pause(2)
    
    % Blink if needed
    try
        Vfb=Nanonis.Get(1);
        if abs(Vfb)>9.85
            DAC.Blink(2)
        end
    catch err
        disp(err.message)
    end
    
    % Scan
    [Time_Of_Scan,Scan_Name]=Nanonis.Scan(Nanonis_Def);
    Scan_Name=[Scan_Name,'002.sxm'];

    % Check if Vfb jump if so blink
    try
        while Nanonis.If_Scan()   
            try
                Vfb=Nanonis.Get(1); 
                if abs(Vfb)>9.85
                    DAC.Blink(2)
                end
                pause(0.5)
            catch err
                disp(err.message)
            end
        end

    catch err
        while Nanonis.If_Scan()   
            try
                Vfb=Nanonis.Get(1); 
                if abs(Vfb)>9.85
                    DAC.Blink(2)
                end
                pause(0.5)
            catch err
                disp(err.message)
            end
        end
    end

    pause(5)
    try 
        CGT_Measure.Save(Info_Name,Scan_Name,Batch_Num,Field_Sweep(i),Vbias,Response,Nanonis_Def);  % Save the data
        [Name_Of_Fig]=CGT_Measure.Save_Raw_Data(Info_Name,Folder_SXM);  % Plot the fig
        sendmail( emailto , 'Image' ,'You got a new fig',Name_Of_Fig); % Send fig to Tal
     catch err
        disp(err.message)
    end
    disp(['percentage of run is:',num2str(round(100*i./length(Field_Sweep))),' %'])
end

% Retract 300 nm in the end of the scan
Zs=Nanonis.Get_Scanner_Z()
Nanonis.Set_Scanner_Z(Zs-0.3)

%% June 29

%%
% Set field to zero
Batch_Num=4;
Mag_Inst=1;
Vbias=-0.3;
Response=1;

Nanonis_Def={'CST', -8.8216, 2.4959, 4, 4,128, 128, 1.3, 150};
%Nanonis_Def{Filke_Name,Xcenter[um],Ycenter[um],Width[um],Hight[um],Pixels,Lines,SpeedPerLine,Angle}

Folder_SXM=General.Add_Time2File('SXM');
Folder_SXM=Folder_SXM(1:end-4);

Info_Title={'Name','Batch_Num','Z_Encoder','Z_Scan', 'Field_Sweep', 'Field_Measured','Vbias','Vfb', 'Response', 'Time','Pixels','Lines','Xrange','Yrange','Xcenter','Ycenter','Angle'};
Info_Name=General.Add_Time2File(['Info_Batch_',num2str(Batch_Num)]);
General.File_Make(Info_Name,Info_Title);

Field_Sweep=[linspace(0,35,36),linspace(100,1600,31),linspace(1000,1000,1),linspace(700,0,15),linspace(-1,-35,35),linspace(-100,-1600,31),linspace(-1000,-1000,1),linspace(-700,0,15)]

%%

for i=1:length(Field_Sweep)
    
    if ~mod(i,4)
        % Retract 1 nm in the end of the scan
        try
            Zs=Nanonis.Get_Scanner_Z();
            while or(Zs>12,Zs<1)
                Zs=Nanonis.Get_Scanner_Z();
            end
            Nanonis.Set_Scanner_Z(Zs-0.001)
        catch err
           disp(err.message) 
        end
    end
    Magnet.Set(Mag_Inst,Field_Sweep(i),1)  % Set field
    pause(5)

    DAC.Blink(2)
    pause(2)
    
    % Blink if needed
    try
        Vfb=Nanonis.Get(1);
        if abs(Vfb)>9.85
            DAC.Blink(2)
        end
    catch err
        disp(err.message)
    end
    
    % Scan
    [Time_Of_Scan,Scan_Name]=Nanonis.Scan(Nanonis_Def);
    Scan_Name=[Scan_Name,'002.sxm'];

    % Check if Vfb jump if so blink
    try
        while Nanonis.If_Scan()   
            try
                Vfb=Nanonis.Get(1); 
                if abs(Vfb)>9.85
                    DAC.Blink(2)
                end
                pause(0.5)
            catch err
                disp(err.message)
            end
        end

    catch err
        while Nanonis.If_Scan()   
            try
                Vfb=Nanonis.Get(1); 
                if abs(Vfb)>9.85
                    DAC.Blink(2)
                end
                pause(0.5)
            catch err
                disp(err.message)
            end
        end
    end

    pause(5)
    try 
        CGT_Measure.Save(Info_Name,Scan_Name,Batch_Num,Field_Sweep(i),Vbias,Response,Nanonis_Def);  % Save the data
        [Name_Of_Fig]=CGT_Measure.Save_Raw_Data(Info_Name,Folder_SXM);  % Plot the fig
        sendmail( emailto , 'Image' ,'You got a new fig',Name_Of_Fig); % Send fig to Tal
     catch err
        disp(err.message)
    end
    disp(['percentage of run is:',num2str(round(100*i./length(Field_Sweep))),' %'])
end

% Retract 300 nm in the end of the scan
Zs=Nanonis.Get_Scanner_Z()
Nanonis.Set_Scanner_Z(Zs-0.3)
%%

%% 210730
% Set field to zero
Batch_Num=5;
Mag_Inst=1;
Vbias=-0.3;
Response=1;

Nanonis_Def={'CST', -5.9917, -0.85994, 4, 4,128, 128, 1.3, 125};
%Nanonis_Def{Filke_Name,Xcenter[um],Ycenter[um],Width[um],Hight[um],Pixels,Lines,SpeedPerLine,Angle}

Folder_SXM=General.Add_Time2File('SXM');
Folder_SXM=Folder_SXM(1:end-4);

Info_Title={'Name','Batch_Num','Z_Encoder','Z_Scan', 'Field_Sweep', 'Field_Measured','Vbias','Vfb', 'Response', 'Time','Pixels','Lines','Xrange','Yrange','Xcenter','Ycenter','Angle'};
Info_Name=General.Add_Time2File(['Info_Batch_',num2str(Batch_Num)]);
General.File_Make(Info_Name,Info_Title);

Field_Sweep=[linspace(0,35,36),linspace(100,1600,31),linspace(1000,1000,1),linspace(700,0,15),linspace(-1,-35,35),linspace(-100,-1600,31),linspace(-1000,-1000,1),linspace(-700,0,15)]

%%

for i=2:length(Field_Sweep)
    
    if ~mod(i,4)
        % Retract 1 nm in the end of the scan
        try
            Zs=Nanonis.Get_Scanner_Z();
            while or(Zs>12,Zs<1)
                Zs=Nanonis.Get_Scanner_Z();
            end
            Nanonis.Set_Scanner_Z(Zs-0.001)
        catch err
           disp(err.message) 
        end
    end
    Magnet.Set(Mag_Inst,Field_Sweep(i),1)  % Set field
    pause(5)

    DAC.Blink(2)
    pause(2)
    
    % Blink if needed
    try
        Vfb=Nanonis.Get(1);
        if abs(Vfb)>9.85
            DAC.Blink(2)
        end
    catch err
        disp(err.message)
    end
    
    % Scan
    [Time_Of_Scan,Scan_Name]=Nanonis.Scan(Nanonis_Def);
    Scan_Name=[Scan_Name,'002.sxm'];

    % Check if Vfb jump if so blink
    try
        while Nanonis.If_Scan()   
            try
                Vfb=Nanonis.Get(1); 
                if abs(Vfb)>9.85
                    DAC.Blink(2)
                end
                pause(0.5)
            catch err
                disp(err.message)
            end
        end

    catch err
        while Nanonis.If_Scan()   
            try
                Vfb=Nanonis.Get(1); 
                if abs(Vfb)>9.85
                    DAC.Blink(2)
                end
                pause(0.5)
            catch err
                disp(err.message)
            end
        end
    end

    pause(5)
    try 
        CGT_Measure.Save(Info_Name,Scan_Name,Batch_Num,Field_Sweep(i),Vbias,Response,Nanonis_Def);  % Save the data
        [Name_Of_Fig]=CGT_Measure.Save_Raw_Data(Info_Name,Folder_SXM);  % Plot the fig
        sendmail( emailto , 'Image' ,'You got a new fig',Name_Of_Fig); % Send fig to Tal
     catch err
        disp(err.message)
    end
    disp(['percentage of run is:',num2str(round(100*i./length(Field_Sweep))),' %'])
end

% Retract 300 nm in the end of the scan
Zs=Nanonis.Get_Scanner_Z()
Nanonis.Set_Scanner_Z(Zs-0.3)