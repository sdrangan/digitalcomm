classdef WLANPktAnalyzer <  matlab.System
    % Class for demodulating a transmitted waveform without noise
    % We use this class for extracting the true transmitted symbols
    % and other parameters

    properties
        info;  % OFDM info
        nsampSym;  % number of samples per OFDM symbol

        % Hard-coded constants based on the WLAN spec
        nsymLSTF = 2;  % number symbols in the legacy STF field
        nsymLLTF = 2;  % number symbols in the legacy LTF field
        nsymPre = 5;   % total number of symbols in pre-amble

        % Indices for the pilots and data within the payload
        Idata;
        Ipilot;

        % Extracted fields
        sym;     % OFDM modulation symbols over preamble and payload
        symLTF;  % L-LTF OFDM modulation symbols
        symData; % Data symbols
        symPilot;  % Pilots symbols
        

    end

    methods
        function obj = WLANPktAnalyzer()
            % Constructor            

            % Get the OFDM info
            obj.info = wlanNonHTOFDMInfo('NonHT-Data');

            % TODO:  Using the FFTLength and CPLength fields in obj.info,
            % get the number of samples per OFDM symbol
            %    obj.nsampSym = ...
 
        end

        function extractLTFSym(obj, x)
            % TODO:  Use the ofdmdemod function to extract the OFDM symbols
            % from x.  You can get the FFTLength and CPLength from
            % obj.info
            %    obj.sym = ofdmdemod(...);
  
            % TODO: Extract the symbols on the active sub-carriers with
            % the obj.info.ActiveFFTIndices field.
            %    obj.sym = obj.sym(...,:);

            % TODO:  Get the symbols for the LTF field. Recall that the LTF
            % field is on symbols 3 and 4 (the two symbols after the STF)
            %    obj.symLTF = obj.sym(...);

        end

        function extractPayloadSym(obj)

            % TODO:  From the array obj.sym, Get the modulations symbols for the
            % payload.  The payload starts at obj.nsymPre+1
            %    symPayload = obj.sym(...)

            % TODO:  Get the symbols for pilots and data using the
            % obj.info.PilotIndices and obj.info.DataIndices arrays
            %    obj.symPilot = symPayload(...);
            %    obj.symData = symPayload(...);
            

        end
    end


    methods (Access = protected)
        function stepImpl(obj,x)
            % Step function:  Extact the OFDM modulation symbols for the
            % LTF and payload fields

            % Extract the LTF symbols
            obj.extractLTFSym(x);

            % Extract the payload symbols
            obj.extractPayloadSym();

        end
    end
end