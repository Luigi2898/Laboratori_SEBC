clc
clear all
close all
format short Eng

invdelayfoo = @(ratio) ratio./(4.*ratio-3);
delayfoo = @(u) 0.75.*u./(u-0.25);
powfoo = @(u) u.^2;
u = linspace(0.3,1);

nbit = 16;

register.delay = 2e-9;
register.power5MHz1Vdd = 0.6e-6;
register.area = 319e-6;

incr.delay = 40e-9;
incr.power5MHz1Vdd = 2.55e-6;
incr.area = 256e-6;

comp.delay = 84e-9;
comp.power5MHz1Vdd = 2.16e-6;
comp.area = 161e-6;

mux.delay = 14e-9;
mux.power5MHz1Vdd = 1.67e-6;
mux.area = 117e-6;


%------------------------norm----------------------
tpdmax_norm = register.delay + comp.delay + incr.delay + mux.delay
fmax_norm = 1/tpdmax_norm
tclk_norm = 1/fmax_norm;

register.energy1Vdd = register.power5MHz1Vdd/5e6;
comp.energy1Vdd = comp.power5MHz1Vdd/5e6;
mux.energy1Vdd = mux.power5MHz1Vdd/5e6;
incr.energy1Vdd = incr.power5MHz1Vdd/5e6;

register.powerfMHz1Vdd = register.energy1Vdd*fmax_norm
comp.powerfMHz1Vdd = comp.energy1Vdd*fmax_norm
mux.powerfMHz1Vdd = mux.energy1Vdd*fmax_norm
incr.powerfMHz1Vdd = incr.energy1Vdd*fmax_norm

area_norm = 3*register.area + comp.area + 2*incr.area + mux.area
power_norm = 3*register.powerfMHz1Vdd + comp.powerfMHz1Vdd + 2*incr.powerfMHz1Vdd + mux.powerfMHz1Vdd


figure()
yyaxis left
plot(u,delayfoo(u),'--','Linewidth',2);
ylim([0.5 5]);
yyaxis right
plot(u,powfoo(u),'Linewidth',2);
ylim([0 1.2]);
grid minor;

close all

%----------------------parallel----------------------
fmax_parall = fmax_norm/2;
tclk_parall = 1/fmax_parall;
tclk_min_parall = register.delay + mux.delay;

register.powerf2MHz1Vdd = register.energy1Vdd*fmax_parall;
comp.powerf2MHz1Vdd = comp.energy1Vdd*fmax_parall;
mux.powerf2MHz1Vdd = mux.energy1Vdd*fmax_parall;
incr.powerf2MHz1Vdd = incr.energy1Vdd*fmax_parall;

area_parall = 5*register.area +2*comp.area + 4*incr.area + 7*mux.area
power_parall = 4*register.powerf2MHz1Vdd + register.powerfMHz1Vdd + 2*comp.powerf2MHz1Vdd + ...
    4*incr.powerf2MHz1Vdd + 2*mux.powerf2MHz1Vdd + 5*mux.powerfMHz1Vdd

tpdmax_parall = tpdmax_norm + mux.delay;


%---------------------------pipe-------------------------
tpdmax_pipe1 = comp.delay  + mux.delay + register.delay;
time_ratio_pipe1 = tpdmax_norm/tpdmax_pipe1;
tclk_pipe1 = tpdmax_pipe1;



voltage_ratio_pipe1 = invdelayfoo(time_ratio_pipe1);
power_ratio_pipe1 = powfoo(voltage_ratio_pipe1);
vdd_pipe1 = 1*voltage_ratio_pipe1;

register.powerfMHzVddpipe1 = register.powerfMHz1Vdd*power_ratio_pipe1
comp.powerfMHzVddpipe1 = comp.powerfMHz1Vdd*power_ratio_pipe1
mux.powerfMHzVddpipe1 = mux.powerfMHz1Vdd*power_ratio_pipe1
incr.powerfMHzVddpipe1 = incr.powerfMHz1Vdd*power_ratio_pipe1

power_pipe1 = (power_norm + 2*register.power5MHz1Vdd)*power_ratio_pipe1;
area_pipe1 = area_norm + 2*register.area;

%-----------------------deep pipe------------------
tpdmax_pipe2 = comp.delay + register.delay;
time_ratio_pipe2 = tpdmax_norm/tpdmax_pipe2;
tclk_pipe2 = tpdmax_pipe2;

voltage_ratio_pipe2 = invdelayfoo(time_ratio_pipe2);
power_ratio_pipe2 = powfoo(voltage_ratio_pipe2);
vdd_pipe2 = 1*voltage_ratio_pipe2;

register.powerfMHzVddpipe2 = register.powerfMHz1Vdd*power_ratio_pipe2
comp.powerfMHzVddpipe2 = comp.powerfMHz1Vdd*power_ratio_pipe2
mux.powerfMHzVddpipe2 = mux.powerfMHz1Vdd*power_ratio_pipe2
incr.powerfMHzVddpipe2 = incr.powerfMHz1Vdd*power_ratio_pipe2

power_pipe2 = (power_norm + 4*register.powerfMHz1Vdd + register.powerfMHz1Vdd/nbit)*power_ratio_pipe2;
area_pipe2 = area_norm + 4*register.area + register.area/nbit;

%--------------parallel voltage scaled-------------
time_ratio_parall = tclk_parall/tpdmax_parall;
tclk_parall_scaled = tclk_parall;
tclk_min_parall_scaled = tclk_min_parall*time_ratio_parall;
voltage_ratio_parall = invdelayfoo(time_ratio_parall);
power_ratio_parallel = powfoo(voltage_ratio_parall);
vdd_parall = 1*voltage_ratio_parall;

