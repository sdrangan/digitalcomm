classdef  WLANRx < matlab.mixin.SetGetExactNames
    properties
        % Packet properties
        psduLen = 2048;  % PSDU length in Bytes
        mcs = 3;         % MCS selection
        cfg;             % WLAN Toolbox configuration
        fsampMHz;        % Sample rate in MHz
        
        % Preamble components
        lstf;   % Legacy STF (short training field)
        lltf;   % Legacy LTF (long training field)
        
        % Detection results
        tSTF = 0.25;    % STF threshold
        rhoSTF;     % STF correlation
        pktFound;   % Flag indicating if packet was found
        istf;       % Index of the sample on which STF was found
        rhoLTF;     % LTF correlation
        iltf;       % Index of the sample on which the LTF was found
        
    end
    
    methods
        function obj = WLANRx(varargin)
            % Constructor
            
            % Set properties
            if ~isempty(varargin)
                obj.set(varargin{:});
            end
            
            % Create the packet configuration
            obj.cfg = wlanNonHTConfig('ChannelBandwidth', 'CBW20', ...
                'PSDULength', obj.psduLen,'MCS',obj.mcs);
            
            % Save the sample rate
            obj.fsampMHz = wlanSampleRate(obj.cfg)*1e-6;
            
            % Compute the preamble components
            obj.compPreamble();
            
        end
        
        function compPreamble(obj)
            % Computes the preamble components
            
            % TODO:  Compute the LSTF and LLTF components of the premable
            % using the wlanLSTF and wlanLLTF methods.  Store them in
            % obj.lstf and obj.lltf.
            
        end
        
        
        function STFcorr(obj, r)
            % Detects the STF using cyclic correlation.  This can be
            % performed with the following operations.
            %
            %    rprod(i) = r(i)*conj(r(i+per))
            %    rabs(i) = abs(r(i))^2
            %    u0(i) = abs( sum_{j=0}^{len-1} rprod(i+j) )^2
            %    u1(i) = sum_{j=0}^{len-1} rabs(i)
            %    u2(i) = sum_{j=0}^{len-1} rabs(i+per)
            %    rhoSTF(i) = u0(i)/(u1(i)*u2(i) + tol)
            
            % Get parameters
            nsamp = length(r);
            period = 16;
            len = length(obj.lstf)-16;
            tol = 1e-8;
            
            % TODO:  Implement the cyclic correlation algorithm and 
            % store the correlation rhoSTF in obj.rhoSTF.
            
        end
        
        function STFdetect(obj)
            % Tests if a packet is present from the STF correlation.
                        
            % TODO: Set obj.pktFound to 1 if there is at least one location
            % i such that obj.rhoSTF(i) > obj.tSTF, the detection
            % threshold.  Otherwise set obj.pktFound = 0.
            %
            % If a packet is found set obj.istf = to the first location i
            % where obj.rhoSTF(i) > obj.tSTF.  
            
        end
        
        function pktDetect(obj, r)
            % Packet detection and initial timing synchronizations
            
            % Run the STF correlation
            obj.STFcorr(r);
            
            % Detect the presence of the packet
            obj.STFdetect();
            if ~obj.pktFound
                return;
            end
            
            % The STF is not exact.  So, we need to search for the true
            % initial location over a range of symbols.  We will use a
            % range = 2*premable length.
            len = 2*(length(obj.lstf) + length(obj.lltf));
            
            % TODO:  Extract the symbols to perform the LTF correlation.
            % Set r1 to be the vector of samples in r starting from
            % i = obj.istf, ..., obj,istf+len.  This is a range of possible
            % locations for the true beginning of the packet.
            % 
            %    r1 = r(...)            
            

            % TODO:  Correlate the extracted samples in r1 with LLTF in
            % obj.lltf.  Use the xcorr method.  Store the absolute value of
            % the correlation in obj.rhoLTF.
            %
            %   obj.rhoLTF = ...
            
            
            % TODO:  Find the location of the maximum in obj.rhoLTF.  Add
            % the estimated to location to obj.istf.  Store in obj.iltf.
            % This is the estimated start of the packet.
            %
            %    obj.iltf = ...
                                   
        end
            
            
    end
end