%run the ReadCbrDataEx_1 first, length_scale second and this code at the end
clc;

%To find round off integer value at the end
p = (round(numel(U_311)./20) - 1)*20;
U_311 = U_311(1:1:p);
d = 0.0254*2;

%1st von karmen spectra started
fre1 = 0.001:0.001:1000;
d1  = 1; %diameter of the nozzle
Lx1 = 50;
Iu1 = 0.18;
umean = Mean_U311*4;
fstar1 = (Lx1.*fre1)./umean;
dlspec1 = ((4.*fstar1)./(1+(70.8).*((fstar1).^2)).^(5/6)).* Iu1^2;
dlfreq1 = (fre1.*Lx1./umean)*(d1/Lx1);
%von karmen spectra ended

%2nd von karmen spectra started
fre2 = 0.001:0.001:1000;
d2  = 12*.0254; %diameter of the nozzle
Lx2 = 50;
Iu2 = 0.25;
fstar2 = (Lx2.*fre2)./umean;
dlspec2 = ((4.*fstar2)./(1+(70.8).*((fstar2).^2)).^(5/6)).* Iu2^2 ;
dlfreq2 = (fre2.*Lx2./umean)*(d2/Lx2);

%3rd von karmen spectra started
fre3 = 0.001:0.001:1000;
d3  = 12*0.0254; %diameter of the nozzle
Lx3 = 100;
Iu3 = 0.18;
fstar3 = (Lx3.*fre3)./umean;
dlspec3 = ((4.*fstar3)./(1+(70.8).*((fstar3).^2)).^(5/6)).* Iu3^2;
dlfreq3 = (fre3.*Lx3./umean)*(d3/Lx3);
%von karmen spectra ended

%4th von karmen spectra started
fre4 = 0.001:0.001:1000;
d4  = 10*0.0254; %diameter of the nozzle
Lx4 = 100;
Iu4 = 0.25;
fstar4 = (Lx4.*fre4)./Mean_U311;
dlspec4 = ((4.*fstar4)./(1+(70.8).*((fstar4).^2)).^(5/6)).* Iu4^2 ;
dlfreq4 = (fre4.*Lx4./Mean_U311)*(d4/Lx4);

%spectra from wind tunnel data  
ufluc = U_311 - Mean_U311;%Use 300 sec of time series, Fs = 1250 Hz.
[psd,f] = pwelch(ufluc, numel(ufluc)/20, 0, numel(ufluc), 1250);

%to generate low pass filter for frequency and spectral density
%filter = find(f>810,1,'first');
%psd = psd(1:1:filter,:);
%f = f(1:1:filter,:);

%to generate dimentionless energy spectra

sigma = std(ufluc); %sqrt((sum(ufluc.^2))/numel(ufluc));
%dlessfreq  = f.*d./umean; %diameter of the nozzle is 1 inch= 0.0254 m;
dlessfreq = f.*d/Mean_U311;
dlesspower = f.* psd ./ (Mean_U311.^2);

%to generate the slope in dimensional spectra

%x = [5 800];
%y = [0.05 0.00133];

figure 
%plot(f, psd,'b',x,y,'r');
plot(f, psd);
xlabel('frequency, f(Hz)');
ylabel('Power Spectral Density, S_u_u (PSD)');
%legend('wind tunnel data','-5/3 slope');
set(gca, 'XScale', 'log', 'YScale', 'log');
%xlim([0 20]);
%ylim([0 3]);

figure 
plot(pp(:,1),pp(:,2),dlfreq2,dlspec2,dlfreq3,dlspec3);
xlabel('dimensionless frequency, fd/u_m_e_a_n');
ylabel('dimensionless PSD, fS_u(f)/(u_m_e_a_n)^2');
set(gca, 'XScale', 'log', 'YScale', 'log');
%legend('256inch downstream of grid','192inch downstream of grid','160inch downstream of grid','128 inch downstream of grid','I_u=25% , L_x= 50m [ESDU]','I_u=18% , L_x= 100m[ESDU]');
legend('256inch downstream of grid','I_u=25% , L_x= 50m [ESDU]','I_u=18% , L_x= 100m[ESDU]');