register.powerf2MHzVddparall = register.powerf2MHz1Vdd*power_ratio_parallel
comp.powerf2MHzVddparall = comp.powerf2MHz1Vdd*power_ratio_parallel
mux.powerf2MHzVddparall = mux.powerf2MHz1Vdd*power_ratio_parallel
incr.powerf2MHzVddparall = incr.powerf2MHz1Vdd*power_ratio_parallel

power_parall_scaled = power_parall*power_ratio_parallel;
area_parall_scaled = area_parall;

if tclk_min_parall_scaled > tclk_parall/2
    printf("REQUISITI DI TIMING NON RISPETTATI - PARALLEL VOLTAGE SCALED");
end

%---------------------parallel pipe 1---------------------
tpdmax_parall_pipe1 = tpdmax_pipe1;
time_ratio_parall_pipe1 = (tpdmax_parall_pipe1/tclk_parall)^-1;
tclk_min_parall_pipe1 = tclk_min_parall*time_ratio_parall_pipe1;
voltage_ratio_parall_pipe1 = invdelayfoo(time_ratio_parall_pipe1);
power_ratio_parall_pipe1 = powfoo(voltage_ratio_parall_pipe1);
vdd_parall_pipe1 = 1*voltage_ratio_parall_pipe1;

%register.powerf2MHzVddparall = register.powerf2MHz1Vdd*power_ratio_parallel
%comp.powerf2MHzVddparall = comp.powerf2MHz1Vdd*power_ratio_parallel
%mux.powerf2MHzVddparall = mux.powerf2MHz1Vdd*power_ratio_parallel
%incr.powerf2MHzVddparall = incr.powerf2MHz1Vdd*power_ratio_parallel

power_parall_pipe1 = (power_parall + 4*register.powerf2MHz1Vdd)*power_ratio_parall_pipe1;
area_parall_pipe1 = area_parall + 4*register.area;

if tclk_min_parall_pipe1 > tclk_parall/2
    printf("REQUISITI DI TIMING NON RISPETTATI - PARALLEL PIPE 1");
end

%--------------------parallel pipe 2-----------------------------
tpdmax_parall_pipe2 = tpdmax_pipe2;
time_ratio_parall_pipe2 = (tpdmax_parall_pipe2/tclk_parall)^-1;
tclk_min_parall_pipe2 = tclk_min_parall*time_ratio_parall_pipe2;
voltage_ratio_parall_pipe2 = invdelayfoo(time_ratio_parall_pipe2);
power_ratio_parall_pipe2 = powfoo(voltage_ratio_parall_pipe2);
vdd_parall_pipe2 = 1*voltage_ratio_parall_pipe2;

%register.powerf2MHzVddparall = register.powerf2MHz1Vdd*power_ratio_parallel
%comp.powerf2MHzVddparall = comp.powerf2MHz1Vdd*power_ratio_parallel
%mux.powerf2MHzVddparall = mux.powerf2MHz1Vdd*power_ratio_parallel
%incr.powerf2MHzVddparall = incr.powerf2MHz1Vdd*power_ratio_parallel

power_parall_pipe2 = (power_parall + 8*register.powerf2MHz1Vdd + 2*register.powerf2MHz1Vdd/nbit)*power_ratio_parall_pipe2;
area_parall_pipe2 = area_parall + 8*register.area + 2*register.area/nbit ;

if tclk_min_parall_pipe2 > tclk_parall/2
    printf("REQUISITI DI TIMING NON RISPETTATI - PARALLEL PIPE 1");
end


%--------------------plot-----------------

toplot_pow = [power_norm power_pipe1 power_pipe2 power_parall power_parall_scaled power_parall_pipe1 power_parall_pipe2]' .* 1e6;
toplot_area = [area_norm area_pipe1 area_pipe2 area_parall area_parall_scaled area_parall_pipe1 area_parall_pipe2]' .*1e6;

figure()
yyaxis left
bar([1:7],toplot_pow,.5);
names = ["Normal" "Pipe1" "Pipe2" "Parallel" "ParallelVDD" "Parallel+Pipe1" "Parallel+Pipe2"];
set(gca,'xtick',[1:7],'xticklabel',names);
ylabel("P [\muW]");
ylim([0 28]);
ax = gca;
ax.YColor = [0.25, 0.25, 0.25];
yyaxis right
bar([1:7],toplot_area,.25);
ylim([0 6500]);
ylabel("A [\mum^2]");
legend('Potenza','Area','Location','northwest');
grid minor;
set(gca,'FontSize',15)
ax = gca;
ax.YColor = [0.25, 0.25, 0.25];
title('Confronto tra consumi ed occupazione di area per le varie architetture');
%close all

%--------------visualizzazione area-------------------

square_radius = (0.5*sqrt((toplot_area)*1e-12))*1e6;
square_edge = (2.*square_radius);
figure()
for i=1:numel(square_radius)
    k=numel(square_radius)+1-i;
    rectangle('Position',[0,0,square_edge(k),square_edge(k)]...
        ,'FaceColor',[0 .5+i/14 .5+i/14]);
    text(2,square_edge(k)-3,names{k},'FontSize',14);
    hold on
end
xlabel("[\mum]");ylabel("[\mum]");
set(gca,'FontSize',15)
title("Rendering visivo dell'area occupata da ciascuna achitettura");

