classdef  WLANTx < matlab.mixin.SetGetExactNames
    properties
        % Packet properties
        psduLen = 512;   % PSDU length in Bytes
        mcs = 3;         % MCS selection
        cfg;             % WLAN Toolbox configuration
        fsamp;           % Sample rate in Hz
    end
    
    methods
        function obj = WLANTx(varargin)
            % Constructor
            
            % Set properties
            if ~isempty(varargin)
                obj.set(varargin{:});
            end
                        
            % Create the packet configuration
            obj.cfg = wlanNonHTConfig('ChannelBandwidth', 'CBW20', ...
                'PSDULength', obj.psduLen,'MCS',obj.mcs);
            
            % TODO:  Get the sample rate from the 
            % wlanSampRate function using obj.cfg.              
            %      obj.fsamp = wlanSampleRate(obj.cfg)
            
                        
        end
                
        function xpkt = genTxPkt(obj)
            % genTxPkt:  Generates a TX WLAN packet
            
            % TODO
            % Generate random bits corresponding to length in obj.psduLen.
            % Note that obj.psduLen is in bytes.
            %
            %    bits = ...
            
            
            % TODO
            % Generate a packet using wlanWaveformGenerator
            % using bits and obj.cfg
            %
            % xpkt = wlanWaveformGenerator(...)
            
        end              
    end
end