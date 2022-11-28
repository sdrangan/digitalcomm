classdef  RandDelayChan < matlab.System
    % RandDelayChan:  Channel with a random delay
    properties
        % Channel properties
        wvar;          % noise variance
        dlyRange;      % min and max delay in seconds
        fsamp;         % sample rate in Hz
        gain;   % channel gain in dB

        % Number of output samples.  Signal will be zero-padded
        % if needed.  A value of zero indicates not to fix the output
        % size
        nsampOut;
    end

    methods
        function obj = RandDelayChan(opt)
            % Constructor

            arguments
                opt.wvar   (1,1) {mustBeNumeric} = 0;
                opt.dlyRange (1,2) {mustBeNumeric} = [50e-6,100e-6];
                opt.fsamp (1,1) {mustBeNumeric} = 40e6;
                opt.gain (1,1) {mustBeNumeric} = 0;
                opt.nsampOut (1,1) int32 = 0;
            end

            obj.wvar = opt.wvar;
            obj.dlyRange = opt.dlyRange;
            obj.fsamp = opt.fsamp;
            obj.gain = opt.gain;
            obj.nsampOut = opt.nsampOut;

        end



        function r = dlyChan(obj,x,gain,dly)
            % simDelay:  Simulates a single path channel with a delay in
            % us, and gain.

            % Find integer and fractional component of the delay
            dly = dly*obj.fsamp;
            dly1 = mod(dly,1);
            dly0 = round(dly-dly1);

            % Filter the fractional delay component
            nfilt = 32;
            tfilt = (-nfilt:nfilt)';
            h = sinc(tfilt + dly1);
            y = conv(h,x);

            % Shift signal by fractional component
            i0 = dly0-nfilt;
            ny = length(y);
            r = zeros(obj.nsampOut,1);
            i1 = min(i0+ny-1, obj.nsampOut);
            r(i0:i1) = db2mag(gain)*y(1:i1-i0+1);

        end
    end

    methods (Access = protected)

        function [r, dly] = stepImpl(obj,x)
            % randChan: Passes x through a channel with a random delay

            % Get random delay
            dly = unifrnd(obj.dlyRange(1), obj.dlyRange(2), 1);

            % Pass signal through channel
            r0 = obj.dlyChan(x,obj.gain,dly);

            % Add noise
            nr = length(r0);
            r = r0 + complex(randn(nr,1), randn(nr,1))*sqrt(obj.wvar/2);

        end
    end

end

