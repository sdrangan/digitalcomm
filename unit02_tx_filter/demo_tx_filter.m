%% Demo:  Symbol mapping and TX Filtering

%% QPSK mapping

% Print the constellation table
M = 4;
sym_ind = (0:M-1);
sym = qammod(sym_ind,M);
for i = 1:M
    fprintf(1, 'ind=%d sym: (%7.2f, %7.2f)\n', sym_ind(i), ...
        real(sym(i)), imag(sym(i)));
end

% Encode 8 random bits to 4 symbols
nbits = 8;
bits = randi([0,1],nbits,1);
sym = qammod(bits,M,'InputType','bit');

disp('');
disp('bits = ');
disp(bits');
disp('');
disp('sym = ');
disp(sym.');

%% Example of sinc filtering
% This is a special case of 
sps = 16;
span = 8;
len = span*sps+1;
t = (0:len-1)'/sps-span/2;
bfilt = sinc(t);
nbits = 1024;
M = 2;
bits = randi([0,1],nbits,1);
sym = qammod(bits,M,'InputType','bit');
nsym = length(sym);

symUp = upsample(sym,sps);
u = filter(bfilt,1,symUp);

nsamp = length(u);
t = (0:nsamp-1)'/sps;

nplot = 50;
plot(t(1:nplot*sps),u(1:nplot*sps),'Linewidth',2);
tsym = ((0:nplot-1)+span/2);
hold on;
plot(tsym,sym(1:nplot),'o', 'Linewidth', 3);
xlim([0, nplot]);
hold off;
xlabel('Symbol time');
grid on;


%% Example of raised cosine filtering
sps = 16;
betaTest = [0,0.25,0.992];
nbeta = length(betaTest);

nbits = 1024;
M = 2;
bits = randi([0,1],nbits,1);
sym = qammod(bits,M,'InputType','bit');
nsym = length(sym);

symUp = upsample(sym,sps);

for ibeta = 1:nbeta
    beta = betaTest(ibeta);
    span = 8;
    bfilt = rcosdesign(beta,span,sps);
    bfilt = bfilt'/max(bfilt);
       
    
    u = filter(bfilt,1,symUp);
    nsamp = length(u);
    t = (0:nsamp-1)'/sps;

    h = subplot(nbeta,1,ibeta);
    nplot = 50;
    plot(t(1:nplot*sps),u(1:nplot*sps),'Linewidth',2);
    tsym = ((0:nplot-1)+span/2);
    hold on;
    plot(tsym,sym(1:nplot),'o', 'Linewidth', 3);
    xlim([0, nplot]);
    hold off;
    titleStr = sprintf('beta = %7.2f', beta);
    title(titleStr);
    grid on;
    
end




