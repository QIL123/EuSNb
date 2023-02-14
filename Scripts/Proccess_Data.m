classdef Proccess_Data
    %analyze data of EuS project, updated 12/09/2021
    
    properties
        file_name
        sxm_file
        info
    end
    
    methods(Static)

        function obj = Create_IMG(folder,name,info)
            
            %UNTITLED Construct an instance of this class
            %   create IMG with properties, file_name, sxm_file and info
            
            obj.file_name = [folder,name];
            obj.sxm_file=sxm.load.loadProcessedSxM(obj.file_name);
            index=find(strcmp(info.Name,name));
            obj.info=info(index,:);
            
            
        end
        
        function [Data_FW,Data_BW] = Get_Data(img,Channel)
            %   Channel='DC_(Vfb)' / 'LIA_CH1' / 'LIA_CH2'
            % get raw data
            
            switch Channel
                case 'DC_(Vfb)'
                    Data_FW=img.sxm_file.channels(1).rawData;
                    Data_BW=img.sxm_file.channels(2).rawData;
                case 'LIA_CH1'
                    Data_FW=img.sxm_file.channels(3).rawData;
                    Data_BW=img.sxm_file.channels(4).rawData;            
                case 'LIA_CH2'
                    Data_FW=img.sxm_file.channels(5).rawData;
                    Data_BW=img.sxm_file.channels(6).rawData;
                case 'TF_X'
                    Data_FW=img.sxm_file.channels(7).rawData;
                    Data_BW=img.sxm_file.channels(8).rawData;            
                case 'TF_Y'
                    Data_FW=img.sxm_file.channels(9).rawData;
                    Data_BW=img.sxm_file.channels(10).rawData;
                case 'Input_3'
                    Data_FW=img.sxm_file.channels(3).rawData;
                    Data_BW=img.sxm_file.channels(4).rawData;                     
            end

        end
        
        function [FW,BW] = Volt2Gauss(img)
            %divide data by response
            %  if no response exists in the info file, response=1
            if ~strcmp(img.info,'no info')
                response=img.info.Response;
            else
                response=1;
            end
            
            
            [FW,BW]=Get_Data(img,'DC_(Vfb)');
            FW=FW/response;
            BW=BW/response;
            
        end
        
        function Z=FFT_Data(img,channel)
            [dataf,~]=Proccess_Data.Get_Data(img,channel);
            Z=fft2(dataf);
        end
        function [newfig]=Plot_WB_AC(img,channel,sens,Tresponse,Min,Max)

            [r,g,b]=Analyze_Images.Get_Gold();
            sxmFile=img.sxm_file;
            Data=Proccess_Data.Get_Data(img,channel);
%             divide by response and remove average:
%             Data=Data-mean(mean(Data));
%             response=img.info.Response;
%             Data=Data/response;

            %for AC images: calibrate by sensitivity and divide by thermal
            %response:
            
            Data=Data*(sens/10);
            
            % plug in settings from SOT characterization to get thermal
            % response
%             data_file='C:\Users\AlonG\Google Drive\Documents\Msc project\Data\Sep\19\12.57 UP.txt';
%             Vmin=-0.6;Vmax=0.6;Vsteps=201;Hmin=-5000;Hmax=5000;Hsteps=201;
%             
%             field=img.info.Field_Sweep;
%             Vb=-0.5;
%             Tresponse=Squid_Functions.Get_Thermal_Response(data_file,Vmin,Vmax,Vsteps,Hmin,Hmax,Hsteps,field,Vb);
%             
            Data=Data/Tresponse;
            
            Scan_Date=sxmFile.header.rec_date;
            Scan_Time=sxmFile.header.rec_time;
            Scan_Range=sxmFile.header.scan_range;
            Data_Size=size(Data);

            X0=linspace(0,Scan_Range(1)*10^6,Data_Size(1));
            Y0=linspace(0,Scan_Range(2)*10^6,Data_Size(2));
            
            [X,Y]=meshgrid(X0,Y0);
            
            newfig=figure;
            fontsize=12;
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
            set(gcf,'colormap',[r g b])

            posfig2=[100 100 2^9+250 2^9+200];  % Size of background
            set(gcf,'position',posfig2)
            c=colorbar('eastoutside');    % Colorbar
            c.Label.String = 'Magnitude [K]';
%             c.Position =  [0.87 0.093 0.03 0.825] ;%to place it where you want
            
            

            % Tickt
            xlabel('X [um]')
            ylabel('Y [um]')
            
            if ~ exist('Min','var')
                Min=min(min(Data));
            end
            
            if ~ exist('Max','var')
                Max=max(max(Data));
            end
            caxis([Min,Max])

            title(strcat('Voltage Bias=',string(img.info.Field_Sweep),'V'));

        end
        function [X,Y,Z]=Get_Processed_Data(img,channel,sens,offset)
            sxmFile=img.sxm_file;
            Data=Proccess_Data.Get_Data(img,channel);
            if ~exist('offset','var')
                offset=0;
            end
            if strcmp(channel,'DC_(Vfb)')
                Data=Data-mean(mean(Data));
            end
            Data=Data*(sens/10);
            response=img.info.Response;
            Data=Data/response;
            Data=rot90(Data,2);
            if offset~=0
                Data=Data-Data(1,end);
