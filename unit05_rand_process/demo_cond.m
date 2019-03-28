%% Multiple variables

%% Power example
% Distance is uniformly distributed in D \in [d1,d2]
n = 500;
dmin = 10;
dmax = 200;
d = unifrnd(dmin,dmax,[n,1]);

% Generate the random powers
c = 100;
ymean = c./(d.^2);
y = exprnd(ymean);
ydB = 10*log10(y);

% Plot
plot(d,ydB,'o');
hold on;
nplot = 100;
dplot = linspace(dmin,dmax,nplot);
plot(dplot, 10*log10(c./(dplot.^2)), '-', 'Linewidth', 3);
hold off;
grid();
xlabel('Distance D [m]');
ylabel('RX power Y [dB]');
set(gca,'Fontsize',16);


%%
% Numerically evaluating the integral
ny = 100;
yplot = logspace(-2,1,ny)';
py = zeros(ny,1);
for i = 1:ny
    y = yplot(i);
    fun = @(d) d.^2/(dmax-dmin)/c.*exp(-y*(d.^2)/c);
    py(i) = integral(fun, dmin, dmax);
end

lam0 = dmin^2/c;
lam1 = dmax^2/c;
py0 = lam0*exp(-yplot*lam0);
py1 = lam1*exp(-yplot*lam1);
loglog(yplot, [py py0 py1], '-', 'Linewidth', 2);
legend('p(y)', 'p(y|d=dmin)', 'p(y|d=dmax)');
ylim([1e-8, 1e1]);
grid();
set(gca,'Fontsize',16);

%% Example:  Addive noise channel
%  y = x + w

% Plotting the PDF
sig = 0.4;
x = linspace(-4,4,1000)';
px0 = normpdf(x,-1,sig);
px1 = normpdf(x,1,sig);
px = 0.5*(px0 + px1);
plot(x,[px0 px1],'--', 'Linewidth', 2);
hold on;
plot(x,px,'-', 'Linewidth', 2);
hold off;
legend('p(y|x=-1)', 'p(y|x=1)', 'p(y)');
set(gca,'Fontsize',16);
grid()









