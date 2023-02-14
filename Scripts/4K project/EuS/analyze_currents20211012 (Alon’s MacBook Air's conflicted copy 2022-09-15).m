%% 
folder1='/Users/along/Documents/Alon/Msc/Research/Data/Oct/12/SXM/';
folder2='/Users/along/Documents/Alon/Msc/Research/Data/Oct/11/SXM/';
info1=readtable('/Users/along/Documents/Alon/Msc/Research/Data/Oct/12/Info_Batch_1.txt');
info2=readtable('/Users/along/Documents/Alon/Msc/Research/Data/Oct/12/Info_Batch_2.txt');
%get thermal response:
data_file='/Users/along/Documents/Alon/Msc/Research/Data/Oct/06/12.32 Up.txt';
Vmin=-1.5;Vmax=1.5;Vsteps=201;Hmin=0;Hmax=2000;Hsteps=201;field=50;Vbias=1.25;
Tresponse=Squid_Functions.Get_Thermal_Response(data_file,Vmin,Vmax,Vsteps,Hmin,Hmax,Hsteps,field,Vbias);
sens=5e-3;

%% 31102021
folder='/Users/along/Documents/Alon/Msc/Research/Data/2021/Oct/26/SXM/';
info=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2021/Oct/26/Info_Batch_2.txt');

%%
length=size(info.Name);
channel='DC_(Vfb)';
sens=2e-3;
v=VideoWriter('movie.mp4','MPEG-4');
v.FrameRate=1;
open(v);
min=-0.8;
max=0.8;
for i=length:-1:1
    file_name=info.Name(i);
    img=Proccess_Data.Create_IMG(folder,char(file_name),info);
    switch channel
        case 'DC_(Vfb)'
            fig=Proccess_Data.Plot_WB(img,channel,10);
        case 'Input_3'
            fig=Proccess_Data.Plot_WB(img,channel,sens,min,max);
        case 'TF_X'
            fig=Proccess_Data.Plot_WB(img,channel,sens);
        case 'LIA_CH1'
            fig=Proccess_Data.Plot_WB(img,channel,sens);
    end
%     subplot(1,2,2)
%     file_name=info2.Name(i);
%     img2=Proccess_Data.Create_IMG(folder2,char(file_name),info2);
%     Proccess_Data.Plot_WB_AC(img2,channel,sens,Tresponse);
    axis tight manual
    set(gca,'nextplot','replacechildren');
    F=getframe(gcf);
    writeVideo(v,F)
    close all;
end
close(v);
%% calculate Peak2Peak 220203
channel='TF_X';
length=size(info.Name);
PP=zeros(1,length(1));
normI=zeros(1,length(1));
Vmax=info.Field_Sweep(1);
for i=length:-1:1
    file_name=info.Name(i);
    img=Proccess_Data.Create_IMG(folder,char(file_name),info);
    sxmFile=img.sxm_file;
    Data=Proccess_Data.Get_Data(img,channel);
%   divide by response and remove average:
%   Data=Data-mean(mean(Data));
    sens=1e-2;
    Data=Data*(sens/10);
    response=img.info.Response;
    Data=Data/response;
    Vb=info.Field_Sweep(i);
    normI(i)=Vb/Vmax;
    PP(i)=max(max(Data))-min(min(Data));
    
end

%% create subplot movie
folder1='/Users/along/Documents/Alon/Msc/Research/Data/2022/May/25/SXM/';
info1=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/May/25/Info_Batch_1.txt');

folder2='/Users/along/Documents/Alon/Msc/Research/Data/2022/May/25/SXM/';
info2=readtable('/Users/along/Documents/Alon/Msc/Research/Data/2022/May/25/Info_Batch_2.txt');

%%
length=size(info1.Name);
channel='Input_3';
sens=2e-3;
v=VideoWriter('movie.mp4','MPEG-4');
v.FrameRate=0.75;
open(v);
Min=-0.8;
Max=0.8;
max_field=max(info1.Field_Sweep);
for i=1:length
    file_name1=info1.Name(i);
    img1=Proccess_Data.Create_IMG(folder1,char(file_name1),info1);

    file_name2=info2.Name(i);
    img2=Proccess_Data.Create_IMG(folder2,char(file_name2),info2);
    
            sxmFile=img1.sxm_file;
            Field=img1.info.Field_Sweep;
            Field=Field/max_field;
%             Field=Field/2+60;
    %get data for image1

            Data1=Proccess_Data.Get_Data(img1,channel);
%             divide by response and remove average:
            if strcmp(channel,'DC_(Vfb)')
                Data1=Data1-mean(mean(Data1));
            else
                Data1=Data1*(sens/10);
            end
            % for LIA measurements, scale by sensitivity
            
            

            %
            response=img1.info.Response;
            Data1=Data1/response;
            Data1=rot90(Data1,2);

       %get data for image2

            Data2=Proccess_Data.Get_Data(img2,channel);
%             divide by response and remove average:
            if strcmp(channel,'DC_(Vfb)')
                Data2=Data2-mean(mean(Data2));
            else
                Data2=Data2*(sens/10);
            end
            % for LIA measurements, scale by sensitivity
            
            
            

            %
            response=img2.info.Response;
            Data2=Data2/response;
            Data2=rot90(Data2,2);
            %get scan info
            Scan_Range=sxmFile.header.scan_range;

            Data_Size=size(Data1);

            X0=linspace(0,Scan_Range(2)*10^6,Data_Size(1));
            Y0=linspace(0,Scan_Range(1)*10^6,Data_Size(2));
            
            [X,Y]=meshgrid(X0,Y0);

            fig=createfigure(X,Y,Data1,X,Y,Data2,Field,1,0);
            fig.WindowState='maximized';
    pause(1)
    axis tight manual

    set(gca,'nextplot','replacechildren');
    F=getframe(fig);
    writeVideo(v,F)
    close all;
end
close(v)