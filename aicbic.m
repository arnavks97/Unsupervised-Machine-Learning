clc;
clear all;
close all;

data = zeros(10, 2);
data(:, 1) = 1:10;
data(:, 2) = 5 + 2*data(:,1) + data(:, 1).^2 + 2*(data(:, 1).^3)
data
plot(data(:, 1), data(:, 2), 'o');
title('Regression for different polynomials');

aic = zeros(1,7);
bic = zeros(1,7);

for par = 1:7

    hold on;
    p = polyfit(data(:, 1), data(:, 2), par);
    output = polyval(p, data(:, 1));
    plot(data(:, 1), output, 'r');
    
    error = abs(output - data(:, 2));
    error = error.^2;
    temp = sum(error);
    
    ll = -(5)*1.83737 -(temp)/2;
    
    aic(par) = -2*ll + 2*par;
    bic(par) = ll - (1/2)*par*log(10);
end

figure(2);
plot(1:7, aic);
title('AIC value for different polynomials');
xlabel('Number of polynomials');
ylabel('AIC value');
[~,aicmin] = min(aic);
aicmin
[~,bicmin] = min(aic);
bicmin
figure(3);
plot(1:7, bic);
title('BIC value for different polynomials');
xlabel('Number of polynomials');
ylabel('BIC value');