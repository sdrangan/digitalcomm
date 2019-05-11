%% 802.11 OFDM Equalization
% In this lab, we build on the preamble detection lab to transmit and 
% receive OFDM packets.  In doing this lab, you will learn to:
% 
% * Align the OFDM window from a preamble.
% * Set OFDM parameters such as CP, NFFT and guard carriers
% * Demodulate OFDM symbols
% * Compute raw and smooth channel estimates from reference symbols
% * Equalize OFDM symbols
% * Measure the effective SNR including loss from equalization.

%% File Format and Submission
% The lab involves four files:
%
% * WLANRx.m, WLANChan.m, WLANTx.m:  These are three files from the
% previous exercise, but with the packet detection part completed.  You can
% use these or the ones you developed in the previous lab.  Since they
% include solutions from the previous lab, they are not in the github repo.
% Your instructor should provide them.
% * lab_ofdm.m:  This is the main file that will be used for the lab.
% 
% You will need to complete all the TODO sections of all four files.  Run
% the lab_wlan_preamble.m and publish it.  Then, print the published script
% and the three class files to PDF .  Collate into a single PDF.  Submit
% the collated PDF. No other formats accepted.


%% Perform the OFDM Demodulation of the TX symbols
% For debugging, it is useful to have a copy of the TX symbols in
% the RX.  In reality, of course, these symbols would not be present at the
% RX.  In this section, we regenerate the transmitted packet at the RX and
% perform the OFDM demodulation on the TX data.  This will give us a
% reference for the ideal RX symbols.

% Create a TX object and generate a packet.
tx = WLANTx();
xpkt = tx.genTxPkt();
bits = tx.bits;

% Create an RX object
rx = WLANRx();

% TODO:  Complete the code in WLANRx.getTXsym().  This code
% will take the TX bits and performs the OFDM demodulation on the
% transmitted data.  Then, run the following code.
rx.getTXsym(bits);

% TODO:  The stored OFDM TX symbols are stored in a matrix, rx.Xtx.
% Based on the size(rx.Xtx) find the number of occupied subcarriers and
% OFDM symbols
%   
%   [nsc, ns] = ...

% The matrix Xtx(:,i) has the OFDM modulation symbols.  The first three
% symbols are a special format.  For i > 3, 
%
% * Xtx(rx.Iscdata,i) contains the data symbol.  In this example, they are
%   QPSK modulated.
% * Xtx(rx.Iscpilot,i) contains the pilot symbols.  These are BPSK
%   modulated.
%
% TODO:  Create a scatter plot of the OFDM modulation symbols in symbol 5.
% Mark the pilot and data symbols with different colors.



%% Setting the OFDM window
% The hardest part in getting an OFDM receiver to work is to correctly 
% select the starting point for the receiver.  Recall that the packet
% detection produces an output, rx.iltf, indicating the index of the sample
% on which the preamble was detected.  We want to start the OFDM
% demodulation at some time fixed time, rx.ltfOff, from that point:
%
%     i0 = rx.iltf + rx.ltfOff
%
% The easiest way to find rx.ltfOff is to use the following calibration.
% First, we create an RX vector, r, where the transmitted packet, xpkt, is
% delayed by a known dly, idly:
nsamp = 8192;
idly = 2000;
r = zeros(nsamp, 1);

% TODO:  r = ... % Insert xpkt at a delay of ildy

% TODO:  Perform the STF correlation on r
%
%    rx.pktdetect(...)

% We know we want to start the demodulation at
%     idly + length(rx.lstf)
% The OFDM modulation will start at rx.ilft + rx.offLtf, so 
% we know that
%
%    ltfOff = idly - rx.iltf + length(rx.lstf);
%rx
% TODO:  Compute this value of rx.offLtf and set the field in WLANRx with
% this value.  

    
%% Recover the OFDM symbols
% TODO:  Complete the code in WLANRx.ofdmDemod().  This will demodulate the 
% received symbols. Then, run the following code.
rx.ofdmDemod(r);

% TODO:  The received OFDM modulation symbols should be stored in rx.Xrx.
% Plot the pilot and data OFDM modulation symbols for the RX symbol 5.
% These should match the transmitted values.  But, you may get a phase
% rotation, if you didn't align the timing correctly.
%    Xdat = rx.Xrx(...)   % Use rx.Iscdata
%    Xpil = rx.Xrx(...)   % Use rx.Iscpilot
%    plot(...)

%% Compute a Raw Channel Estimate
% The first two OFDM symbols after the STF are the LTF, long training
% field.  These are known to the RX and can be used for channel estimation.

% TODO:  Complete the code in WLANRx.chanEstRaw(), which computes a "raw"
% channel estimate from the LTF.  Plot the real and imaginary components of
% rx.Hraw vs. the subcarrier index.
%
%   rx.chanEstRaw()
%   plot(...)
%
% You should ideally get a constant.

     
%% Run over a multi-path channel with no noise
% Now, we run over a multipath channel.
chan = WLANChan();
gain = [1; 0.5; 0.2];
gain = gain/norm(gain);
dly0 = 100;
dlyus = 100 + [0; 0.2; 0.37]';

chan.snr = [];  % Sets to infinite SNR
r = chan.dlyChan(xpkt, gain, dlyus);

% TODO:  Run the peak detection, ofdmDemod and raw channel estimate.
%   rx.pktDetect(r);
%   ...

