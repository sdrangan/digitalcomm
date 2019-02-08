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
nbits = nsym*Rmod;
bits = randi([0,1],nbits,1);

%%
% Modulate the bits to symbols using the |qammod| function.  You may need
% to set |'InputType'| to |'bit'|.  Also, set |'UnitAveragePower'| to
% |true| so the symbols have unit average power.

% TODO
% sym = qammod(...)
sym = qammod(bits,M,'InputType','bit','UnitAveragePower',true);

%%
% Plot the constellation on the complex plane

% TODO
subplot(1,1,1);
plot(real(sym), imag(sym), 'o');

%% Upsample the signal
% As discussed in class, to implement the pulse shaping filter digitally,
% we first upsample the signal.  Upsample the symbols |sym| by an 
% over-sampling factor |nov=2| and store the samples in a vector |s1|.  
% Store the up-sampled sample rate in |fsampGHzUp|.

% TODO
% nov = 2
% fsampUpGHz = ...
% symUp = ...
nov = 2;
fsampUpGHz = nov*fsampGHz;
s1 = upsample(sym,nov);

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
Ap = 1;
Astop = 30;
Hd = fdesign.lowpass('Fp,Fst,Ap,Ast',...
    fsampGHz/2,fchanGHz/2,Ap,Astop,fsampUpGHz);
d = design(Hd,'equiripple');
fvtool(d);
bfilt = d.Numerator;

%%
% Print the length of the filter

% TODO
fprintf(1,'The filter length = %d\n', length(bfilt));

%%
% Compute the frequency response using |freqz|.
% Plot the filter magnitude response |H(Omega)|^2 in dB.
% Add vertical lines indicating the locations of the edges
% of the passband and stopband.
%
% TODO
npts = 512;
[H,w] = freqz(bfilt,1,npts);
f = w/2/pi*fsampUpGHz;
Hpow = 20*log10(abs(H));
plot(f, Hpow, 'Linewidth', 2);
grid on;
fp = fsampGHz/2;
fst = fchanGHz/2;
hold on;
plot([fp fp], [-60 10], 'r--', 'Linewidth', 2);
plot([fst fst], [-60 10], 'r--', 'Linewidth', 2);
ylim([-60 20]);
hold off;
xlabel('Frequency (GHz)');
ylabel('Power gain (dB)');
ylim([-60,10]);

%% Digitally filter the samples
% Filter the upconverted samples |s1| with the designed filter.
% Store the results in a vector |s2|

% TODO
% s2 = filter(...)
s2 = filter(bfilt,1,s1);


%% PSD
% Plot the PSD of the digitally filtered samples, |s2|, against
% the physical frequency.  You can use the |pwelch| command as
% before.  Put vertical lines on the passband and stopband
%
% TODO.
[P2,f2] = pwelch(s2,hamming(512),[],[],fsampUpGHz*1e9,'centered');
f2 = f2/1e9;
P2 = 10*log10(P2);
plot(f2,P2, 'Linewidth', 2);
ylim([-140,-80]);
xlim([-fsampUpGHz/2,fsampUpGHz/2]);
xlabel('Frequency (GHz)');
ylabel('PSD (dBm/Hz)');
hold on;
fmarkers = [fsampGHz/2,fchanGHz/2];
for i = 1:length(fmarkers)
    fm = fmarkers(i);
    plot([fm,fm], [-150,-90], 'r--', 'Linewidth', 2);
    plot([-fm,-fm], [-150,-90], 'r--', 'Linewidth', 2);
end
grid;
hold off;
ylim([-150,-90]);

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
s3 = upsample(s2,nov2);
s3 = filter([1,1], 1, s3);  % Filtering

%% 
% Rescale the signal |s3| so that it has a power of |PtxdBm|.
% You can do this by measuring |mean(abs(s3).^2)| and then rescaling.
scale = 10^(0.1*PtxdBm)/mean(abs(s3).^2);
s3 = sqrt(scale)*s3;

%% 
% Plot the PSD of the analog signal |s3|.  Again use the |pwelch|
% command.  Put markers on:
%
%  * +/- 0.5*fsampGHz:  The signal bandwidth
%  * +/- 0.5*fchanGHz:  The edge of the channel
%  * +/- 1.5*fchanGHz:  The edge of the adjacent channel

% TODO
[P3,f3] = pwelch(s3,hamming(512),[],[],fsampCtsGHz*1e9,'centered');
f3 = f3/1e9;
P3 = 10*log10(P3);
plot(f3,P3,'Linewidth',2);
hold on;
xlabel('Frequency (GHz)');
ylabel('PSD (dBm/Hz)');
fmarkers = [fsampGHz/2,fchanGHz/2,1.5*fchanGHz];
mcolor = {'g--', 'r--', 'r--'};
for i = 1:length(fmarkers)
    fm = fmarkers(i);
    plot([fm,fm], [-130,-70], mcolor{i}, 'Linewidth', 2);
    plot([-fm,-fm], [-130,-70], mcolor{i}, 'Linewidth', 2);
end
grid;
hold off;
ylim([-130,-70]);
xlim([-fsampCtsGHz/2,fsampCtsGHz/2]);

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
nbut = 3;
fana = 0.5;
[bana,aana] = butter(nbut,0.5);
s4 =  filter(bana,aana,s3);

%%
% Plot the PSD of |s4| as before.  Add the band edge markers as before.

% TODO
[P4,f4] = pwelch(s4,hamming(512),[],[],fsampCtsGHz*1e9,'centered');
f4 = f4/1e9;
P4 = 10*log10(P4);
plot(f4,P4,'Linewidth',2);
hold on;
xlabel('Frequency (GHz)');
ylabel('PSD (dBm/Hz)');
fmarkers = [fsampGHz/2,fchanGHz/2,1.5*fchanGHz];
mcolor = {'g--', 'r--', 'r--'};
for i = 1:length(fmarkers)
    fm = fmarkers(i);
    plot([fm,fm], [-130,-70], mcolor{i}, 'Linewidth', 2);
    plot([-fm,-fm], [-130,-70], mcolor{i}, 'Linewidth', 2);
end
grid;
hold off;
ylim([-130,-70]);
xlim([-fsampCtsGHz/2,fsampCtsGHz/2]);


%% Measure the channel power
% Use the sampled PSD to estimate:
%
% * The total power in dBm in the main channel.
% * The total poewr in dBm in the adjacent channel.
%
% Do this by taking the average value of the PSD.  Remember to average in
% linear scale and scale by the measurement bandwidth.

% TODO
I = (abs(f4)<fchanGHz);
Pin = 10*log10(mean(10.^(0.1*P4(I)))*fchanGHz*1e9);

I = ((f4>0.5*fchanGHz) & (f4 <= 1.5*fchanGHz));
Padj = 10*log10(mean(10.^(0.1*P4(I)))*fchanGHz*1e9);

fprintf(1, 'Power in the main channel = %7.2f dBm\n', Pin);
fprintf(1, 'Power in the adjacent channel = %7.2f dBm\n', Padj);


