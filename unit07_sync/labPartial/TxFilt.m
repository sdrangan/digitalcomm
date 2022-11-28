classdef TxFilt < matlab.System
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

        % Backoff paramters
        applyBackoff;  % Indicate if backoff is applied
        dacFS;         % DAC full-scale level
        backoffLev;    % Backoff level in dB

    end

    methods
        function obj = TxFilt(opt)
            % Constructor

            arguments
                opt.ovRatio (1,1) {mustBeInteger} = 2;
                opt.rateIn (1,1) {mustBeNumeric} = 20e6;
                opt.sigBW = [];
                opt.applyBackoff (1,1) {boolean} = false;
                opt.dacFS (1,1) {mustBeNumeric} = 1.0;
                opt.backoffLev (1,1) {mustBeNumeric} = 9.0;
            end

            % TxFilt Constructor
            obj.ovRatio = opt.ovRatio;
            obj.rateIn = opt.rateIn;
            if (isempty(opt.sigBW))
                opt.sigBW = 0.9*opt.rateIn;
            end
            obj.sigBW = opt.sigBW;
            obj.rateOut = obj.ovRatio * obj.rateIn;
            obj.applyBackoff = opt.applyBackoff;
            obj.dacFS = opt.dacFS;
            obj.backoffLev = opt.backoffLev;

        end

    end

    methods (Access = protected)
        function y = stepImpl(obj, x)

            % Design the upsampling filter if it is has not yet
            % been designed
            if isempty(obj.bfilt)
                
                % TODO:  Set the filter parameters
                %
                %    Ap = 1;  % Passband gain (linear scale)
                %    Ast = obj.Astop;  % Stopband rejection in dB
                %    Fst = ... % stopband bandwidth in Hz
                %    Fp = ...  % passband bandwidth in Hz                
                Ap = 1;
                Ast = obj.Astop;
                Fp = obj.sigBW/2;
                Fst = obj.rateIn/obj.ovRatio;

                % Design the filter and get the filter coefficients
                Hd = fdesign.lowpass('Fp,Fst,Ap,Ast',...
                    Fp, Fst, Ap, Ast, obj.rateOut);
                d = design(Hd,'equiripple');
                obj.bfilt = d.numerator;
            end

            % TODO:  Upsample by obj.ovRation and filter with obj.bfilt
            %    y = upsample(x, ...);
            %    y = conv(...);
            y = upsample(x, obj.ovRatio);
            y = conv(obj.bfilt, y);

            % Apply backoff
            if obj.applyBackoff
                % TODO:  Rescale the output to the desired backoff
                % Select a scale factor scale such that after:
                %
                %     y = scale*y;
                %
                % you should get that 
                %
                %    mean(abs(y).^2) = 2*obj.dacFs^2*db2pow(-obj.backoffLev)
                scale = obj.dacFs*sqrt(2*db2pow(-obj.backoffLev)/mean(abs(y).^2));
                y = scale*y;                

                % TODO:  Clip the output so that real(y) and imag(y)
                %   are in the range [-obj.dacFS, obj.dacFS]    
                %    y = ...
                y = min(max(real(y),obj.dacFS), -obj.dacFS) + ...
                    1i*min(max(imag(y),obj.dacFS), -obj.dacFS);
            end
        end


    end


end

