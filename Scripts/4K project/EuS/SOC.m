% define constants:
e=1.60217662e-19; %electron charge in coulombs
hbar=1.0545718e-34; %hbar in m^2 kg/s
c=299792458; %speed of light in m/s;
f0=1; %conductivity at zero field
A=0.002613;
bso=2154; %SO characteristic field
bphi=659.3; %phase coherence charateristic field
be=155.2; %elastic characterisitc field

syms f(x)
f(x)=psi(1/2+1/x)-log(1/x);
syms g(y)
g(y)=A*(1.5*f(abs(y)/(bphi+bso*4/3))-f(abs(y)/(bso+be))-0.5*f(abs(y)/bphi));

s=matlabFunction(g);

x=-6e4:10:6e4;

plot(x,s(x))

