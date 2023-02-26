# Complex Exponentials, Frequency Estimation and Carrier Frequency Offset

Complex exponentials are the most fundamental signals for all frequency domain
 analysis of linear system.  In this lab you will learn to:
 
* Send a complex exponential or continuous-wave (CW) signal through the SDR
* Estimate the TX and RX frequency from an FFT
* Estimate the carrier frequency offset
* Save data for files for offline processing 

In the graduate version of the lab, students will additionally learn:
* Estimate the gain and frequency via an FFT method with oversampling
* Estimate the complex gain and frequency of a sinusoid via a simple correlation method
* Estimate the gain and frequency via gradient descent

<img src="sinusoidFit.png" alt="sinuoidal fit with correlation" width="350">

## Files:

* `freqUG.mlx`:  The undergraduate version of the lab
* `freqGrad.mlx`:  The graduate version of the lab
* The file `estFreq.m` is a function for computing the estimated frequency.

For the lab, complete the `TODO` sections in both files, run `labFreq.mlx`,
and print to PDF.  Submit the PDF.
