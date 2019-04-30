%% OFDM parameters
% We will use the OFDM parameters for the 802.11n 40 MHz system

nfft = 128;     % FFT window size
ncp = 32;       % CP length
nguard = [7;7]; % number guard sub-carriers to left and right
fsampMHz = 40;  % Sample period

% Derived parameters
nsc = nfft - sum(nguard);  % number of occupied subcarriers
nsym = nfft+ncp;           % number of samples per OFDM symbol

%% Create random data to transmit

% Parameters
ns = 128;       % Numer of OFDM symbols
Rmod = 4;       % Number of bits per symbol
M = 2^Rmod;     % QAM modulation


% Create random bits
nbits = ns*nsc*Rmod;
bits = randi([0,1],nbits,1);

% QAM modulations
x = qammod(bits,M, 'InputType', 'bit', 'UnitAveragePower', true);

%% OFDM modulation
% To illustrate the OFDM modulation process, we will first perform the OFDM
% modulation manually

% Parallelize
X = reshape(x,nsc,ns);

% Zero pad and insert X around DC
n1 = round(nsc/2);
X0 = zeros(nfft,ns);
X0(1:n1,:) = X(1:n1,:);
X0(nfft-n1+1:nfft,:) = X(n1+1:nsc,:);

% IFFT
U0 = ifft(X0);

% Add CP and serialize
U = [U0(nfft-ncp+1:nfft,:); U0];
u = U(:);

%% OFDM using MATLAB in-built routine
% We can also use MATLAB's in-built routine

tx = comm.OFDMModulator('FFTLength', nfft, ...
    'CyclicPrefixLength', ncp,...
    'NumGuardBandCarriers', nguard, 'NumSymbols', ns );
u = tx.step(X);


%% Measure the power spectrum
[P,f] = pwelch(u,hamming(512),[],[],fsampMHz*1e6,'centered');

f0 = nsc/nfft*fsampMHz;
f = f/1e6;
P = 10*log10(P);
plot(f,P, 'Linewidth', 2);
hold on;
plot([f0/2, f0/2], [-120,-95], 'r--', 'Linewidth', 3);
plot([-f0/2, -f0/2], [-120,-95], 'r--', 'Linewidth', 3);
hold off;
xlim([-fsampMHz/2,fsampMHz/2]);
xlabel('Frequency (MHz)');
ylabel('PSD (dBm/Hz)');
grid on;


%% RX OFDM data from a Single Path Channel

% Delay the signal
gain = 1.0;
dly = 100;
nsamp = length(u) + 1000;
r = dlysig(u,gain,dly,nsamp);

% Set the starting point based on the first path
dly0 = round(dly);  % The location of the first path
i0 = 8;             % Location of the first path in the CP window
                       

% Extract data beginning at the starting point
r1 = r(dly0+1-i0:dly0+ns*nsym-i0);

% Create the OFDM RX object.
% Uses the parameters from the TX
rx = comm.OFDMDemodulator(tx);
R = rx.step(r1);

% Remove the phase rotation from the placement in the 
P = repmat( exp(2*pi*1i*(0:nsc-1)'*(i0-1)/nfft), 1,ns);
R = R.*P;

% Plot the RX data from one symbol
isym = 2;
plot(real(R(:,isym)), imag(R(:,isym)), 'o');

%%
% Note that we see a constant phase shift in the signal from the channel.
% We will show how to remove this with equalization

%% OFDM RX on a Multi-Path Noisy Channel

% Parameters for a three path channel
dlyus = 10.1 + [0, 0.23, 0.39]';
napth = length(dlyus);
gain = [1; 0.5; 0.3];
dly = dlyus*fsampMHz;

% Delay the signal
r = dlysig(u,gain,dly,nsamp);

% Set the starting point based on the first path
dly0 = round(dly(1));  % The location of the first path
i0 = 8;                % Location of the first path in the CP window
                       

% Extract data beginning at the starting point
r1 = r(dly0+1-i0:dly0+ns*nsym-i0);

% Create the OFDM RX object.
% Uses the parameters from the TX
rx = comm.OFDMDemodulator(tx);
R = rx.step(r1);

% Remove the phase rotation from the placement in the 
P = repmat( exp(2*pi*1i*(0:nsc-1)'*(i0-1)/nfft), 1,ns);
R = R.*P;

% Plot the RX data from one symbol



function r = dlysig(x,gain,dly,nsamp)
% simDelay:  Simulates a multi-path channel
% For path k:
%
%   gain(k) = gain in linear scale
%   dly(k) = dly in sample
npath = length(gain);
r = zeros(nsamp,1);
for ipath = 1:npath
    
    
    % Find integer and fractional component of the delay
    dlyp = dly(ipath);
    dly1 = mod(dlyp,1);
    dly0 = round(dlyp-dly1);

    % Filter the fractional delay component
    nfilt = 32;
    tfilt = (-nfilt:nfilt)';
    h = sinc(tfilt + dly1);
    y = filter(h,1,x);

    % Shift signal by fractional component
    i0 = dly0-nfilt;
    ny = length(y);
    i1 = min(i0+ny-1, nsamp);
    r(i0:i1) = r(i0:i1) + gain(ipath)*y(1:i1-i0+1);
end

end


