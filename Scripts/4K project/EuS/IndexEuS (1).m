General.SetMail();
emailto='alon.gutfreund@mail.huji.ac.il';

%%
IV_Title={'Mag','Ix','Vx'};
IV_Name=General.Add_Time2File('EuS_transport_Bar_3_Down');
General.File_Make(IV_Name,IV_Title);
%%
%%210811
keit_bias=4;
dmm=22;
mag=1;
Magnet.Set_Rates(5);
EuS_Measure.IV_Mesure(IV_Name,mag,-3000,keit_bias,dmm);
Magnet.Set_Rates(1);
%%
File_Name='C:\Users\AlonG\Google Drive\Documents\Msc project\Data\Aug\11\EuS_transport1.txt';
Hall_Table=readtable(File_Name);
Hall_Mat=cell2mat(table2cell(Hall_Table));
H=Hall_Mat(:,1)';
I=Hall_Mat(:,2)';
Vx=Hall_Mat(:,3)';
Rxx=Vx./I;

plot(H,Rxx);

%%

%%



% dev 5
Mag_Inst=1;

Batch_Num=1;

Folder_SXM=General.Add_Time2File('SXM');
Folder_SXM=Folder_SXM(1:end-4);

Info_Title={'Name','Batch_Num','Z_Encoder','Z_Scan', 'Field_Sweep', 'Field_Measured','Vbias','Vfb', 'Response', 'Time','Pixels','Lines','Xrange','Yrange','Xcenter','Ycenter','Angle'};
Info_Name=General.Add_Time2File(['Info_Batch_',num2str(Batch_Num)]);
General.File_Make(Info_Name,Info_Title);

Response=1;


Field_Sweep=[2700,2100,1600,1300,950,200,100,-150,-300,-800,-1000,-1400,-1600,-2100,-2500,-2800];
Vbias=[0.52,0.52,0.52,-0.58,0.53,-0.56,-0.56,0.5,0.5,0.53,-0.58,0.5,-0.55,-0.57,0.5,-0.56];


Nanonis_Def={'EuS',2.8832, 6.7605,2, 2,64,64, 1.3, 0};  
% Nanonis_Def{Filke_Name,Xcenter[um],Ycenter[um],Width[um],Hight[um],Pixels,Lines,SpeedPerLine[s],Angle}



%%

for i=1:length(Field_Sweep)
    
    Magnet.Set(Mag_Inst,Field_Sweep(i),1)  % Set field
    pause(5)
    DAC.Set(0,Vbias(i));

    DAC.Blink(2)
    pause(2)
    
    Response=Squid_Functions.GetResponse(Mag_Inst,Field_Sweep(i), 10, 1,0);
    
    %Poke
    
    if mod(i,5)==1
        touch_point=Nanonis.Poke(0.12,12.2,1,0.001,6,100);
        pause(2);
        close all;
        DAC.Blink(2);
    end
    
    % Scan
    
    [Time_Of_Scan,Scan_Name]=Nanonis.Scan(Nanonis_Def);
    delete(fullfile(Folder_SXM,[Scan_Name,'001.sxm']));

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
        EuS_Measure.Save(Info_Name,Scan_Name,Batch_Num,Field_Sweep(i),Vbias,Response,Nanonis_Def);  % Save the data
        [Name_Of_Fig]=EuS_Measure.Save_Raw_Data(Info_Name,Folder_SXM);  % Plot the fig
        sendmail( emailto , 'Image' ,'You got a new fig',Name_Of_Fig); % Send fig to Alon
     catch err
        disp(err.message)
    end
    

    disp(['percentage of run is:',num2str(round(100*i./length(Field_Sweep))),' %'])
end


% Retract 300 nm in the end of the scan
Zs=Nanonis.Get_Scanner_Z()
Nanonis.Set_Scanner_Z(Zs-0.3)