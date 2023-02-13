load MT_data.mat;
T=MT_table.T;
M=MT_table.MAt500Oe;
red='#e34a33';
fig=figure;
plot(T,M,'Color',red,'LineWidth',2)
xlabel('$T (K)$','Interpreter','latex','FontSize',16)
ylabel('$M (emu/cm^3)$','Interpreter','latex','FontSize',16)
set(fig,'Color','w')
