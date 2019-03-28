%% Lab:  Simulating a Rayleigh Fading Process
% Rayleigh fading is an important process in wireless communications.  In
% this lab, we will generate a fading trajectory as an example of random
% process.  In doing this lab, you will learn to:
%
% * Simulate a simple Rayleigh fading wireless channel
% * Organize simulations in an object-oriented format
% * Generate random realizations of a random process described by
% parameters
% * Measure the autocorrelation of a random process
% * Compute the theoretical autocorrelation using numerical integration

%% Rayleigh Fading Theory
% Rayleigh fading occurs when a receiver sees the same signal from multiple
% paths that arrive at different delays and angles of arrivals.  
% When the receiver moves in such a multi-path environment,
% it will experience a time-varying complex channel gain of the form:
%
%    h(t) = sqrt(H0/npath)* \sum_k exp(i*(phi0(k) + 2*pi*fdHz(k)*t)
% 
% where |npath| is the number of paths, and |phi0(k)| and |fdHz(k)| 
% are the phase (in radians) and Doppler shift (in Hz) 
% of the |k|-th path and |H0| is the path power gain in linear scale.  
% The Doppler shifts are given by:
%
%    fdHz(k) = fdmaxHz*cos(theta(k))
%    fdmaxHz = v/vc*fc
% 
% where |theta(k)| is the angle of arrival of the |k|-th path relative
% to the direction of motion, |v| is the receiver velocity in m/s;
% |vc=3e8| is the speed of light and |fc| is the carrier frequency in Hz.
% The fluctuation of the gain due to constructive and destructive
% interference between paths is one of the central challenges in wireless
% communication.

%% Simulation parameters
% In this lab, we will simulate what is called a single *path cluster*, 
% where a large number of paths arrive with slightly different angles of
% arrival (AoAs) but similar time delays.  Typically, a path cluster occurs
% whenever there is a diffuse reflection causing scattering of the paths.  
% We will simulate the path cluster with following parameters:
clear all;
npath = 100;           % Number of sub-paths in the cluster
thetaCenDeg = 0;       % Center AoA in degrees
thetaSpreadDeg = 10;   % AoA spread in degrees
pathGaindB = -10;      % Path gain in dB
vkmph = 30;            % RX velocity (km/h)
fcGHz = 28.0;          % Carrier freq in GHz


%% Creating a PathCluster object
% When performing complex simulations, it is useful to write the code in an
% object-oriented manner.  For this lab, a skeleton file, 
% |PathCluster_partial.m| has been included.  Copy the file and rename it as
% |PathCluster.m|.  The |properties| and constructor are already completed.
% You will fill in the remaining parts.  Note that if you edit the 
% |PathCluster| object, you will need to clear the environment to 
% ensure that MATLAB reloads the new version:
%
%     clear PathCluster
%
% For this section, you do not need to modify |PathCluster.m|.  
% You just need to create an instance of the class with a command of the
% form:
%
%     cluster = PathCluster('prop1', val1, 'prop2', val2, ...)

% TODO: 
%
% * Create a |cluster| object and set the parameters of the cluster
% * Print the properties using |disp(cluster)| to ensure the properties are
% set


%% Compute path cluster parameters
% Now, modify the |computeFd| method in the |PathCluster| class to generate
% random AoA and Doppler shifts for the paths.
% 
% * Set |theta(k) =| Gaussian with mean thetaCenDeg and 
%   std. dev thetaSpreadDeg.  Convert to radians
% * Set |phi0(k) =| uniform between 0 and 2*pi
% * set |fdHz(k) =| Doppler shift with the formula in the Theory section.
% % Set |H0 =| path gain in linear scale from |pathGaindB|

% TODO:
% 
% * Modify the |computeFd()| method
% * Run |cluster.computeFd()| 
% * Plot the locations of Doppler spreads


%% Generate a random fading trajectory
% Next, complete the code in 
% TODO:
%
% * Complete the code in the method |genFading()|.
% * Run the code for 1024 time points over 0.1 sec.
% * Plot the channel gain in dB.



%% Measure the autocorrelation
% Now, we will measure the autocorrelation.  Accurate estimation of the
% autocorrelation requires large numbers of samples.  
%
% TODO:  Generate a random trajectory of |h(t)| with 
% |nt=2^16| samples at a sampling period of |tsamp = 0.1| ms.

% nt = 2^16;
% tsamp = 0.1;
% h = ...


% Use the |xcorr| function to estimate the autocorrelation at |nlags=1000|
% lags.  Use the |'unbiased'| scaling option.  
%
% TODO
% nlags = 1000;
% [rh, lags] = xcorr(...);


% TODO:  Plot the magnitude of the estimated autocorrelation as a 
% function of the time lag.


%% 
% The time it takes the process to be uncorrelated is called the
% *coherence* time of the channel.  Within the coherence time, the channel
% does not vary significantly.  This time is important for various
% procedures in wireless communication such as channel estimation.

%% Compute the theoretical autocorrelation
% Finally, we will compare the measured auto-correlation with the
% theoretical value.  When the number of paths is large, the
% auto-correlation should approximately be:
%
%     R(tau) = H0*\int exp(2*pi*1i*fdmax*tau*cos(theta))*p(theta)dtheta,
%
% where |p(theta)| is the PDF on the AoA's theta.  This integral has no 
% closed form expression.  So, it needs to be evaluated numerically.  You
% can do this in MATLAB with the function |integral| where you supply it a
% function pointer to the integrand.
%
% TODO:
% 
% * Using numerical integration compute the theoretical autocorrelation
% |R(tau)| above for 200 values of |tau| in [-100,100] ms.
% * Plot the theoretical autocorrelation vs. tau on the same graph as the
% estimated autocorrelation.  There may be a significant difference since
% the estimate autocorrelation was computed with only 100 paths.


