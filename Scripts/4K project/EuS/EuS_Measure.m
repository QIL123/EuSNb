classdef EuS_Measure
    
    methods(Static)
        
        function [Mag,Con]=IV_Mesure(File_Name,Mag_Inst,Field,Keit_Bias,Dmm1)
            % This function mesure the Vfb im each field 
            
            Time_Out=0;
            Mag_Last=Magnet.Get(Mag_Inst);
            Flag=1;
            Magnet.Set(Mag_Inst,Field,2)  % Sweep the field
            while Flag
                % Mesure
                Mag=Magnet.Get(Mag_Inst);
                [Vbias,I]=Keithley.GetCurr(Keit_Bias);
                

                   Vx=Keithley.Get(Dmm1);


%                 Vfb=Nanonis.Get(1);
                General.Save(File_Name,{Mag,I,Vx});
                % Save

                % stop condition if it reach the field
                Field_Delta=Field-Mag;   % Calculate the field delta
                if abs(Field_Delta)<3    % If the field in the magnet is same as the desaire field 
                    Con=1;  % Reach the field
                    break
                end

                 % If the field in the magnet is the same, do the same thing again
                if abs(Mag-Mag_Last)<2
                    Time_Out=Time_Out+1;
                end
                Mag_Last=Mag;

                if Time_Out>10 
                    disp('Too long');
                    [Mag,Con]=EuS_Measure.IV_Mesure(File_Name,Mag_Inst,Field,Keit_Bias,Dmm1);
                    break 
                end
                pause(0.3)
            end
            Magnet.Stop(Mag_Inst) % Stop in that field
            pause(1)
            Mag=Magnet.Get(Mag_Inst);
        end
        
        function [Mag,Con]=IP_Mesure(File_Name,Mag_Inst,Field,Vbias)
            % This function mesure the Vfb im each field 

            Time_Out=0;
            Mag_Last=Magnet.Get(Mag_Inst);
            Flag=1;
            Magnet.Set(Mag_Inst,Field,2)  % Sweep the field
            while Flag
                % Mesure
                
                Mag=Magnet.Get(Mag_Inst);
                Vfb=Nanonis.Get(1);
                % Save
                General.Save(File_Name,{Vbias,Mag,Vfb});

                % stop condition if it reach the field
                Field_Delta=Field-Mag;   % Calculate the field delta
                if abs(Field_Delta)<3    % If the field in the magnet is same as the desaire field 
                    Con=1;  % Reach the field
                    break
                end

                 % If the field in the magnet is the same, do the same thing again
                if abs(Mag-Mag_Last)<2
                    Time_Out=Time_Out+1;
                end
                Mag_Last=Mag;

                if Time_Out>10 
                    o='To long'
                    [Mag,Con]=CGT_Measure.IP_Mesure(File_Name,Mag_Inst,Field,Vbias);
                    break 
                end
                pause(0.3)
            end
            Magnet.Stop(Mag_Inst) % Stop in that field
            pause(1)
            Mag=Magnet.Get(Mag_Inst);
        end
        
        function [Mag,Con]=ZFC(Temp_Kiet,Kiet,Dmm,File_Name)
            % This function mesure Rxx and Rxy as function of temp 

            Con=0;  % condition for Jump
            AS_Time=tic;
            Time_Out=0;

            [~,I] = Keithley.GetCurr(Kiet);
            Rxy1=Keithley.Get(Dmm)/I;
            Rxy2=Keithley.Get(Dmm)/I;
            Mag_Last=Magnet.Get(Mag_Inst);
            Flag=1;

            Magnet.Set(Mag_Inst,Field,2)  % Sweep the field
            while Flag%abs(Rxy1-Rxy2)<5e-4   % Wait till Rxy jump

                % We can not measure Ryx at the same time...
                % Mesure
                [~,I] = Keithley.GetCurr(Kiet);
                Vx=Keithley.Get(Kiet);
                Vy=Keithley.Get(Dmm);
                Rxx=Vx/I;
                Rxy=Vy/I;
                Mag=Magnet.Get(Mag_Inst);
                Vfb=Nanonis.Get(1);
                % Save
                General.Save(File_Name,{toc(AS_Time),Mag,1,I,Vx,Rxx,Vy,Rxy,Vfb});
                Rxy2=Rxy;

                % Optinal, to add a stop condition if it reach the
                Field_Delta=Field-Mag;   % Calculate the field delta
                if abs(Field_Delta)<3    % If the field in the magnet is same as the desaire field 
                    Con=1;  % Reach the field
                    break
                end

                 % If the field in the magnet is the same, do the same thing again
                if abs(Mag-Mag_Last)<2
                    Time_Out=Time_Out+1;
                end
                Mag_Last=Mag;

                if Time_Out>10 
                    o='To long'
                    [Mag,Con]=CGT_Measure.Transport(Mag_Inst,Kiet,Dmm,Field,File_Name)
                    break 
                end
            end
            Magnet.Stop(Mag_Inst) % Stop in that field
            pause(1)
            Magnet.PS_Off()
            Mag=Magnet.Get(Mag_Inst);
        end
        
        function Save(Info_Name,Scan_Name,Batch_Num,Field_Sweep,Vbias,Response,Nanonis_Def)
            
            Z_Encoder=Nanonis.Get_Encoder_Z();
            Z_Scan=Nanonis.Get_Scanner_Z();
            Vfb=Nanonis.Get(1);
            Field_Measured=Magnet.Get(1);
            [~,Time]=General. Time_cell();
            
            Pixels=Nanonis_Def{6};
            Lines=Nanonis_Def{7};
            Xrange=Nanonis_Def{4};
            Yrange=Nanonis_Def{5};
            Xcenter=Nanonis_Def{2};
            Ycenter=Nanonis_Def{3};
            Angle=Nanonis_Def{9};
            
            Info_Data={Scan_Name,Batch_Num,Z_Encoder,Z_Scan, Field_Sweep, Field_Measured,Vbias,Vfb,Response, Time,...
            Pixels,Lines,Xrange,Yrange,Xcenter,Ycenter,Angle};
            General.Save(Info_Name,Info_Data);

        end
        
        function [Name_Of_Fig]=Save_Raw_Data(Info_Name,Folder_SXM)

            Info=readtable(Info_Name);
            File_SXM=fullfile(Folder_SXM,Info.Name{end});
            sxmFile = sxm.load.loadProcessedSxM(File_SXM);
            [DataF,DataB]=sxmFile.channels.rawData;  % Calculate the Delta
            DataB=flipud(DataB);

            Fig_WB=CGT_Measure.Plot_Raw_Data(sxmFile,DataB,Info);
            
            Folder_RP = fullfile(fileparts(Folder_SXM),'Raw_Plot');
            if ~ exist(Folder_RP,'dir')
                mkdir(Folder_RP);
            end
            Name_Of_Fig=fullfile(Folder_RP,Info.Name{end}(1:end-7));
            saveas(Fig_WB,Name_Of_Fig, 'jpg');   
            close (Fig_WB)
            Name_Of_Fig=[Name_Of_Fig,'.jpg'];
        end
        
        
        function [newfig]=Plot_Raw_Data(sxmFile,Data,Info)

            load gold.mat

            Scan_Date=sxmFile.header.rec_date;
            Scan_Time=sxmFile.header.rec_time;
            Scan_Pixels=sxmFile.header.scan_pixels;
            Scan_Range=sxmFile.header.scan_range;

            X0=linspace(0,Scan_Range(1)*10^6,Scan_Pixels(1));
            Y0=linspace(0,Scan_Range(2)*10^6,Scan_Pixels(2));
            [X,Y]=meshgrid(X0,Y0);
            
            newfig=figure();
            fontsize=18;
            posfig1=[1 1 2^9 2^9]+70;
            fontcolor='k';
            linewidth=1;

            fig1=axes('Parent',newfig,'ZColor',fontcolor,'YColor',fontcolor,...
                    'XColor',fontcolor,...
                    'LineWidth',linewidth,...
                    'FontSize',fontsize,...  
                    'Color','none',...
                    'Units','Pixel',...
                    'Position',posfig1);
            box(fig1,'on');    
            hold(fig1,'all');

            surf(X,Y,Data);   % Plot
            view(2);
            shading interp;
            set(gcf,'colormap',[r g b]);

            posfig2=[1 1 2^9+250 2^9+200];  % Size of background
            set(gcf,'position',posfig2);
            c=colorbar('eastoutside');    % Colorbar
            c.Label.String = 'Magnitude [G]';
            c.Position =  [0.87 0.093 0.03 0.825] ;%to place it where you want
            
            % Tickt
            Name=Info.Name{end}(1:end-7);
            Field=Info.Field_Sweep(end);
            Vbias=Info.Vbias(end);
            xlabel('X [um]')
            ylabel('Y [um]')
            title([Name,'   Field Sweep:  ',num2str(Field),'  [G]   ','Bias:  ',num2str(Vbias),'[V]'])
        end
        
        
        
    end
end