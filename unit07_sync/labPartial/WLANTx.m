classdef  WLANTx < matlab.System
    % Wireless LAN transmitter class
    properties
        % Packet properties
        psduLen = 512;   % PSDU length in Bytes
        mcs = 3;         % MCS selection
        cfg;             % WLAN Toolbox configuration
        fsamp;           % Sample rate in Hz
    end
    
    methods
        function obj = WLANTx(opt)
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
            obj.fsamp = wlanSampleRate(obj.cfg);
                        
        end
    end
                
    methods (Access = protected)
        function x = stepImpl(obj)
            % step:  Generates a TX WLAN packet
            
            % TODO
            % Generate random bits corresponding to length in obj.psduLen.
            % Note that obj.psduLen is in bytes.
            %
            %    bits = ...
            bits = randi([0,1], obj.psduLen*8,1);
            
            % TODO
            % Generate a packet using wlanWaveformGenerator
            % using bits and obj.cfg
            %
            % xpkt = wlanWaveformGenerator(...)
            x = wlanWaveformGenerator(bits, obj.cfg);
        end              
    end
end