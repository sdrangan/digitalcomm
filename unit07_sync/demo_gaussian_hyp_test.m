%% Demo:  Hypothesis testing
% This demo shows how to use MATLAB to perform simple analytic calculations
% for hypothesis testing problems.

%% Binary Hypothesis Test with Real Gaussians
% We first consider a simple binary hypothesis test with 
% real Gaussian likelihoods:
% H0:  y = N(-A,sig^2)
% H1:  y = N(A,sig^2),  
% Plot the two distributions
A = 1;
sig = 0.8;

yp = linspace(-4,4,100)';
p0 = normpdf(yp,-A,sig);
p1 = normpdf(yp,A,sig);
plot(yp, [p0 p1], '-', 'Linewidth', 3);
set(gca, 'Fontsize', 16);
grid on;
legend('p(y|0)', 'p(y|1)');

%% Plot the FA and misdection
lightBlue = [0.5843    0.8157    0.9882];
orange = [255 166 76]/255;
yp = linspace(-4,4,100)';
p0 = normpdf(yp,-A,sig);
p1 = normpdf(yp,A,sig);
yp1 = linspace(t,4,100)';
yp0 = linspace(-4,t,100)';
t = 0.5;

subplot(2,1,1);
plot(yp, [p0 p1], '-', 'Linewidth', 3);
hold on;
area(yp1, normpdf(yp1,-A,sig),'facecolor',lightBlue);
grid on;
hold off;

subplot(2,1,2);
area(yp0, normpdf(yp0,A,sig),'facecolor',orange);
hold on;
plot(yp, [p0 p1], '-', 'Linewidth', 3);
set(gca, 'Fontsize', 16);
grid on;
hold off;

%% Plotting the Tradeoff
% Plot PMD vs. PFA
subplot(1,1,1);
t = linspace(-4,4,100)';
pfa = qfunc((t+A)/sig);
pmd = 1-qfunc((t-A)/sig);
plot(t,[pfa pmd],'-','Linewidth', 3);
grid on;
set(gca, 'Fontsize', 16);
xlabel('Threshold t');
legend('PFA', 'PMD');

%% Plot the ROC curve for different SNRs
t = linspace(-3,3,100);
snrTest = [0,0.5,1,1.5]';
nsnr = length(snrTest);     
for isnr = 1:nsnr
    snr = snrTest(isnr);
    pfa = qfunc(t+snr);
    pmd = 1-qfunc(t-snr);   
    p = (isnr-1)/(nsnr-1);
    color = [0; 1-p; p];
    plot(pfa, 1-pmd,'-','Linewidth', 3, 'Color', color);
    hold on;
end
hold off;
grid on;
set(gca, 'Fontsize', 16);
xlabel('PFA');
ylabel('PD');
legend('SNR=0','0.5', '1', '1.5');



%% Complex Gaussian case
% Next we consider the complex Gaussian case similar to what occurs in 
% synchronization
%
%     H0:  z = C(0,N0)
%     H1:  z = C(A,N0),  A = sqrt(Es)
%     y = |z|^2/||x||^2/N0
%

%% False alarm
% We first compute the false alarm probability.  
% In the H0 hypothesis, |y| is exponentially distributed with 
% E(y) = 1.  We confirm this by plotting the theoretical and simulated 
% CDFs under the H0 hypothesis.

% Generate random instances from H0 hypothesis
ntest = 1e4;
w = (randn(ntest,1)+1i*randn(ntest,1))/sqrt(2);
y = abs(w).^2;

% Plot the simulated and theoretical CDF
p = 1-(0:ntest-1)/ntest;
yp = linspace(0,10);
ycdf0 = exp(-yp);
semilogy(sort(y), p, yp, ycdf0,'-','Linewidth',2);
set(gca,'FontSize',16);
legend('Simulation', 'Theory');
grid on;
ylabel('PFA');
xlabel('Threshold');
ylim([1e-3, 1]);



%% Missed detection
% In the H1 hypothesis,
%
%   z = CN(A, 1)  where |A|^2 = snr
%
% Hence |y = |z|^2| is a non-central chi squared.  Again, we compare the
% theoretical and simualted CDFs.

% Loop over different SNRs
snrTest = [10,15,20]';   % SNR values in dB
nsnr = length(snrTest);
legStr = cell(nsnr*2,1);
for isnr = 1:nsnr
    
    % Simulated measured powers
    snrLin = 10^(0.1*snrTest(isnr));
    A = sqrt(snrLin);
    ntest = 1e4;
    w = (randn(ntest,1)+1i*randn(ntest,1))/sqrt(2);
    y = abs(A + w).^2;

    % Theoretical CDF from a non-central chi-squared
    yp = linspace(1,2*snrLin,100)';
    ycdf0 = ncx2cdf(2*yp,2,2*snrLin);

    % Plot of simulated and theoretical SNRs
    color = [0, 1-(isnr-1)/(nsnr-1), (isnr-1)/(nsnr-1)];
    loglog(sort(y),(1:ntest)/ntest,'-','Linewidth', 1,'Color',color);
    hold on;
    loglog(yp,ycdf0,'--', 'Linewidth', 3,'Color',color);
    legStr{2*isnr-1} = sprintf('SNR=%d (sim)', snrTest(isnr));
    legStr{2*isnr} = sprintf('SNR=%d (theory)', snrTest(isnr));
end
hold off;
set(gca,'FontSize', 16);
grid on;
xlim([1,200]);
ylim([1e-3,1]);
xlabel('Threshold')
ylabel('PMD');
legend(legStr, 'Location', 'NorthWest');

%% Missed Detection for a FA target
% We finally measure the MD as a function of the SNR and FA target

% FA targets to test
pfaTest = [1e-5,1e-6,1e-7];
nfa = length(pfaTest);
legstr = cell(nfa,1);
for ifa = 1:nfa
    % Compute FA target
    pfaTgt = pfaTest(ifa);
    t = -log(pfaTgt);
    
    % Measure PMD
    ntest = 1e5;
    snrTestTheory = linspace(10,18,21)';
    nsnr = length(snrTestTheory);
    pmdTheory = zeros(nsnr,1);
    
    for isnr = 1:nsnr
        snr = snrTestTheory(isnr);
        A = 10.^(0.05*snr);
        z = A + (randn(ntest,1)+1i*randn(ntest,1))/sqrt(2);
        rho = abs(z).^2;
        pmdTheory(isnr) = mean(rho < t);
    end

    % Plot PMD vs. SNR
    semilogy(snrTestTheory, pmdTheory, 'o-', 'Linewidth', 2);
    hold on;
    
    legstr{ifa} = sprintf('pfa = %9.1e', pfaTgt);
end
grid on;
xlabel('SNR (dB)');
ylabel('PMD');
set(gca,'Fontsize', 16);
ylim([1e-3, 1]);
hold off;
legend(legstr);



