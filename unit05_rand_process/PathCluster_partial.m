% Rename this file to PathCluster.m
classdef PathCluster < matlab.mixin.SetGetExactNames 
    %FadingPath:  Basic fading path class    
    properties
        % Default values
        pathGaindB = 0;        % Path gain in dB
        npath = 12;            % Number of sub-paths in the cluster
        thetaCenDeg = 0;       % Center AoA in degrees
        thetaSpreadDeg = 10;   % AoA spread in degrees
        vkmph = 3;             % RX velocity (km/h)
        fcGHz = 2.5;           % Carrier freq in GHz
        
        % Derived cluster parameters
        H0 = [];
        phi0 = [];   % Vector of initial phases per path
        theta = [];
        fdHz = [];   % Doppler shift of each path in Hz      
        fdmax = 0;   % maximum Doppler spread
    end
    
    methods
        function obj = PathCluster(varargin)
            % Set properties
            obj.set(varargin{:});
        end
        
        function computeFd(obj)
            % computeFd:  Computes the AoA and Doppler shift of each path
            %
            % TODO
            % obj.phi0 = ...
            % obj.theta = ...
            % obj.fdHz = ...            
            
        end
        
        function h = genFading(obj, tms)
            % genFading:  Generates the fading coefficient of each path
            % 
            % TODO
            % Compute h(k) = fading coefficient at time tms(k)            
        end
        
       
    end
end

