function [hfd,h] = estChanResp(r,xfd,opt)
% estChanResp:  Estimates the channel response using frequency-domain
% correlation
% 
% The model is that the TX repeatedly sends x=ifft(xfd) and the RX 
% receives samples
%     r = h*x + w
% where h is the channel impulse response and w is noise.  
%
% Parameters
% ----------
% r:  RX complex baseband samples of length nfft
% xfd:  TX samples in frequency-domain
% nleft:  Number of samples to the left to place peak at
% normToMean:  Boolean flag indicating that the energy / tap
%     should be normalized to the average energy
%
% Returns
% -------
% hfd:   Frequency domain channel estimate.  hfd(k) is the estimate
%    of the channel frequency response at f(k) = k/nfft*fsamp
% h:  Time-domain channel impulse response estimate.
arguments
    r (:,1) double;
    xfd (:,1) double;
    
    opt.nleft (1,1) {mustBeInteger} = 8; 
    opt.nright (1,1) {mustBeInteger} = 8;
    opt.normToMean (1,1) = false;

end

% TODO:  Take the FFT of r 
%    rfd = ...


% TODO:  Estimate the channel frequency response by dividing by the 
% FFT of x, xfd
%    hfd = ...


% TODO:  Compute the time-domain response
%    h = ...


% TODO:  Find the peak location in h
% Then, circularly shift h so that the peak is at position opt.nleft
%    h = circshift(...)



% Normalize to the average energy signal level
if opt.normToMean
    Emean = mean(abs(h).^2);
    h = h / sqrt(Emean);
end

end