% Inputvariables

d = 0.533 % m
rho = 1.1708% kg/m^3
rho = 1.225% kg/m^3


% convert Data

v = polar(:,1)./3.6 % m/s
n = polar(:,2)./60
ct = polar(:,5)
cn = polar(:,6)

%% Calculate new variables

lambda = v./n./d
T = ct.*d.*d.*d.*d.*n.*n.*rho
P = cn.*d.*d.*d.*d.*d.*n.*n.*n.*rho

%% Falk

S = 1.1521 % m^2
cd0 = 0.0243
k = 0.062
m = 22;

vt = [25,30,35,40]
 
cl = (2*m*9.81)./(S.*vt.*vt*rho)
cd = cd0+k.*cl.*cl
D = cd.*rho.*vt.*vt.*S/2

%% 

pp = zeros(length(vt),1);
tp = zeros(length(vt),1);
np = zeros(length(vt),1);

for k1 = 1:length(vt)
    lambdai = 0.01;
    Ti = 0.0;
    
    while abs(Ti-D(k1)) > 0.002*D(k1)
        lambdai = lambdai+0.0002;
        ni = vt(k1)/lambdai/d;
        cti = interp1(lambda,ct,lambdai);
        cni = interp1(lambda,cn,lambdai);
        Ti = cti.*d.*d.*d.*d.*ni.*ni.*rho;
    end
    Pi = cni.*d.*d.*d.*d.*d.*ni.*ni.*ni.*rho;
    
    pp(k1) = Pi
    tp(k1) = Ti
    np(k1) = ni*60
end

pideal= pp
preal = pp./0.8

pc = zeros(length(vt),1);
tc = zeros(length(vt),1);
nc = zeros(length(vt),1);
xi = [];
yi = [];
for k1 = 1:length(vt)
    lambdai = 0.01;
    Ti = 0.0;
    
    while Pi > 2200*0.8
        lambdai = lambdai+0.0002;
        xi(length(xi)+1) = lambdai;
        ni = vt(k1)/lambdai/d;
        cti = interp1(lambda,ct,lambdai);
        cni = interp1(lambda,cn,lambdai);
        Pi = cni.*d.*d.*d.*d.*d.*ni.*ni.*ni.*rho;
        yi(length(yi)+1) = Pi;
    end
    
    Ti = cti.*d.*d.*d.*d.*ni.*ni.*rho;
    pc(k1) = Pi;
    tc(k1) = Ti;
    nc(k1) = ni*60;
end

vclimb = (2200-preal)/22/9.81


rpmmax=5000;
vm = linspace(20,50);
pm = zeros(length(vt),1);
tm = zeros(length(vt),1);
nm = zeros(length(vt),1);
xm = [];
ym = [];
for k1 = 1:length(vm)
    lambdai = 0.01;
    Ti = 0.0;
    
    cl = (2*m*9.81)./(S.*vm(k1).*vm(k1)*rho);
    cd = cd0+k.*cl.*cl;
    D = cd.*rho.*vm(k1).*vm(k1).*S/2;
    
    while abs(Ti-D) > 0.002*D
        lambdai = lambdai+0.0002;
        ni = vm(k1)/lambdai/d;
        cti = interp1(lambda,ct,lambdai);
        cni = interp1(lambda,cn,lambdai);
        Pi = cni.*d.*d.*d.*d.*d.*ni.*ni.*ni.*rho;
        Ti = cti.*d.*d.*d.*d.*ni.*ni.*rho;
    end
    
    pm(k1) = Pi;
    tm(k1) = Ti;
    nm(k1) = ni*60;
end
