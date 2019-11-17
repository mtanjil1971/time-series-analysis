umean = mean(U_311);
p = (floor(numel(U_311)/10))*10;
U_311 = U_311([1:p],:);
ufluc_1m = U_311 - umean;
ufluc_1m = reshape(U_311,[numel(U_311)/10,10]);
for i = 1:10
[psd(:,i),f(:,i)] = pwelch(ufluc_1m(:,i), numel(ufluc_1m(:,i)./2), 0, numel(ufluc_1m(:,i)./2), 1250);
end
psd= psd(2:1:end,:);
f = f(2:1:end,:);
%code taken from anant start and change of variable names at first 5 line below
h=0.0254; % diameter of nozzle is 1inch= 0.0254m;
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