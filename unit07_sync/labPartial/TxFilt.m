classdef TxFilt < matlab.System
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

        % Backoff paramters
        backoffAutoScale;  % Indicate if backoff is auto-scaling is enabled
        txFS;          % Tx input full-scale level
        backoffLev;    % Backoff level in dB

    end

    methods
        function obj = TxFilt(opt)
            % Constructor

            arguments
                opt.ovRatio (1,1) {mustBeInteger} = 2;
                opt.rateIn (1,1) {mustBeNumeric} = 20e6;
                opt.Fp (1,1) {mustBeNumeric} = 20e6;
                opt.Fst (1,1) {mustBeNumeric} = 25e6;
                opt.backoffAutoScale (1,1) {boolean} = false;
                opt.txFS (1,1) {mustBeNumeric} = 1.0;
                opt.backoffLev (1,1) {mustBeNumeric} = 9.0;
                opt.Astop (1,1) {mustBeNumeric} = 40;
            end

            % TxFilt Constructor
            obj.ovRatio = opt.ovRatio;
            obj.rateIn = opt.rateIn;        
            obj.Fp = opt.Fp;
            obj.Fst = opt.Fst;
            obj.rateOut = obj.ovRatio * obj.rateIn;
            obj.backoffAutoScale = opt.backoffAutoScale;
            obj.txFS = opt.txFS;
            obj.backoffLev = opt.backoffLev;
            obj.Astop = opt.Astop;

        end

    end

    methods (Access = protected)
        function y = stepImpl(obj, x)

            % Design the upsampling filter if it is has not yet
            % been designed
            if isempty(obj.bfilt) && (obj.ovRatio > 1)
                obj.designFilter();
                
            end

            if (obj.ovRatio > 1)
                % TODO:  Upsample by obj.ovRatio and filter with obj.bfilt
                %    x1 = upsample(x, ...);
                %    y0 = conv(...);
                x1 = upsample(x, obj.ovRatio);
                y0 = conv(obj.bfilt, x1);
            else
                y0 = x;
            end

            % Apply backoff
            if obj.backoffAutoScale
                % TODO:  Rescale the output to the desired backoff
                % Select a scale factor scale such that after:
                %
                %     y1 = scale*y0;
                %
                % you should get that
                %
                %    mean(abs(y1).^2) = 2*obj.txFs^2*db2pow(-obj.backoffLev)
                scale = obj.txFS*sqrt(2*db2pow(-obj.backoffLev)/mean(abs(y0).^2));
                y1 = scale*y0;

                % TODO:  Clip the output so that real(y) and imag(y)
                %   are in the range [-obj.txFS, obj.txFS]
                %    y = ...
                y = min(max(real(y1), -obj.txFS), obj.txFS) + ...
                    1i*min(max(imag(y1),-obj.txFS), obj.txFS);
            else
                y = y0;
            end
        end


    end

    methods
        function designFilter(obj)           
            % Design the filter and store the filter coefficients
            Ap = 1;  % Passband ripple
            Hd = fdesign.lowpass('Fp,Fst,Ap,Ast',...
                obj.Fp, obj.Fst, Ap, obj.Astop, obj.rateOut);
            d = design(Hd,'equiripple');
            obj.bfilt = d.numerator;
        end

    end


end

