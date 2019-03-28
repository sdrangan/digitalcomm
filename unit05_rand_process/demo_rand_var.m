%% Demo:  Discrete Random Variables
% MATLAB has several excellent routines for generating discrete random
% variables.  The following code provides some simple examples

%% Generate a discrete uniform distribution
% The following code generates |n = 1000| samples uniformly on |[1,nvals]|
nvals = 5;
n = 1000;
x = unidrnd(nvals, [n,1]);

%%
% We can then print the first 10 samples to see the typical results:
disp(x(1:10)');

%% 
% The above code generates random variables on |[1,nvals]|.  The following
% code generates values on an artbitrary set:
vals = [1,2,4,6,10]';
ind = unidrnd(nvals, [n,1]);
x = vals(ind);

disp(x(1:10)');


%% Measuring the empirical PMF
% We can also estimate the empirical PMF by converting x to a 'categorical'
% array and then using the <matlab:doc('histcounts') histcounts> function. 

% Get counts in each value
cnts = histcounts(categorical(x), categorical(vals));

% Estimate sample frequency
psamp = cnts' / n;
punif = ones(nvals,1)/nvals;
disp(psamp)

%% Plotting the CDF
% We can plot the sample frequency and uniform PMF via the bar graph
bar(vals, [psamp punif]);
grid();
xlabel('Value');
ylabel('PMF');
legend('sample freq', 'uniform');


%% Generating an arbitrary distribution
% MATLAB has no command to generate from an arbitray PMF.  But, you can
% generate the random variables as follows:

% A PMF where P(X=val(i)) \propto exp(-i)
vals  = [0,1,2,4,8]';
ptrue = [0.5,0.3,0.1,0.06,0.04]';
nvals = length(vals);

% Compute the CDF
pcdf = [0; cumsum(p)];

% Generate the random samples
[~,ind] = histc(rand(n,1),pcdf);
x = vals(ind);

disp(x(1:10)');

% Get counts in each value
cnts = histcounts(categorical(x), categorical(vals));

% Estimate sample frequency
psamp = cnts' / n;

% Plot the sample frequency
bar(vals, [psamp ptrue]);
grid();
xlabel('Value');
ylabel('PMF');
legend('sample freq', 'true PMF');

%% Exponential random variable
% Now, we consider a continuous random variable:  
% We generate 1000 samples of an exponential with |mu = 2|.
mu = 2;
n = 1000;
x = exprnd(mu,[n,1]);

% Plotting the histogram
nbins = 20;
[cnts,edges] = histcounts(x,nbins);
binCenter = (edges(1:nbins)+edges(2:nbins+1))/2;
bar(binCenter, cnts);
xlabel('x');
ylabel('Counts');
set(gca,'Fontsize',16);

%% Estimating the PDF
% We can estimate the PDF via 
%    pest(x) = fraction of samples in bin/bin width
binWid = edges(2)-edges(1);
pest = cnts/n/binWid;

% Compute true PDF
xplot = linspace(0,5*mu,100)';
ptrue = exppdf(xplot,mu);

% Plot
bar(binCenter, pest);
hold on;
plot(xplot,ptrue,'-','Linewidth',3);
grid();
hold off;
legend('Estimate', 'True');
set(gca,'Fontsize',16);



