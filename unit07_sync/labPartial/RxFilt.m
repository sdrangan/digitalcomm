classdef RxFilt < matlab.System
    % TxFilt Upsampling interpolation filter and scaling

    properties
        % Rate parameters
        ovRatio;    % Over-sampling rate
        rateIn;     % Input rate in Hz
        rateOut;    % Output rate in Hz

        % Filter parameters
        sigBW;        % Signal BW in Hz
        Astop = 40;   % Stopband attenuation in dB
        bfilt;        % Filter coefficients
 
    end

    methods
        function obj = RxFilt(opt)
            % Constructor

            arguments
                opt.ovRatio (1,1) {mustBeInteger} = 2;
                opt.rateIn (1,1) {mustBeNumeric} = 40e6;
                opt.sigBW = [];
            end

            % TxFilt Constructor
            obj.ovRatio = opt.ovRatio;
            obj.rateIn = opt.rateIn;
            obj.rateOut = obj.rateIn / obj.ovRatio;
            if (isempty(opt.sigBW))
                opt.sigBW = 0.95*opt.rateOut;
            end
            obj.sigBW = opt.sigBW;            

        end

    end

    methods (Access = protected)
        function y = stepImpl(obj, x)

            % Design the downsampling filter if it is has not yet
            % been designed
            if isempty(obj.bfilt)
                Ap = obj.ovRatio;
                Hd = fdesign.lowpass('Fp,Fst,Ap,Ast',...
                    obj.sigBW/2,obj.rateOut/2,Ap,obj.Astop,obj.rateIn);
                d = design(Hd,'equiripple');
                obj.bfilt = d.numerator;
            end

            % Filter and downsample
            y = conv(obj.bfilt, x);
            y = downsample(y(2:end),obj.ovRatio);
       
        end


    end


end

