%% Rx Filtering
%
% This script is used to create the plots for lecture.  

%% Plot of a noisy set of measurements
subplot(1,1,1);
n = 100;
t = linspace(0,1,n);
r = 1 + randn(n,1)*0.1;
plot(t,r,'-','Linewidth',2);
hold on;
plot(t,mean(r)*ones(n,1),'--','Linewidth',2);
hold off;

%% Impulse response for rectangular channel with a delay

taus = [3,3.4,3.8,4]';
ndly = length(taus);
for i = 1:ndly
    
    subplot(ndly,1,i);
    tmax = 5;
    tau = taus(i);
    t = linspace(0,tmax,1000)';
    tdis = (0:tmax)';
    gt = max(0, 1-abs(t-tau));
    plot(t,gt,'--','Linewidth',2);
    grid on;
    hold on;
    h = max(0, 1-abs(tdis-tau));
    stem(tdis,h,'Linewidth',2);
    hold off;
end


%% Impulse response forn an exponential channel
subplot(1,1,1);
tmax = 20;
t = linspace(0,tmax,1000)';
alpha = 0.2;
plot(t, alpha*exp(-alpha*t), '--', 'Linewidth', 2);
hold on;
tdis = (0:tmax)';
h = alpha*exp(-alpha*tdis);
stem(tdis, h, 'Linewidth', 2);
hold off;


%% Impuslse response for different delays 

dlyTest = [0,0.2,0.5,1];
ndly = length(dlyTest);

for i = 1:ndly
    dly = dlyTest(i);
    npts = 32;
    tau = 0.3;  % Normalized delay
    H = exp(-1i*2*pi*dly*(0:npts-1)/npts).';
    h = ifft(H);
    h = circshift(h, npts/2);

    t = (-npts/2:npts/2-1)';
    subplot(ndly,1,i);
    stem(t,abs(h));
end

%% Plot of sinc pulses


taus = [3,3.4,3.8,4]';
tdis = (-4:8)';
t = linspace(-4,8,100)';

ndly = length(taus);
for i = 1:ndly
    subplot(ndly,1,i);
    g = sinc(t-taus(i));
    plot(t,g,'--','Linewidth',2);
    hold on;
    h = sinc(tdis-taus(i));
    stem(tdis,h,'Linewidth',2);
    hold off;
end

%% Impulse response computed numerically

% Parameters
fsampMHz = 8*120*1.024;
Tsamp = 1/fsampMHz;

% Freq discretization points
npts = 128;
f = fsampMHz*(-npts/2:npts/2-1)'/npts;

% TX and RX filter
Prx = sqrt(Tsamp)*sinc(f*Tsamp);
Ptx = Prx;

% Channel
gaindB = [-10,-15];
dlyus = [0,0.01];
npath = length(gaindB);
Hchan = zeros(npts,1);
for ip = 1:npath
    Hchan = Hchan + 10^(0.05*gaindB(ip))*exp(-1i*2*pi*f*dlyus(ip));
end

% Compute discrete-time channel
G = Hchan.*Prx.*Ptx;
t = (-npts/2:npts/2-1)*Tsamp*1000;
h = 1/Tsamp*ifft(G);
h = fftshift(h);
stem(t,abs(h));
xlabel('Time (ns)');
ylabel('|h[n]|');
grid on;
xlim([-npts/2,npts/2+1]*Tsamp*1000);

