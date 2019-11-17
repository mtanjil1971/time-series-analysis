%run the ReadCbrDataEx_1 first, length_scale second and this code at the end
clc; close all;
u_real = 6 ;
pp = xlsread('wire vs probe');

%1st von karmen spectra started
fre1 = 0.001:0.001:1000;
d1  = 2*0.0254; %diameter of the nozzle
Lx1 = 35;
Iu1 = 0.15;
fstar1 = (Lx1.*fre1)./u_real;
dlspec1 = ((4.*fstar1)./(1+(70.8).*((fstar1).^2)).^(5/6)).* Iu1^2;
dlfreq1 = (fre1.*Lx1./u_real)*(d1/Lx1);
%von karmen spectra ended

%2nd von karmen spectra started
u_real2 = 20
fre2 = 0.01:0.001:1000;
d2  = 10*0.0254; %diameter of the nozzle
Lx2 = 100;
Iu2 = 0.25;
fstar2 = (Lx2.*fre2)./u_real2;
dlspec2 = ((4.*fstar2)./(1+(70.8).*((fstar2).^2)).^(5/6)).* Iu2^2 ;
dlfreq2 = (fre2.*Lx2./u_real2)*(d2/Lx2);


figure 
plot(dlfreq1,dlspec1,dlfreq2,dlspec2,pp(:,1),pp(:,2),pp(:,5),pp(:,6),pp(:,7),pp(:,8),pp(:,9),pp(:,10),pp(:,11),pp(:,12));
xlabel('Dimensionless frequency, fd/U_\infty');
ylabel('Dimensionless PSD, fS_u(f)/(U_\infty)^2');
set(gca, 'XScale', 'log', 'YScale', 'log','fontsize', 12,'FontName', 'Times');
xlim([0.000003 50])
ylim([0.000005 0.03])
grid on;
lgend = legend('I_u=15% , L_x= 35m','I_u = 25%, L_x = 120m','Case A: Cobra probe','Case B: Hot wire','Case B: Cobra probe','Case C: Hot wire','Case C: Cobra probe');
set(lgend,'color','none','Box', 'off','Location','northeast');
%txt = {'Case A: I_u = 0.98%, L_x = 0.75m','Case B: I_u = 3.72%, L_x = 0.32m','Case C: I_u = 5.78%, L_x = 0.23m'};
%text(0.1,0.01,txt);

set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1500 1000]/200);
% Note the -r200 -- we're telling it to export at 200 pixels-per-inch
print -dpng -r200 wire_vs_probe_update2.png