% TODO:  Store the raw channel estimate in rx.Hraw in Hest0. Plot the real 
% component of Hest0. You should see that the channel varies over the 
% subcarrier index due to the multipath.
%    Hest0 = ...
%    plot(...)

%% Run over a multi-path channel with noise
% Now, let's add noise.  We can do this by setting the SNR in the channel 
% object
chan.snr = 15;
r = chan.dlyChan(xpkt, gain, dlyus);

% TODO:  Compute the raw channel estimate again and store the vector in 
% Hest1.  To compare the ideal and noisy case, plot real(Hest0) and 
% real(Hest1).  You should see there is a little bit of noise on the 
% channel estimate.


%% Adding smoothing
% A common procedure to reduce the noise in the channel estimate is to use
% smoothing.  
%
% TODO:  Complete the code in WLAN.chanEst(), which computes a
% smoothed channel estimate.  Run rx.chanEst() and store rx.Hest in Hest2.
% Plot the real components of Hest0, Hest1 and Hest2.


%% Equalize the symbols
% We will now equalize the symbols with the channel estimate.
% 
% TODO:  Complete the code WLANRx.ofdmEq() and run rx.ofdmEq();
%    rx.ofdmEq();
rx.ofdmEq();

% After running the equalization, the equalized symbols are 
% stored in the matrix rx.Xeq.  We can extract the data symbols via the
% following command.
Xest = rx.Xeq(rx.Iscdata,4:end-1);

% TODO:  Plot the symbols Xest on the complex plane.  You should see they
% are noisy version of the QPSK symbols.

%% Measure the average symbol SNR
% We will now measure the average symbol SNR to measure the effectiveness
% of the system with equalization.
%
% TODO:  Extract the data symbols from the TX symbols similar to the way 
% you extracted Xest.
%     Xtx = rx.Xtx(...)

% TODO:  Measure the average SNR which is the average of abs(Xtx).^2
% by the average error abs(Xtx-Xest).^2.  Compute the ratio and print the
% value in dB.

%% Computing the average output SNR
% You will see that the computed SNR is around ~10 to 11 dB, which is
% considerably lower than the 15 dB input SNR.  The reason is that the 
% channel gain is varying so some subcarriers experience noise
% amplification when the channel is small.  In reality, the noise level can
% be predicted and this can be fed into the decoder.
%
% A better way to compute the SNR is on the received symbols Y=HX.  We will
% show how to do this.

% TODO: First extract the channel estimate from data tones using the
% indices rx.Iscdata
%    Hdat = rx.Hest(...)  
Hdat = rx.Hest(rx.Iscdata);

% TODO:  Multiply  Xtx and Xest by Hdat and store in Ytx and Yest.
%    Ytx = ...
%    Yest = ...

% TODO:  Measure the average SNR which is the average of abs(Ytx).^2
% by the average error abs(Ytx-Yest).^2.  Compute the ratio and print the
% value in dB.  If you did things correctly, you should see that you get an
% SNR of around 14~dB, which means there is a loss of about 1 dB from
% equalization.

%% Measure effective SNR over input SNR
% We will now measure the effective output SNR as a function of the channel
% SNR.  We will repeat the test over the following channel SNR levels.
snrTest = (5:30)';
nsnr = length(snrTest);

% For each snr value in snrTest, we will run ntest=10 trials and measure
% the average output SNR.  We will store the output SNR in snrEff.
ntest = 10;
snrEff = zeros(nsnr,ntest);

% Main loop
for isnr = 1:nsnr
    
    for it = 1:ntest
        % TODO:  Generate TX data
        %  tx = ...
        %  xpkt = ...
        %  bits = ...

        % Modify the channel SNR
        snr = snrTest(isnr);
        chan.snr = snr;
        
        % TODO:  Send xpkt over the channel
        %    r = chan.dlyChan(...)

        % RX data and packet detect.  Skip measurement if packet not
        % detected.
        rx = WLANRx();        
        rx.getTXsym(bits);
        rx.pktDetect(r);
        if ~rx.pktFound
            continue;
        end
        
        % TODO:  Demodualate, compute the channel estimate and equalize
        
        % TODO:  Measure the SNR Get the TX symbols and channel estimate

        % TODO:  Compute the effective output SNR and store in snrEff.
    end    
    fprintf(1, 'SNR in=%7.2f eff=%7.2f\n', snr, mean(snrEff(isnr,:)));
end    
    
% The optimal SNR is the input plus a factor since the energy is
% concentrated on the occupied subcarriers.
snrOpt = snrTest + 10*log10(rx.nfft/rx.nsc);

% Plot the average output SNR and optimal SNR
snrEffAvg = mean(snrEff,2);
plot(snrTest, snrOpt, '-', 'Linewidth', 2);
hold on;
plot(snrTest, snrEffAvg, 'o-', 'Linewidth', 2);
hold off;
grid on;
xlabel('Input SNR');
ylabel('SNR after Eq');
legend('Optimal', 'Measured');

%%
% If you did everything correctly, you should get about 1 dB loss from
% optimal at low SNRs.  At higher SNRs, there is bias error which increases
% the SNR loss.  Some of the 1dB loss is not from channel equalization, but
% just from the fact that we sent power out of band.  This would have been
% reduced from filtering.
%
% Commercial systems are generally designed to limit the equalization loss
% to around 0.25 dB for low SNRs.





    




