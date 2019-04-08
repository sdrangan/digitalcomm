%% Lab:  Demodulating QAM Symbols in Noise
%
% In this lab, you will learn to:
%
% * Demodulate QAM symbols
% * Measure the BER 
% * Compare the simulated BER to the theoretical BER
% * Simulate the effect of other impairments such as phase noise

%% Generate random bits and QAM symbols
% To test demodulation, first generate the bits and symbols for 
% |nsym=1e5| symbols of 16-QAM.  Store the bits in a vector |bits|
% and the symbols in |sym|.  You can use the |qammod| function.

modRate = 4;    % num bits per symbol (4=16 QAM)
M = 2^modRate;  % QAM order
nsym = 1e5;     % num symbols

% TODO
% nbits = ...
% bits = ...
% sym = ...

%% Add noise
% Now generate a set of received symbols:  
%
%    r = sym + w
%
% where |w| is AWGN noise with |Eb/N0=5| dB.  Remmeber to scale the noise
% variance correctly!
EbN0 = 5;

% TODO
% wvar = ...
% w = ...
% r = ..

%% Demodulate the symbols
% Demodulate the symbols |r| using the |qammod| function and measure  the
% BER.  Print the BER.  If you scaled your noise correctly, you should get
% a BER around ~0.04

% TODO
% bithat = qamdemod(...)
% ber = ...


%% Testing over a range of Eb/N0 values
% Now repeat the above simulation to measure the BER at Eb/N0 from -3 to
% 20.  Store the BER values in a vector |ber|.  Plot |ber| vs. |EbN0Test|
% using |semilogy|.  Make sure you label the axes and set the axes limits
% well to present the results well.

EbN0Test = (-3:20)';
nsnr = length(EbN0Test);
ber = zeros(nsnr,1);

% TODO


%% Compare to the theoretical BER
% Look up or derive the theoretical BER as a function of Eb/N0.  You may
% use the high SNR approximation.  Plot the theoretical value against the
% simualted value.  Add a graph legend.  You should see a good match.  

% TODO


%% Simulting Phase Errors
% We will now simulate an additional impairment:  Phase errors.  Phase
% errors occur due to phase noise and are particularly important in high
% frequency systems such as mmWave.  
%
% Generate a set of phase corrupted symbols, 
%  
%   sym1 = sym.*exp(1i*theta)
%
% where |theta| is a random Gaussian angle error with mean 0 and standard 
% deviation values in the vector |thetaStdTest|.  For each std deviation
% value:
% 
% * Create the phase corrupted symbols |sym1|
% * Demodulate the symbols and measure the BER over the SNR values from the
% previous pat.
%
% Plot the BER vs. SNR for the different phase error values.  You should
% see that the BER saturates with the phase error.
thetaStdTest = [0,0.01,0.02,0.04]*2*pi;
ntest = length(thetaStdTest);

% TODO






