%% 802.11 Preamble Detection
% In this lab, we build a simple preamble detector for the 802.11 Wireless
% LAN standard.  In doing this lab, you will learn to:
%
% * Construct 802.11 packets using the MATLAB WLAN toolbox
% * Identify the preamble portions of the packet
% * Implement a cyclic auto-correlation detector for the short training
% field (STF)
% * Implement a matched filter detector for the long training field (LTF)
% * Evaluate the performance of the detector in terms of missed detection
% and timing error
%
% To perform this lab you will need to install MATLAB's excellent 
% <https://www.mathworks.com/products/wlan.html WLAN Toolbox>.  NYU
% students can install this toolbox for free.
%
%% File structure and submission
% To organize the simulation, I have provided four files for this lab:
%
% * lab_wlan_preamble.m:  This file.  The main script for the test.
% * WLANTx.m:  Class file for a WLAN transmitter
% * WLANChan.m:  Class file for a WLAN channel
% * WLANRx.m:  Class file for a WLAN receiver
%
% You will need to complete all the TODO sections of all four files.  Run
% the lab_wlan_preamble.m and publish it.  Then, print the published script
% and the three class files to PDF .  Collate into a single PDF.  Submit
% the collated PDF. No other formats accepted.

%% 802.11 packet structure
% To make the lab simple, we will focus on the simplest 802.11 standard, 
% the 802.11g version which was developed in 2003.  Most of the later 
% standards use a similar packet detection procedure, with additional 
% hooks for directionality and MIMO.  So understanding this basic WLAN
% packet structure is a good place to start.  The structure of the packet 
% is described in the
% <https://www.mathworks.com/help/wlan/ug/wlan-packet-structure.html
% WLAN Toolbox packet structure> page.  There are two key fields needed for
% this lab:
%
% * Legacy Short Training Field (LSTF):  Used for AGC, packet detection
%   and initial timing estimation.  This is 8 us long.
% * Legacy Long Training Field (LLTF):  Used for fine timing estimation
%   and initial channel estimation.  This is also 8 us long.  We will look
%   at channel estimation in the next lab.


%% Generate an 802.11g packet
% We first generate an 802.11 packet with random bits.  The WLAN toolbox
% provides routines for creating WLAN packets with various configurations.

% TODO:  Complete the code in the contructor and the genTxPkt() method of
% WLANTx.  Create a TX object, tx, and a random TX packet, xpkt.
% Plot the absolute values of the samples vs. time.  If you did everything
% correctly, you should see that the packet is about 250 us long.
%
%    tx = WLANTx();
%    xpkt = ...
%    fsampMHz = ...

%% Plot the preamble components
% We now plot the preamble.

% First, complete the code in WLANRx.compPreamble.
% Then, create an WLANRx() object, rx with the following command:
rx = WLANRx();


% TODO:  Using rx.lstf and rx.lltf find the lengths of the LSTF and LLTF
% fields.  Replot the packet as in the previous part.  But, this time show
% the time boundaries for the two premable fields. 


%% Create a fractional delay channel
% The class |WLANChan| simulates the channel.  The class has 
% a method that |dlyChan| that implements a simple single path channel 
% with a gain and delay.    This is already completed for you.  YOu do not
% need to modify it.  Right now, we will use it to simulate a fixed delay.

% TODO:  Create a WLANChan object chan.  Use the chan.dlyChan() method
% to simulate the packet going over a channel with 100 us delay and
% gain=1.0.  Plot the received samples r.  You should see the 100 us
% delay.
% 
%    chan = WLANChan();
%    r = chan.dlyChan(...);

%% Detect the STF
% We first implement the STF correlation that is used for packet detection.
% Cyclic correlation is not optimal but is simple to implement.

% TODO:  Complete the code in the WLANRx.STFcorr(r) method that performs 
% the cyclic correlation on the received data r.  Run the following code 
% to create a WLANRx object and perform the STF correlation.
%
%    rx = WLANRx();
%    rx.STFcorr(r);
%
% Then plot rx.rhoSTF.  You should see that correlation is between 0 and
% 1 for all samples.  Also, there should be a peak close to one near the
% sample corresponding to 100 us delay.

%% Measure the false alarm for the STF
% We now measure the false alarm rate of the STF detector.
%
% TODO:  Run |ntest| trials.  In each trial |i| create a random Gaussian noise
% vector |r| as if there is no packet, just noise.  The noise variance
% doesn't matter.  Run the STF detector and record the peak correlation.
% Store the peak correlation in |rhofa(i)|.  Based on this simulation, plot
% the false alarm rate as a function of the threshold.
%
%   nsamp = chan.nsamp;
%   ntest = 1e4;
nsamp = chan.nsamp;
ntest = 1e4;


