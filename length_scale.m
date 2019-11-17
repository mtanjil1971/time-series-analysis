%You need to run the ReadCbrDataEx_1.m at first
ufluc = U_311 - mean(U_311);  
[u_1m,lagu_1m] = xcorr(ufluc,'coeff');
  [rows,columns] = size(u_1m);
  N=(rows+1)/2;
  u_1m=u_1m(N:rows,1);   
  lagu_1m = lagu_1m(1,N:rows);
  tau_u1m = lagu_1m/1250;   % data rate = 1250 Hz
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