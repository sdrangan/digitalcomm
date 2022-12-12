classdef  WLANRx <  matlab.System
    properties
        % Packet properties
        cfg;        % WLAN Toolbox configuration
        fsamp;      % Sample rate in MHz
        info;       % OFDM info
        nsampSym;   % number of samples per OFDM symbol                
        ofdmFrameOff;    % OFDM frame offset in samples
        nsymData;   % number of data symbols 
        nsymPre = 3;  % number of pre-amble symbols from start of LTF

        % TX and RX legacy LTF field in frequency domain
        symLTFTx;
        symLTFRx;
      
        % Channel estimate outputs
        chanEstRaw; 
        chanEst;
        noiseEst;
        snrEst;

        % Equalized symbols
        eqMethod;   % equalization method 
        symEq;      % payload
        symDataEq;  % data

    end

    methods
        function obj = WLANRx(opt)
            % Constructor
            arguments
                opt.ofdmFrameOff {mustBeInteger} = 4;
                opt.eqMethod = 'inversion';
            end

            % Set properties
            obj.ofdmFrameOff = opt.ofdmFrameOff;
            obj.eqMethod = opt.eqMethod;

            % Create the packet configuration
            obj.cfg = wlanNonHTConfig('ChannelBandwidth', 'CBW20');

            % Get the OFDM info
            obj.info = wlanNonHTOFDMInfo('NonHT-Data');

            % Get the number of samples per sym
            obj.nsampSym = obj.info.FFTLength + obj.info.CPLength;

            % Get the sample rate from the
            obj.fsamp = wlanSampleRate(obj.cfg);

        end

        function setPktData(obj, opt)  
            % Sets the packet data for demodulation
            arguments
                obj;
                opt.symLTFTx (52,2);
                opt.nsymData {mustBeInteger};
            end

            obj.symLTFTx = opt.symLTFTx;
            obj.nsymData = opt.nsymData;

        end

        function compChanEstRaw(obj, r, indltf)
            % Compute the raw channel estimate

            % Set the initial timing of the LTF.  We adjust this a little
            % before the strongest detected path to ensure that all the
            % paths are in the CP
            i0 = max(indltf - obj.ofdmFrameOff,1);

            % TODO:  Get the section of the RX signal r
            % corresponding to the LTF.  This should start at i0
            % and will be same length as the LTF field
            %   rlltf = r(...);

            % TODO:  Demodulate the lltf using the ofdmdemod() function.
            % You can get the FFT and CP length from obj.info.  Store
            % the values in obj.symLTFRx
            %    obj.symLTFRx = ofdmdemod(...)
            
            % TODO:  Extract the active indices which are actively used
            % based on obj.info.ActiveFFTIndices.  Store these again in 
            %       obj.symLTFRx = obj.symLTFRx(...,:)

            % TODO:  Compute the raw channel estimate by dividing the RX
            % signal with the TX signal on the LTF.  The resulting matrix,
            % obj.chanEstRaw, should be 52 x 2.
            %    obj.chanEstRaw



        end

        function compChanEst(obj, r, indltf)

            % Compute the raw channel estimate
            obj.compChanEstRaw(r, indltf);
            
            % TODO:  Average chanEstRaw over the two time symbols
            %   chanEstAvg = mean(...)

            % Smooth the channel estimate over frequency using the
            % smoothdata function with 'sgolay' method with a deg
            deg = 4;
            obj.chanEst = smoothdata(chanEstAvg, 'sgolay', deg);

            % Compute the residual error 
            d = obj.symLTFRx - obj.chanEst.*obj.symLTFTx;

            % TODO:  Compute the noise estimate by taking the average
            % of abs(d).^2
            %    obj.noiseEst = ...

            % Compute an estimate of the SNR
            obj.snrEst = mean(abs(obj.symLTFRx).^2, 'all') / obj.noiseEst;
            obj.snrEst = pow2db(obj.snrEst);

            
        end

        function symRx = eqSym(obj,r,indltf)

            % Get the starting sample for the for the payload portion
            i0 = indltf - obj.ofdmFrameOff + obj.nsymPre*obj.nsampSym;
            
            % Get the number of symbols to decode      
            n = length(r);
            nsym = min( floor((n-i0)/obj.nsampSym), obj.nsymData );

            % Find the final sample
            i1 = i0 + obj.nsampSym*nsym-1;
            
            % Get the samples corresponding to the main packet
            r1 = r(i0:i1);

            % TODO:  Perform the OFDM demod on r1 and extract the active
            % FFT indices and store the raw symbols in symRx
            %    symRx = ofdmdemod(...)
            %    symRx = symRx(...)

            % Equalize the symbols 
            if strcmp(obj.eqMethod, 'inversion')
                % TODO:  Inversion method
                %    obj.symEq = ...

            elseif strcmp(obj.eqMethod, 'MMSE')
                % TODO:  MMSE method
                %    obj.symEq = ...
      
            else
                error('Unknown equalization method');
            end

            % TODO:  Extract the equalized data symbols from symEq using the 
            % obj.info.DataIndices
            %    obj.symDataEq = obj.symEq(...)

        end

    end

    methods (Access = protected)

        function stepImpl(obj, r, indltf)
            % Channel estimation and equalization
            obj.compChanEst(r, indltf);
            obj.eqSym(r,indltf);

        end


    end

end