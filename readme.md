# Digital Communications
[Prof. Sundeep Rangan, NYU](http://wireless.engineering.nyu.edu/sundeep-rangan/):


This repository provides instructional material for 
digital communications.  The material is used for 
EL-GY 6013: Digital Communications*, a graduate level class at NYU Tandon.

Anyone is free to use and copy this material (at their own risk!).
But, please cite the material if you use the material in your own class.

## Pre-requisites

The class assumes graduate probability (stochastic processes) and 
undergraduate signals and systems.  
Familiarity with MATLAB or equivalent language is preferred.  

## Using github 
All the files in this repository are hosted on [github](https://github.com/).
If you are not familiar with github, follow our [instructions](./basics/github.md)
for accessing the files.

## Feedback
Any feedback is welcome.  If you find errors, have ideas for improvements,
or want to voice any other thoughts, [create an issue](https://help.github.com/articles/creating-an-issue/)
and we will try to get to it.
Even better, fork the repository, make the changes yourself and
[create a pull request](https://help.github.com/articles/about-pull-requests/)
and we will try to merge it in.  See the [excellent instructions](https://github.com/ishjain/learnGithub/blob/master/updateMLrepo.md)
from the former TA Ish Jain.

## SDR Labs
I am starting to add software-defined radio (SDR) labs.  The labs are based on the
simple, but powerful [ADALM-Pluto boards](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/adalm-pluto.html).
The labs are being migrated from a separate [SDR github repo](https://github.com/sdrangan/sdrlab).


## Sequence
We will add to this section as the class progresses.

* Introduction
    * Course Admin [[pdf]](./Lectures/CourseAdmin.pdf) [[Powerpoint]](./Lectures/CourseAdmin.pptx)
    * [Matlab and SDR Lab](./unit00_intro/lab):  Getting started and transmitting and receiving complex baseband samples
* Unit 1.  Passband modulation
    * Lecture notes [[pdf]](./Lectures/Unit01_Passband.pdf) [[Powerpoint]](./Lectures/Unit01_Passband.pptx)
    * In-Class exercises:  [[Matlab]](./unit01_passband/passbandInclass.mlx) [[Soln]](./unit01_passband/passbandInclassSoln.mlx)
    * Problems [[pdf]](./unit01_passband/prob_passband.pdf) [[Latex]](./unit01_passband/prob_passband.tex)
    * [Matlab and SDR Lab 1.1](./unit01_passband/lab_freq):  Complex exponentials, frequency and carrier offset estimation
    * [Matlab and SDR Lab 1.2](./unit01_passband/lab_passband):  Up- and down-conversion 
* Unit 2.  Symbol mapping and transmit filtering
    * Lecture notes [[pdf]](./Lectures/Unit02_TxFilter.pdf) [[Powerpoint]](./Lectures/Unit02_TxFilter.pptx)
    * In-Class exercises:  [[Matlab]](./unit02_tx_filter/txInClass.mlx) [[Soln]](./unit02_tx_filter/txInClassSoln.mlx)
    * Problems [[pdf]](./unit02_tx_filter/prob_tx_filter.pdf) [[Latex]](./unit02_tx_filter/prob_tx_filter.tex)
    * [MATLAB and SDR Lab](./unit02_tx_filter/lab/): Symbol Mapping and TX Filter design
* Unit 3.  Receive filtering    
    * Lecture notes [[pdf]](./Lectures/Unit03_RxFilter.pdf) [[Powerpoint]](./Lectures/Unit03_RxFilter.pptx)
    * In-Class exercises:  [[Matlab]](./unit03_rx_filter/rxFiltInClass.mlx) [[Soln]](./unit03_rx_filter/rxFiltInClassSoln.mlx)
    * Problems [[pdf]](./unit03_rx_filter/prob_rx_filter.pdf) [[Latex]](./unit03_rx_filter/prob_rx_filter.tex)
    * [MATLAB and SDR Lab](./unit03_rx_filter/lab):  Simulating and sounding a multi-path channel
* Unit 4.  Signal space theory
    * Lecture notes [[pdf]](./Lectures/Unit04_SignalSpace.pdf) [[Powerpoint]](./Lectures/Unit04_SignalSpace.pptx)
    * Problems [[pdf]](./unit04_sig_space/prob_sig_space.pdf) [[Latex]](./unit04_sig_space/prob_sig_space.tex)
* Unit 5.  Random process review
    * Lecture notes [[pdf]](./Lectures/Unit05_RandProc.pdf) [[Powerpoint]](./Lectures/Unit05_RandProc.pptx)
    * Problems [[pdf]](./unit05_rand_process/prob_rand_proc.pdf) [[Latex]](./unit05_rand_process/prob_rand_proc.tex)
    * MATLAB exercise:  [Simulating Rayleigh fading](./unit05_rand_process/lab_rayleigh_partial.m)
* Unit 6.  Symbol demodulation and error analysis
    * Lecture notes [[pdf]](./Lectures/Unit06_Demod.pdf) [[Powerpoint]](./Lectures/Unit06_Demod.pptx)
    * In-Class exercises:  [[Matlab]](./unit06_demod/demodInClass.mlx) [[Soln]](./unit06_demod/demodInClassSoln.mlx)
    * Problems [[pdf]](./unit06_demod/prob_demod.pdf) [[Latex]](./unit06_demod/prob_demod.tex)
    * MATLAB exercise:  [QAM Demodulation](./unit06_demod/labQamdemod.m)    
* Unit 7.  Synchronization and match filtering
    * Lecture notes [[pdf]](./Lectures/Unit07_Sync.pdf) [[Powerpoint]](./Lectures/Unit07_Sync.pptx)
    * In-Class exercises:  [[Matlab]](./unit07_sync/syncInClass.mlx) [[Soln]](./unit07_sync/syncInClassSoln.mlx)
    * Problems [[pdf]](./unit07_sync/prob_sync.pdf) [[Latex]](./unit07_sync/prob_sync.tex)    
    * [SDR Lab](https://github.com/sdrangan/sdrlab/tree/main/lab05_gain):  Gain control and building a simple AGC.
    * MATLAB and SDR lab:  [802.11 packet detection and synchronization](./unit07_sync/labPartial/)
* Unit 8.  Equalization
    * Lecture notes [[pdf]](./Lectures/Unit08_Equalization.pdf) [[Powerpoint]](./Lectures/Unit08_Equalization.pptx)
    * Problems [[pdf]](./unit08_ofdm/prob_ofdm.pdf) [[Latex]](./unit08_ofdm/prob_ofdm.tex)
    * MATLAB and SDR lab:  [802.11 channel estimation and equalization](./unit08_ofdm/labPartial)
* Unit 9.  Linear codes
* Unit 10.  Convolutional codes
    * Lecture notes [[pdf]](./Lectures/Unit10_ConvCodes.pdf) [[Powerpoint]](./Lectures/Unit10_ConvCodes.pptx)
    * In-Class exercises:  [[Matlab]](./unit10_conv/convInClass.mlx) [[Soln]](./unit10_conv/convInClassSoln.mlx)
    * Problems:  [[pdf]](./unit10_conv/prob_conv.pdf) [[Latex]](./unit10_conv/prob_conv.tex)
    * MATLAB:  To be added
* Unit 11.  Information theory
    * Lecture notes [[pdf]](./Lectures/Unit11_Capacity.pdf) [[Powerpoint]](./Lectures/Unit11_Capacity.pptx)
    * Problems:  [[pdf]](./unit11_capacity/prob_it.pdf) [[Latex]](./unit11_capacity/prob_it.tex)
* Unit 12.  LDPC codes
    * Lecture notes [[pdf]](./Lectures/Unit12_LDPC.pdf) [[Powerpoint]](./Lectures/Unit12_LDPC.pptx)


