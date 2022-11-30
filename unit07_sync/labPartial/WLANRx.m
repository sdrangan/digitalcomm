classdef  WLANRx <  matlab.System
    properties
        % Packet properties
        psduLen = 2048;  % PSDU length in Bytes
        mcs = 3;         % MCS selection
        cfg;             % WLAN Toolbox configuration
        fsamp;        % Sample rate in MHz

        % Preamble components
        lstf;   % Legacy STF (short training field)
        lltf;   % Legacy LTF (long training field)

        % Packet length including the preamble in samples
        pktLen = 0; 

        % Detection results
        tSTF = 0.25;    % STF threshold
        rhoSTF;     % STF correlation
        pktFound;   % Flag indicating if packet was found
        istf;       % Index of the sample on which STF was found
        rhoLTF;     % LTF correlation
        iltf;       % Index of the sample on which the LTF was found
        snrDetected;  % SNR of detected packet in dB

    end

    methods
        function obj = WLANRx(opt)
            % Constructor
            arguments
                opt.psduLen (1,1) {mustBeInteger} = 512;
                opt.mcs (1,1) {mustBeInteger} = 3;
            end

            % Set properties
            obj.psduLen = opt.psduLen;
            obj.mcs = opt.mcs;

            % Create the packet configuration
            obj.cfg = wlanNonHTConfig('ChannelBandwidth', 'CBW20', ...
                'PSDULength', obj.psduLen,'MCS',obj.mcs);

            % TODO:  Get the sample rate from the
            % wlanSampRate function using obj.cfg.
            %      obj.fsamp = wlanSampleRate(obj.cfg)            

            % Compute the preamble components
            obj.compPreamble();

        end

        function compPreamble(obj)
            % Computes the preamble components

            % TODO:  Compute the LSTF and LLTF components of the premable
            % using the wlanLSTF and wlanLLTF methods.  Store them in
            % obj.lstf and obj.lltf
            %   obj.lstf = wlanLSTF(...);
            %   obj.lltf = wlanLLTF(...);            
        end


        function detectSTF(obj, r)
            % Detects the STF using cyclic correlation.  

            % Since we only want to perform detection on the samples 
            % at the beginning of the packet, we remove samples from the 
            % end.  This will ensure that after the pre-amble is detected,
            % we can decode the remainder of the packet
            sampsToRemove = max(0, obj.pktLen - length(obj.lstf) - length(obj.lltf));
            r = r(1:length(r)-sampsToRemove);

            % Get parameters
            n = length(r);
            period = 16;
            len = length(obj.lstf);
            tol = 1e-8;

            % TODO:  Compute rhoSTF as described in wlanPreamble.mlx
            %   obj.rhoSTF = ...
            
            % TODO: Find the maximum and location of the maximum
            % correlation
            %    rhoMax = max(obj.rhoSTF)
            %    obj.istf = index i where obj.rhoSTF(i) is maximum
            
            % TODO:  obj.pktFound to 1 if rhoMax > obj.tSTF.  Otherwise                       
        end

        function pktDetect(obj, r)
            % Packet detection and initial timing synchronization

            

            % Run the STF correlation and detection
            obj.detectSTF(r);

            % Exit if no packet is found.
            if ~obj.pktFound
                return;
            end

            % The STF is not exact.  So, we need to search for the true
            % initial location over a range of symbols.  The code below
            % extracts data from a range of r around the detected
            % STF.
            n = length(r);
            i1 = max(obj.istf - length(obj.lstf),1);
            i2 = min(obj.istf + 4*length(obj.lltf), n);
            r1 = r(i1:i2);

            % TODO:  Compute the un-normalized MF of the partial RX signal
            % r1 with the target, obj.lltf;
            %    z = conv(...)         
                        
            % TODO:  Compute the correlation squared
            %    tol = 1e-8;
            %    Er = ...  
            %    Ex = ...
            %    obj.rhoLTF = ...


            % TODO:  Find the location of the maximum in obj.rhoLTF.  Add
            % the estimated to location to obj.istf.  Store in obj.iltf.
            % This is the estimated start of the packet.
            %
            %    obj.iltf = ...            


            % Add the initial point
            obj.iltf = i1 + obj.iltf;

        end


    end
end