%% Set the STF threshold
% Based on the above simulation, you should see that a FA target of 10^{-3}
% should require a threshold of about 0.1.  However, WLAN systems typically
% run at much lower FA targets.  In the remainder of the lab, we will set
% the threshold to 0.25.  

% TODO:  Complete the code in WLANRx.STFdetect().  Then test it by running
% the code below that sends a packet through a channel with a delay of
% 100us and measures the STF correlation.
tx = WLANTx();
xpkt = tx.genTxPkt(); 
dlyus = 100;
gain = 1.0;
chan = WLANChan();
r = chan.dlyChan(xpkt,gain,dlyus);

rx = WLANRx();
rx.STFcorr(r);
rx.STFdetect();
istf = rx.istf;
rhoSTF = rx.rhoSTF;

% TODO:  Plot rhoSTF and the estimated location istf for the beginning of
% the STF.  You should see that the estimated location may appear slightly
% in advance of the true delay. 


%% Correlate with the long LTF
% After detecting the STF, the RX typically searches for the LTF in a
% viciniy of the detected LTF.  

% TODO:  Complete the in WLANRx.pktDetect().  This method will perform the
% STF detection and initial timing estimation and the LTF matched filtering
% for fine timing estimation.  Test it with the following code.

% Create simulation objects
tx = WLANTx();
chan = WLANChan();
rx = WLANRx();

% Run the data through the channel
xpkt = tx.genTxPkt();
dlyus = 100;
gain = 1.0;
r = chan.dlyChan(xpkt,gain,dlyus);

% Perform the STF correlation
rx.pktDetect(r);

% TODO:  Plot the LTF correlation in rx.rhoLTF.  You will see that there is
% a sharp peak with two other smaller peaks.  The smaller peaks are due to
% the fact that the LTF is repeated.


%% Measure the detection performance in noise
% We now measure the detection performance in noise.  complete the 
% following code.  The code should loop over the snrs in
% |snrTest|.  For each snr, it performs |ntest=100| trials.  In each trial,
% a random packet is generated and sent over a random delay.  
ntest = 100;
snrTest = (-1:5)';
nsnr = length(snrTest);

dlyEst = zeros(ntest,nsnr);
dlyTrue = zeros(ntest,nsnr);
pmd = zeros(nsnr,1);
ndly = zeros(nsnr,1);

for isnr = 1:nsnr
    % Construct the simulation objects
    snr = snrTest(isnr);
    tx = WLANTx();
    rx = WLANRx();
    chan = WLANChan('snr', snr);
    
    i = 0;
    for it = 1:ntest
        
        % TODO:  Generate a random packet
        %    xpkt = ...
        

        % TODO:  Pass through a random single path channel using the
        % chan.randChan method
        %     [r, dlyus] = ..
        

        % TODO:  Run detection with the rx.pktDetect method.  If a packet
        % is found, increment i and store:
        %     dlyTrue(i,isnr) = true delay in us
        %     dlyEst(i,isnr) = estimated delay based on rx.iltf
        
    end
    
    % TODO:  Set 
    %   ndly(isnr) = number of packets that were found.
    %   pmd(isnr) = fraction of packets that were missed.
    
    % Print results
    fprintf(1,"SNR=%7.2f MD=%12.4e \n", snr, pmd(isnr));
end

% TODO:  Plot the missed detection vs. SNR.  You should see that the missed
% detection is low once the SNR is about 2 dB.

%% Calibrate the delay error
% There delay estimate has a fixed offset due to processing delays and
% filtering.  

% TODO:  Compute the delay offset, dlyOff, from the average difference
% between dlyTrue and dlyEst for the largest tested SNR.  Note that
% for any column, isnr, dlyTrue(j,isnr) and |dlyEst(j,isnr) will 
% only have valid entries j <= ndly(isnr).

% TODO:  Set dlyEstAdj = dlyEst + dlyOff, which is the adjusted delay
% estimate.

% TODO:  For SNR = 0 and SNR = 5 dB, plot a scatter plot of the true and
% estimated delays for the detected samples.  You should see that the two
% align well.  Note that even at low SNRs the delay estimate is good since
% we have discarded packets that were not detected well.
