 Image Retargeting Quality Assessment
=====================

Matlab implementation of continuous relaxation of **ARS** and **MLF** image retargeting quality assessment measures based on the following three papers.
  - Aspect Ratio Similarity (ARS) for Image Retargeting Quality Assessment. ICASSP 2016
  - Backward Registration-Based Aspect Ratio Similarity for Image Retargeting Quality Assessment. TIP 2016
  - Multiple-Level Feature-Based Measure for Retargeted Image Quality. TIP 2018

The code has been tested on the Windows 7 64-bit OS. To run the code: prepare the [MIT RetargetMe dataset](http://people.csail.mit.edu/mrub/retargetme/) dataset first.
* [**ARS_code**](ARS_code) is the implementation of **ARS** measure. You can run [**MIT_ARS_main.m**](ARS_code/MIT_ARS_main.m) to obtain the results. If the mex files are incompatible, run the [**COMPUTE_MEX.m**](ARS_code/COMPUTE_MEX.m) to update the existing mex files. It may take around 1.5 hours on Win 7 (i5 @3.2GHz and 16GB ram).
* [**MLF_code**](MLF_code) is the implementation of **MLF** measure. You can run [**MIT_MLF_main.m**](MLF_code/MIT_MLF_main.m) to obtain the results. The MLF_code is dependent on the ARS_code.
