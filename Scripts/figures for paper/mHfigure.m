folder='/Users/along/Documents/Alon/Msc/Research/Data/Cambridge Data/';
file='In plane MH 4p2K minor for plotting.txt';
MHtable=readtable(strcat(folder,file));

MHmat=cell2mat(table2cell(MHtable));
H=MHmat(:,1);
M=MHmat(:,2);
plot(H,M);