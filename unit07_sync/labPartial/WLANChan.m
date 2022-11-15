classdef  WLANChan < matlab.mixin.SetGetExactNames
    properties                
        % Channel properties
        snr = 20;       % SNR in dB
        dlyMin = 50;    % min and max delay in us
        dlyMax = 100;
        nsamp = 8192;   % min number of samples in each output
        fsampMHz;       % sample rate in MHz
        
        
        
    end
    
    methods
        function obj = WLANChan(varargin)
            % Constructor
            
            % Set properties
            if ~isempty(varargin)
                obj.set(varargin{:});
            end            
            % Create the packet configuration
            cfg = wlanNonHTConfig('ChannelBandwidth', 'CBW20');                
            
            % Save the sample rate
            obj.fsampMHz = wlanSampleRate(cfg)*1e-6;
                       
        end
        
        
        function [r, dlyus] = randChan(obj,x)
            % randChan: Passes x through a channel with a random delay
            
            % Get random delay
            dlyus = unifrnd(obj.dlyMin, obj.dlyMax, 1);
            gain = 1.0;
            
            % Pass signal through channel
            r0 = obj.dlyChan(x,gain,dlyus);
            
            % Add noise
            nr = length(r0);
            wvar = 10^(-0.1*obj.snr)*abs(gain)^2;
            r = r0 + complex(randn(nr,1), randn(nr,1))*sqrt(wvar/2);
            
        end
        
        function r = dlyChan(obj,x,gain,dlyus)
            % simDelay:  Simulates a single path channel with a delay in
            % us, and gain.
            
            % Find integer and fractional component of the delay
            dly = dlyus*obj.fsampMHz;
            dly1 = mod(dly,1);
            dly0 = round(dly-dly1);
            
            % Filter the fractional delay component
            nfilt = 32;
            tfilt = (-nfilt:nfilt)';
            h = sinc(tfilt + dly1);
            y = filter(h,1,x);
            
            % Shift signal by fractional component
            i0 = dly0-nfilt;
            ny = length(y);
            r = zeros(obj.nsamp,1);
            i1 = min(i0+ny-1, obj.nsamp);
            r(i0:i1) = gain*y(1:i1-i0+1);
            
        end

        
    end
    
    
end