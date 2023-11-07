classdef RxFilt < matlab.System
    % TxFilt Upsampling interpolation filter and scaling

    properties
        % Rate parameters
        ovRatio;    % Over-sampling rate
        rateIn;     % Input rate in Hz
        rateOut;    % Output rate in Hz

        % Filter parameters
        Astop;        % Stopband attenuation in dB
        Fp, Fst;      % Passband and stopband frequency in Hz
        bfilt;        % Filter coefficients        

        % ADC parameters
        rxScale;      % Flag indicating if data is to be scaled
        rxFS;         % Rx output full-scale level
        
    end

    methods
        function obj = RxFilt(opt)
            % Constructor
            arguments
                opt.ovRatio (1,1) {mustBeInteger} = 2;
                opt.rateIn (1,1) {mustBeNumeric} = 20e6;
                opt.Fp (1,1) {mustBeNumeric} = 20e6;
                opt.Fst (1,1) {mustBeNumeric} = 25e6;               
                opt.Astop (1,1) {mustBeNumeric} = 40;
                opt.rxFS (1,1) {mustBeNumeric} = 2^12;
                opt.rxScale (1,1) {boolean} = false;                
            end

            % TxFilt Constructor
            obj.ovRatio = opt.ovRatio;
            obj.rateIn = opt.rateIn;        
            obj.Fp = opt.Fp;
            obj.Fst = opt.Fst;
            obj.rateOut = obj.rateIn / obj.ovRatio;
            obj.Astop = opt.Astop;         
            obj.rxScale = opt.rxScale;
            obj.rxFS = opt.rxFS;
            

        end

    end

    methods (Access = protected)
        function y = stepImpl(obj, x)

            % Design the upsampling filter if it is has not yet
            % been designed
            if isempty(obj.bfilt) && (obj.ovRatio > 1)
                obj.designFilter();
                
            end

            % Scale the samples.  This is used for the SDR
            if obj.rxScale
                x = double(x) / obj.rxFS;
            end


            % Filter and downsample
            if obj.ovRatio > 1
                y = conv(obj.bfilt, x);
                y = downsample(y(2:end),obj.ovRatio);
            else
                y = x;
            end
       
        end


    end

    methods
        function designFilter(obj)           
            % Design the filter and store the filter coefficients
            Ap = 1;  % Passband ripple
            Hd = fdesign.lowpass('Fp,Fst,Ap,Ast',...
                obj.Fp, obj.Fst, Ap, obj.Astop, obj.rateIn);
            d = design(Hd,'equiripple');
            obj.bfilt = d.numerator;
        end

    end



end