%                 Data=-Data;
                Data=Data+offset;
            end
            Scan_Range=sxmFile.header.scan_range;

            Data_Size=size(Data);

            X0=linspace(0,Scan_Range(2)*10^6,Data_Size(1));
            Y0=linspace(0,Scan_Range(1)*10^6,Data_Size(2));
            
            [X,Y]=meshgrid(X0,Y0);
            Z=Data;
        end
        function [newfig]=Plot_WB(img,channel,sens,newfig,Min,Max)

%             [r,g,b]=Analyze_Images.Get_Gold();
            load 'wyko.mat';
            sxmFile=img.sxm_file;
            Field=img.info.Field_Sweep;
            Field=Field/2+60;
            Data=Proccess_Data.Get_Data(img,channel);
%             divide by response and remove average:
%             if strcmp(channel,'DC_(Vfb)')
%                 Data=Data-mean(mean(Data));
%             end
            % for LIA measurements, scale by sensitivity
            
            Data=Data*(sens/10);
            

            %
            response=img.info.Response;
            Data=Data/response;
            Data=rot90(Data,2);
            if strcmp(channel,'DC_(Vfb)')
                Data=Data-Data(1,end);
%                 Data=-Data;
                Data=Data+50;
            end

            %for AC images: calibrate by sensitivity and divide by thermal
            %response:

%             Data=Data-mean(mean(Data));
            % plug in settings from SOT characterization to get thermal
            % response
%             data_file='C:\Users\AlonG\Google Drive\Documents\Msc project\Data\Sep\19\12.57 UP.txt';
%             Vmin=-0.6;Vmax=0.6;Vsteps=201;Hmin=-5000;Hmax=5000;Hsteps=201;
%             
%             field=img.info.Field_Sweep;
%             Vb=-0.5;
%             Tresponse=Squid_Functions.Get_Thermal_Response(data_file,Vmin,Vmax,Vsteps,Hmin,Hmax,Hsteps,field,Vb);
%             
%             Data=Data/Tresponse;
            
            Scan_Date=sxmFile.header.rec_date;
            Scan_Time=sxmFile.header.rec_time;
            Scan_Range=sxmFile.header.scan_range;

            Data_Size=size(Data);

            X0=linspace(0,Scan_Range(2)*10^6,Data_Size(1));
            Y0=linspace(0,Scan_Range(1)*10^6,Data_Size(2));
            
            [X,Y]=meshgrid(X0,Y0);
            
