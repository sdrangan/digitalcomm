%% Demos for Up- and Down-conversion
% In this demo, we show how to simulate:
% * Simulate up- and down-conversion signals in time-domain in MATLAB
% * 

%% Creating a passband signal in time domain
% Suppose that the complex baseband signal is:
%
%    u(t) = ui(t) + i*uq(t)
%    ui(t) = Tri(t/T)
%    uq(t) = 2*Tri(t/T-0.5)
nt = 1024;
T = 2.0;
t = linspace(-2*T,2*T,nt)';
f0 = 8/T;
ui = max(1-abs(t/T),0);
uq = 2*max(1-abs(t/T-0.5),0);

% Modulate the I and Q components
uicos = ui.*cos(2*pi*f0*t);
uqsin = -uq.*sin(2*pi*f0*t);
up = uicos + uqsin;

% Plot the signals 
subplot(1,3,1);
plot(t,ui, 'linewidth', 2);
hold on;
plot(t,uicos, 'linewidth', 1);
hold off;
grid();
axis([-4,4,-3,3]);
legend('u_i(t)', 'u_i(t)cos(w t)', 'Location', 'NorthWest');
set(gca, 'Fontsize', 16);

subplot(1,3,2);
plot(t,uq, 'linewidth', 2);
hold on;
plot(t,uqsin, 'linewidth', 1);
hold off;
grid();
axis([-4,4,-3,3]);
legend('u_q(t)', '-u_q(t)sin(w t)', 'Location', 'NorthWest');
xlabel('Time (us)');
set(gca, 'Fontsize', 16);

subplot(1,3,3);
plot(t,up, 'linewidth', 2);
xlabel('Time (us)');
set(gca, 'Fontsize', 16);
axis([-4,4,-3,3]);


%% Plot the convex envelope
umag = abs(ui + 1i*uq);

subplot(2,1,1);
plot(t,[ui uq],'Linewidth', 2);
hold on;
plot(t,umag,'g-','Linewidth',2);
hold off;
grid on;
legend('u_i(t)', 'u_q(t)', '|u(t)|','Location','NorthWest');
set(gca,'Fontsize',16);

subplot(2,1,2);
plot(t,[umag -umag],'g-','Linewidth',2);
hold on;
plot(t,up,'b-');
hold off;
legend('|u(t)|','-|u(t)|', 'u_p(t)','Location','NorthWest');
grid on;
set(gca,'Fontsize',16);

%% Computing a baseband equivalent filter
% Suppose that the passband filter is:
%    H_p(s) = 1/(1 + s/w0),  w0 = 2*pi*f0
% The baseband filter is:
%    H(w) = 1/(1 + j(w+wc)/w0) = 1/(a2 + a1(jw)),
%    a1 = 1/w0
%    a2 = 1+j wc/w0
G0 = 1;
f0 = 0.5*1e9;     % Cutoff frequency for the passband filter 
fc = 1e9;         % Carrier frequency
w0 = 2*pi*f0;
wc = 2*pi*fc;

% Plot the passband frequency response
subplot(1,2,1);
fp = 1e9*linspace(0,2,128)';
Hp = freqs(G0,[1/w0 1], 2*pi*fp);
plot(fp/1e9, 20*log10(abs(Hp)), 'Linewidth', 3);
hold on;
plot([0.8, 0.8], [-15,0], 'r--', 'Linewidth', 2);
plot([1.2, 1.2], [-15,0], 'r--', 'Linewidth', 2);
hold off;
ylim([-15 0]);
grid();
xlabel('Freq (GHz)');
title('Passband gain');
set(gca, 'Fontsize', 16);

% Plot the baseband frequency response
subplot(1,2,2);
fb = linspace(-2e8,2e8,128)';
Hb = freqs(G0, [1/w0, 1+1i*fc/f0], 2*pi*fb);
plot(fb/1e6, 20*log10(abs(Hb)), 'Linewidth', 3);
ylim([-15 0]);
grid();
xlabel('Freq (MHz)');
title('Baseband gain');
set(gca, 'Fontsize', 16);












