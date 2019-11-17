clc; clear all;
% ReadCbrDataEx_1
% - This script provides an example for loading cobra probe date

File = ["C:\Users\mhossa89\Desktop\New folder\sep exp 19\case_d_6ms (Ve).thA"];
[U_311, V_311, W_311, Ps_311, Set_311] = ReadTHFile(File);% Cbr 311 data
Vt_311 = sqrt(U_311.^2 + V_311.^2 + W_311.^2);

x = 1250; % sampling frequency
% File = ['C:\Users\mhossa89\Desktop\New folder\after contraction 4 april\center spectra\spectra_at_center_48_inch_high (Ve).thB'];
% [U_313, V_313, W_313, Ps_313, Set_313] = ReadTHFile(File);% Cbr 313 data
% Vt_313 = sqrt(U_313.^2 + V_313.^2 + W_313.^2); 

%File = ['C:\Users\mhossa89\Desktop\New folder\test run2 (An).thC'];
%[Volt, Set_313] = ReadTHFile(File);%Pitot tube voltage
%Vt_pitot = 9.1187*sqrt(Volt); 

% Calculate the mean velocities -----
Mean_U311 = mean(U_311);     Mean_Vt311 = mean(Vt_311);
%Mean_U313 = mean(U_313);     Mean_Vt313 = mean(Vt_313);
%Mean_Vpito= mean(Vt_pitot);

%% Length scale calculations

ufluc = U_311 - mean(U_311);  
[u_1m,lagu_1m] = xcorr(ufluc,'coeff');
  [rows,columns] = size(u_1m);
  N=(rows+1)/2;
  u_1m=u_1m(N:rows,1);   
  lagu_1m = lagu_1m(1,N:rows);
  tau_u1m = lagu_1m/x;   % data rate = 1250 Hz
  index_zero_crossing = find(u_1m<0,1,'first');
  if ~isempty(index_zero_crossing)
     area = trapz(tau_u1m(1:index_zero_crossing),u_1m(1:index_zero_crossing));
        %area=trapz(tau_u1m,u_1m);
   end
    plot (tau_u1m,u_1m);
    xlabel('time, \tau (s)');
    ylabel('Autocorrelation function, R')
    xlim([0 1]);
    grid on
    Lx= area .* mean(U_311);
    Iu = sqrt(mean(ufluc.^2))./Mean_Vt311;
    
    %% average spectra
    
    umean = mean(U_311);
p = (floor(numel(U_311)/10))*10;
U_311 = U_311([1:p],:);
ufluc_1m = U_311 - umean;
ufluc_1m = reshape(U_311,[numel(U_311)/10,10]);
for i = 1:10
[psd(:,i),f(:,i)] = pwelch(ufluc_1m(:,i), numel(ufluc_1m(:,i)./2), 0, numel(ufluc_1m(:,i)./2), x);
end
psd= psd(2:1:end,:);
f = f(2:1:end,:);
%code taken from anant start and change of variable names at first 5 line below
h=2*0.0254; % diameter of nozzle is 1inch= 0.0254m;
Umean=umean;
S_u5=psd; 
S=f.*S_u5./(Umean).^2;
rf=f*h./Umean;
[r,c]=size(rf);
minrf=min(min(rf));maxrf=max(max(rf));
rfbin=exp(linspace(log(minrf),log(maxrf))); %may be there might be someproblem here
num_bins=length(rfbin)-1;

for k=1:num_bins
    row=1;
    for j=1:c
        for i=1:r
            if rf(i,j)<=rfbin(k+1) && rf(i,j)>=rfbin(k)
                spectra(row,k)=S(i,j);
                row=row+1;
            end
        end
    end
end
[rr,cc]=size(spectra);

for n=1:num_bins
    count=0;
    count2=0;
    for m=1:rr
        if spectra(m,n)~=0
            count=count+1;
        else 
           count2=count2+1;
        end
        nonzero_count(n)=count;
        zero_count(n)=count2;
    end
end
avg_spectra=sum(spectra)./nonzero_count;
red_freq=zeros(1,num_bins);
for l=1:num_bins
    red_freq(l)=(rfbin(l)+rfbin(l+1))/2;
end
redfreq = red_freq(:,[23:99]);
avgspectra = avg_spectra(:,[23:99]);
figure
plot(red_freq(:,[23:99]),avg_spectra(:,[23:99]))
%plot(red_freq,avg_spectra);
set(gca, 'XScale', 'log', 'YScale', 'log');

ff(:,1) = redfreq';
ff(:,2) = avgspectra';