function [nuest, cest, Jhist] = estFreq(r, options)
% estFreq:  Estimates the frequency of a complex exponential
%
% Given a signal r[n] = c*exp(2*pi*1i*nu*n) + noise
% the function attempts to estimate the normalized digital frequency, nu,
% and the complex amplitude c.
%
% Parameters
% ----------
% method:  method for estimating the frequency
%    'correlation', 'fft' or 'grad' for correlation,  
%    FFT or gradient descent method
% oversample:  Oversampling ratio in the FFT method
% nit:  number of iterations for gradient descent
% stepinit:  initial step size in gradient descent
%
% Returns
% -------
% nuest:  Estimated normalized digital frequency
% cest:  Estiamted complex amplitude
% Jhist:  For gradient descent, returns the cost function for each
%     iteration
arguments
    r (:,:) double;
    
    options.method char ...
        {mustBeMember(options.method,{'correlation','fft','grad'})} ...
        = 'correlation';      
    options.oversample (1,1) {mustBeInteger} = 1;
    options.nit (1,1) {mustBeInteger} = 100;
    options.stepinit (1,1) = 1e-7;   

end

% Get dimensions
[nr,ncol] = size(r);

% Default objective function history
Jhist = [];

if strcmp(options.method, 'correlation')

    % TODO:  Complete the correlation method
    %   nuest = ...

    z = mean(r(2:nr,:).*conj(r(1:nr-1,:)));
    nuest = angle(z)/2/pi;

elseif strcmp(options.method, 'fft')

    % TODO:  Estimate the digital freq via an FFT
    %   nuest = ...
    % First, implement this without oversampling.
    % Then, implement it with oversampling.

    % Perform the oversampling
    rov = zeros(nr*options.oversample,ncol);
    rov(1:nr,:) = r;
 
    % Compute the FFT magnitude
    R = abs(fft(rov));

    % Estimate the frequency from the peak
    [~,im] = max(R);
    nuest = (im-1)/nr/options.oversample;

    % Make nuest \in [-0.5,0.5]
    nuest = nuest - (nuest > 0.5);

elseif strcmp(options.method, 'grad')
    % This section is for gradient descent.
    % We do not cover it in the class, but advanced students can try to
    % implement a version.  I used a simple Armijo-rule based gradient
    % descent.
    nit = options.nit;
    step = options.stepinit;

    % Initialize with the FFT method and an oversample ratio
    nuinit = estFreq(r, method='fft', oversample=4);
    Jhist = zeros(nit,1);


    for it = 1:nit

        % Take a candidate frequency estimate
        if it == 1
            nu1 = nuinit;
        else
            nu1 = nu - step*Jgrad;
        end

        % TODO:  Compute estimate of the amplitude at nu1:
        %   c = ...
        %   rhat1 = ....

        % TODO:  Measure MSE and gradient at the candidate point
        %    J1 = ....
 
        % TODO:  Compute the gradient of the cost function with 
        % respect to mu
        %    Jgrad1 = ...
        

        % Use Armijo rule to see if cost function decreased sufficiently        
        if (it==1)
            accept = true;
        else
            accept = (J1 <= J + 0.5*Jgrad*(nu1-nu));
        end

        if accept
            % Accept point.  Increase step size
            nu = nu1;
            J = J1;
            Jgrad = Jgrad1;
            step = step*2;
        else
            % Reject point, decrease step size
            step = max(0.5*step, 1e-8);
        end

        % Save history
        Jhist(it) = J;        
    end
    nuest = nu;

else
    error('Unknown method %s', options.method)
end

% TODO:  Fit the complex gain


end