%             newfig=figure;
            fontsize=12;
            posfig1=[1 1 2^9 2^8]+70;
            fontcolor='k';
            linewidth=1;

            fig1=axes('Parent',newfig,'ZColor',fontcolor,'YColor',fontcolor,...
                    'XColor',fontcolor,...
                    'LineWidth',linewidth,...
                    'FontSize',fontsize,...  
                    'Color','w',...
                    'Units','Pixel',...
                    'Position',posfig1);
            box(fig1,'on');    
            hold(fig1,'all');

            surf(X,Y,Data');   % Plot
            view(2);
            shading interp;
            set(gcf,'colormap',[r g b],'Color','w')
            
%             contour(X,Y,Data')

            posfig2=[100 100 2^9+250 2^8+200];  % Size of background
            set(gcf,'position',posfig2)
            c=colorbar('eastoutside','Color',fontcolor);    % Colorbar
            pbaspect([2,1,1]); %aspect ratio
            c.Label.String = 'B_z(x,y) [G]';
%             c.Position =  [0.87 0.093 0.03 0.825] ;%to place it where you want
            
            

            % Tickt
            xlabel('X [\mum]')
            ylabel('Y [\mum]')
            
            if ~ exist('Min','var')
                Min=min(min(Data));
            end
            
            if ~ exist('Max','var')
                Max=max(max(Data));
            end
            caxis([Min,Max])
%             H=img.info.Field_Sweep;
%             H=H/2+60;
            %transform V to I
%             Vb=img.info.Field_Sweep;
%             Ib=0.0009033*Vb;
            
            
%             Title=text(0.395,5.15,'EuS~50nm Nb~8nm','Units','in','Rotation',0,'Color','w','FontSize',14);
            
            title(strcat('\mu_0H=',string(Field)),'Color',fontcolor);
%             title('EuS30Nb8');
            xlim([X0(1),X0(end)]);
            ylim([Y0(1),Y0(end)]);
 

        end
        
        
        function newfig=Plot_For_Movie(img,channel)
            sxmFile=img.sxm_file;
            Data=Proccess_Data.Get_Data(img,channel);
            Min=min(min(Data));
            Max=max(max(Data));
            Field=img.info.Field_Sweep;
            newfig=figure('NumberTitle', 'off', 'Name', 'Image');
            Position=[0 0 7 7];
            clf
            set(newfig,'Units','in')
            set(gcf,'InvertHardCopy','Off');
            set(newfig,'Position',Position,'Color',[0 0 0])
            fontcolor='k';
            linewidth=1;
            fontsize=8;
            [r,g,b]=Analyze_Images.Get_Gold();
            gold=[0.9290, 0.6940, 0.1250];
            
            Scan_Range=sxmFile.header.scan_range;
            Data_Size=size(Data);
            X0=linspace(0,Scan_Range(1)*10^6,Data_Size(1));
            Y0=linspace(0,Scan_Range(2)*10^6,Data_Size(2));
            [X,Y]=meshgrid(X0,Y0);
            
            posfig1=[1 1.65 5 5];
            fig1=axes('Parent',newfig,'ZColor',fontcolor,'YColor',fontcolor,...
                    'XColor',fontcolor,...
                    'LineWidth',linewidth,...
                    'FontSize',fontsize,...  
                    'Color','k',...
                    'Units','in',...
                    'xticklabel',{''},...
                    'yticklabel',{''},...
                    'xtick',[],...
                    'ytick',[],...
                    'Position',posfig1);
            box(fig1,'on');    
            hold(fig1,'all');

            surf(X,Y,Data);
            view(2);
            shading interp;
            set(gcf,'colormap',[r g b])
            caxis([Min,Max])
            Title=text(0.395,5.15,'Evolution of magnetic domains in 30nm EuS layer','Units','in','Rotation',0,'Color',gold,'FontSize',14)

            % Scale line
            Scale_Line=annotation('line','LineWidth',1,'Color',gold,'Units','in');
            Scale_Line.X=[1.2 1.2+5/6];
            Scale_Line.Y=[posfig1(2)-0.3 posfig1(2)-0.3];
            
            Scale_Factor=(Scan_Range(1)*1e6)/6;
            Scale_Text=text(0.4,-0.15,[num2str(Scale_Factor) ' µm'],'Units','in','Rotation',0,'Color',gold,'FontSize',12);
            
            Xlabel_Text=text(-posfig1(1)+3.25,-posfig1(2)+0.15,'\mu_0H_z(mT)','Units','in','Rotation',0,'Color',gold,'FontSize',12);

            % Scale Bar

            S_B_Length=4;
            S_B_X1=1.5;
            S_B_X2=1.5+S_B_Length;
            S_B_Y1=posfig1(2)-0.8;
            S_B_Y2=posfig1(2)-0.8;
            
            Scale_Bar=annotation('line','LineWidth',2,'Color',gold,'Units','in');
            Scale_Bar.X=[S_B_X1 S_B_X2];
            Scale_Bar.Y=[S_B_Y1 S_B_Y2];
            
            S_B1=annotation('line','LineWidth',2,'Color',gold,'Units','in');
            S_B1.X=[S_B_X1 S_B_X1];
            S_B1.Y=[S_B_Y1+0.05 S_B_Y1-0.05];
            
            S_B2=annotation('line','LineWidth',1,'Color',gold,'Units','in');
            S_B2.X=[S_B_X1 S_B_X1]+S_B_Length/4;
            S_B2.Y=[S_B_Y1+0.05 S_B_Y1-0.05];
            
            S_B3=annotation('line','LineWidth',2,'Color',gold,'Units','in');
            S_B3.X=[S_B_X1 S_B_X1]+S_B_Length/2;
            S_B3.Y=[S_B_Y1+0.05 S_B_Y1-0.05];
            
            S_B4=annotation('line','LineWidth',1,'Color',gold,'Units','in');
            S_B4.X=[S_B_X1 S_B_X1]+S_B_Length*3/4;
            S_B4.Y=[S_B_Y1+0.05 S_B_Y1-0.05];
            
            S_B5=annotation('line','LineWidth',2,'Color',gold,'Units','in');
            S_B5.X=[S_B_X2 S_B_X2];
            S_B5.Y=[S_B_Y1+0.05 S_B_Y1-0.05];
            
            
            Size_Lettre=12;
            
            if Field>0
                S_T1_Text='0';
                S_T3_Text='50';
                S_T5_Text='100';
                OS_T1=-0.25;
                OS_T5=-0.18;

            else
                S_T1_Text='-100';
                S_T3_Text='-50';
                S_T5_Text='0';                  
                OS_T1=-0.27;
                OS_T5=-0.13;
            end
        end
    end
end

