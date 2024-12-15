clc
data = xlsread('data_SP.xlsx');
currentDirectory = pwd;
disp(currentDirectory);
data = readtable('data_SP.xlsx', 'Sheet', 'Sheet2');
data.date = datetime(data.date, 'InputFormat', 'dd/MM/yyyy');
dataclosing_price = str2double(data.closing_price);
missingRows = isnat(data.date) | isnan(data.closing_price);
data(missingRows, :) = [];
fullDates = min(data.date):max(data.date);
% Linear interpolation to fill missing values
interpolatedPrices = interp1(datenum(data.date), data.closing_price, datenum(fullDates), 'linear');
length(interpolatedPrices)
n=length(interpolatedPrices);
xe=zeros(length(n));

for k=1:n-1
 %xe(k)=log10(data.closing_price(k+1))-log10(data.closing_price(k));
 xe(k)=(interpolatedPrices(k+1)-interpolatedPrices(k))./interpolatedPrices(k);
end
n=n-1; 
% Density Estimation in a region of [min(xe)-0.3 max(xe)+0.3] 
% at 100 points with given bandwidth h=0.02
xmin=min(xe);
xmax=max(xe);
m=100;
x=linspace(xmin-0.5,xmax+0.5,m);
h=0.1;
p_hat = pc_density(x,xe,h);
figure(1)
plot(x,p_hat,'LineWidth',2);
%%
r=10;
CV=zeros(r,1);
h=zeros(r,1);
for q = 1:r
h(q)=(1/r)*q; 
p = pc_density(xe,xe,h(q));
T = trapz(xe,p.^2);
CV(q)=min(T-(2.0/n)*sum(p));
end
CV
%%
figure(2)
plot(h,CV,'ro');
hold on;
plot(h,CV,'g-');
grid on;
xlabel('Bandwidth (h)');
ylabel('Cross Validation Score');
title('Minimum Likelihood Cross Validation');
hold off
