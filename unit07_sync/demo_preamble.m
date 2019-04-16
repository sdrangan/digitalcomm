%% Demo:  Preamble Detection and Matched Filtering
% The Gaussian hypothesis test demo considered a theoretical model which
% does not account for noise estimation, and auto-correlation.  In this
% demo, we simulate preamble detection in a more realistic setting.
%

%% Golay Code 
% As discussed in class, we want a pre-amble that has a low autocorrelation
% |R[k]| for |k \neq 0|.  There is a large mathematical theory on creating
% such sequences.  In this demo, we use one popular sequence called a Golay
% code, which is used in the 802.11 series.  You can download one in MATLAB
% as follows.

% Get complementary Golay sequences
len = 128;
[Ga,Gb] = wlanGolaySequence(len);
xpre = Ga;

% Plot the auto-correlation:
Rxx = xcorr(xpre);
stem((-len+1:len-1), abs(Rxx), 'Linewidth', 2);
xlim([-len,len-1]);

%% Plot of correlation with multi-path
% We plot the auto-correlation with two paths:  
% 
% * path 1 at a delay of 0.5 samples
% * path 2 at a delay of 10.2 samples and 0.5 the magnitude 
%
% We see that the MF produces two distincts peaks
hlen = (-32:32)';
h = sinc(hlen+0.5) + 0.5*sinc(hlen-10.2);
r = filter(h,1,xpre);
z = xcorr(r,xpre);
stem(abs(z).^2, 'lInewidth', 2);
grid on;


%% Match Filter with an Integer Delay


% We first consider a delay at an integer number of samples
gain = 1.0;
dly = 64;
r = delaysig(xpre,gain,dly,nsamp);

% We perform the preamble detection.  We see a clear peak at the delay.
maxdly = 128;
[rhom, im, rho] = predetect(r,xpre,maxdly);
t = (-maxdly:maxdly)/fsampMHz;
stem(t, abs(rho));
xlim([min(t), max(t)]);
xlabel('Time (mus)');
ylabel('rho');
set(gca, 'Fontsize', 16);

%% Calibrate the FA
% We now look at the MF detector.  
% For the remainder of the demo, we will use the following parameters
npre = 128;      % Number of preamble symbols
fsampMHz = 20;   % Sample rate
nsamp = 1024;    % Number of samples in each trial

%%
% We first wish to calibrate the threshold for a desired FA target. So, we
% pass through white noise and look at the CDF of detection statistic
ntest = 1e4;
nsamp = 1024;
pfaTgt = 1e-3;
rhoMax = zeros(ntest,1);
for it = 1:ntest
    r = randn(nsamp,1) + 1i*randn(nsamp,1);
    [rhom, ~, ~] = predetect(r,xpre,maxdly);
    rhoMax(it) = rhom;
    
end

% We plot the threshold as a function of the detection statistic
pfa = 1-(1:ntest)/ntest;
semilogy(sort(rhoMax), pfa, '-', 'Linewidth', 3);
grid on;

% The threshold is then set to match the PFA target
tfa = interp1(pfa, sort(rhoMax), pfaTgt);

%% Calibrate the Delay
% There is a fixed offset in the delays due to processing and simulation.
% 
% We calibrate the delay from look at noise free samples.

% Generate true delays
ntest = 100;
dmin = 64;
dmax = 128;
dly0 = unifrnd(dmin,dmax,ntest,1);
dlyEst = zeros(ntest,1);

% Loop over tests
for it = 1:ntest
    % Create a random gain with delay
    gain = exp(1i*2*pi*rand(1));
    r = delaysig(xpre,gain,dly0(it),nsamp);
    
    % Estimate the delay
    [rhom, im, ~] = predetect(r,xpre,maxdly);
    dlyEst(it) = im;
    
end


% Compute the offset
dlyOff = mean(dlyEst - dly0);


plot([dmin,dmax], [dmin,dmax]+dlyOff, '-', 'Linewidth',3);
hold on;
plot(dly0, dlyEst, 'o');
xlabel('True delay (samples)');
ylabel('Est delay (samples)');
grid on;
hold off;



%% Measure the Performance as a Function of the SNR
% Finally, we measure the performace as a function of the SNR.
ntest = 1000;
snrTest = (10:25)';
nsnr = length(snrTest);
pfaTgt = 1e-3;

dlyType = ['integer', 'fraction'];
ndlyType = 2;

pmd = zeros(nsnr,ndlyType);
dlyerr = zeros(nsnr,ndlyType);

for idly = 1:ndlyType

    for isnr = 1:nsnr
        % Get the SNR
        snr = snrTest(isnr);
        wvar = 10.^(-0.1*snr)*npre;

        % Create random delay -- either fractional or integer
        if (idly == 1)
            dly0 = randi([64,128],ntest,1);
        else   
            dly0 = unifrnd(64,128,ntest,1);
        end
        dlyEst = zeros(ntest,1);
        rhoMax = zeros(ntest,1);

        for it = 1:ntest
            % Create a random delay
            gain = exp(1i*2*pi*rand(1));
            x = delaysig(xpre,gain,dly0(it),nsamp);

            % Add noise
            w = (randn(nsamp,1) + 1i*randn(nsamp,1))*sqrt(wvar/2);
            r = x + w;

            % Estimate the delay
            [rhom, im, ~] = predetect(r,xpre,maxdly);
            rhoMax(it) = rhom;
            dlyEst(it) = im - dlyOff;

        end

        I = (rhoMax > tfa);
        pmd(isnr,idly) = 1-mean(I);
        dlyerr(isnr,idly) = std(dlyEst(I) - dly0(I));
        fprintf(1,'SNR = %12.4e PMD=%12.4e dly=%12.4e\n', ...
            snr, pmd(isnr), dlyerr(isnr));
    end

end

%%
%
semilogy(snrTest, pmd, 'o-', 'Linewidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('PMD');
legend('Integer delay', 'Fractional delay');
set(gca, 'Fontsize', 16);
ylim([1e-3,1]);


function [rhom, im, rho] = predetect(r,xpre,maxdly)
% Detects a preamble from normalized correlation
rho = xcorr(r,xpre,maxdly);

% Normalize to the mean energy
rho = abs(rho).^2;

% Find max correlation
[rhom, im] = max(rho);
rhom = rhom / mean(rho);
end

function r = delaysig(x,gain,dly,nsamp)
% delaysig:  Delays a signal by a fractional delay, dly.
% Output length is nsamp

% Find integer and fractional component of the delay
dly1 = mod(dly,1);
dly0 = round(dly-dly1);

% Filter the fractional delay component
nfilt = 32;
tfilt = (-nfilt:nfilt)';
h = sinc(tfilt + dly1);
y = filter(h,1,x);

% Shift signal by fractional component
r = zeros(nsamp,1);
i0 = dly0-nfilt;
ny = length(y);
i1 = min(i0+ny-1, nsamp);
r(i0:i1) = gain*y(1:i1-i0+1);
end
