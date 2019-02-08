%% Lab:  Designing a TX filter for 802.11ad
% In this lab, we will design and simulate a TX filter for a simplified 
% version of an <https://en.wikipedia.org/wiki/IEEE_802.11ad 802.11ad> 
% front-end.  The 802.11ad system was the first Wireless LAN standard
% in the 60 GHz bands and offers multi-Gbps peak rates.
% In going through this lab, you will learn to:
%
% * Generate random QAM symbols
% * Design and simulate a digital filter with upsampling
% * Simulate a zero-order hold ADC and analog filter
% * Compute and display the PSD at various stages
% * Compute the power in the desired and adjacent channel.
%
% Complete all the TODO sections in this script file.  Publish the
% script and print to PDF.  Submit only the PDF.  Do not submit the MATLAB.

%% 802.11ad Parameters
% The 802.11ad parameters are as follows:
fsampGHz = 1.76;   % Signal sample rate (before upconversion)
fchanGHz = 2.16;   % Channel bandwidth
PtxdBm = 15;       % Target transmit power

%% Generate random data
% First, we generate some random QAM-symbols to transmit.
% Generate bits for |nsym| 16-QAM symbols and store the bits in the vector 
% |bits|.  You can use the |randi| function.
nsym = 2^14;    % Number of symbols
Rmod = 4;       % Modulation rate
M = 2^Rmod;     % QAM order

% TODO
% nbits = ...
% bits = ...

%%
% Modulate the bits to symbols using the |qammod| function.  You may need
% to set |'InputType'| to |'bit'|.  Also, set |'UnitAveragePower'| to
% |true| so the symbols have unit average power.

% TODO
% sym = qammod(...)

%%
% Plot the constellation on the complex plane

% TODO

%% Upsample the signal
% As discussed in class, to implement the pulse shaping filter digitally,
% we first upsample the signal.  Upsample the symbols |sym| by an 
% over-sampling factor |nov=2| and store the samples in a vector |s1|.  
% Store the up-sampled sample rate in |fsampGHzUp|.

% TODO
% nov = 2
% fsampUpGHz = ...
% symUp = ...


%% Filter design
% We will now desing the digital component of the pulse shaping filter.
% MATLAB has excellent tools for FIR filter design.  Use the function
% 
%     Hd = fdesign.lowpass(...)
%     d = design(Hd, 'equiripple')
%
% to design an equiripple filter of minimum order satisfying:
%
% * Passband bandedge at |fsampGHz|
% * Stopband bandedge of |fchanGHz|
% * Passband ripple < 1 dB
% * Stopband power rejection of at least 30 dB
% 
% You can use the |fvtool| to display the filter design.

% TODO

%%
% Print the length of the filter

% TODO


%%
% Compute the frequency response using |freqz|.
% Plot the filter magnitude response |H(Omega)|^2 in dB.
% Add vertical lines indicating the locations of the edges
% of the passband and stopband.
%
% TODO

%% Digitally filter the samples
% Filter the upconverted samples |s1| with the designed filter.
% Store the results in a vector |s2|

% TODO
% s2 = filter(...)


%% PSD
% Plot the PSD of the digitally filtered samples, |s2|, against
% the physical frequency.  You can use the |pwelch| command as
% before.  Put vertical lines on the passband and stopband
%
% TODO.


%% Simulating a zero-order hold ADC.
% We next simulate a zero-order hold ADC.  The signal after the ADC is
% continuous.  But, to simulate in MATLAB, we will look at a sampled
% version at twice the sample rate of |s2|.
nov2 = 2;
fsampCtsGHz = fsampUpGHz*nov2;

% Now, to simulate the ZOH ADC, upsample the signal |s2| by another 
% factor |nov2=2|.  But, repeat the samples instead of using zero
% insertion.  Also, scale the samples so that they have a power of
% |PtxdBm|. Let |s3| be the vector of samples from the ADC.

% TODO
% s3 = ...


%% 
% Rescale the signal |s3| so that it has a power of |PtxdBm|.
% You can do this by measuring |mean(abs(s3).^2)| and then rescaling.

% TODO
% scale = ...
% s3 = scale*s3

%% 
% Plot the PSD of the analog signal |s3|.  Again use the |pwelch|
% command.  Put markers on:
%
%  * +/- 0.5*fsampGHz:  The signal bandwidth
%  * +/- 0.5*fchanGHz:  The edge of the channel
%  * +/- 1.5*fchanGHz:  The edge of the adjacent channel

% TODO

%% Model the Analog Filter
% If you did everything correctly up to now, you should see there is a
% large image in the adjacent channel. The image is somewhat attenuated
% from the sinc^2(f/fsamp) shape from the zero-order-hold.  But, the
% attenuation is not in general sufficient.  This would be filtered out 
% with an analog filter.  
%
% Although the filter is analog, we will simulate it digitally.  Build a
% digital 3-rd order Butterworth filter with a cut-off frequency of
% 2*fsampGHz.  YOu can use the |butter| command.  Filter the signal |s3|
% with the filter and store the output in |s4|.

% TODO
% s4 = ...


%%
% Plot the PSD of |s4| as before.  Add the band edge markers as before.

% TODO



%% Measure the channel power
% Use the sampled PSD to estimate:
%
% * The total power in dBm in the main channel.
% * The total poewr in dBm in the adjacent channel.
%
% Do this by taking the average value of the PSD.  Remember to average in
% linear scale and scale by the measurement bandwidth.

% TODO


