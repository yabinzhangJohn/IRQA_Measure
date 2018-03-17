 Image Retargeting Quality Assessment
=====================

Matlab implementation of **ARS** and **MLF** image retargeting quality assessment measures based on the following three papers.
  - Aspect Ratio Similarity (ARS) for Image Retargeting Quality Assessment. ICASSP 2016
  - Backward Registration-Based Aspect Ratio Similarity for Image Retargeting Quality Assessment. TIP 2016
  - Multiple-Level Feature-Based Measure for Retargeted Image Quality. TIP 2018

The code has been tested on the Windows 10 64-bit OS. To run the code, you need to prepare the [MIT RetargetMe dataset](http://people.csail.mit.edu/mrub/retargetme/) first.
* [**ARS_code**](ARS_code) is the implementation of **ARS** measure. You can run [**MIT_ARS_main.m**](ARS_code/MIT_ARS_main.m) to obtain the results. If the mex files are incompatible, run the [**COMPUTE_MEX.m**](ARS_code/COMPUTE_MEX.m) to update the existing mex files. It may take around 1.2 hours on Win 10 (i7-6700 @3.4GHz and 16GB ram). On Xeon processors, [**BWRegistration**](ARS_code/BWRegistration) may output slightly different matching results and lead to inconsistent prediction performance compared with that reported in the papers. In this case, you can use the calculated [**All_XX and All_Y**](precomputed_BR/BR_results.mat) to replace the backward registration results.
* [**MLF_code**](MLF_code) is the implementation of **MLF** measure. You can run [**MIT_MLF_main.m**](MLF_code/MIT_MLF_main.m) to obtain the results. The MLF_code is dependent on the ARS_code, and you need to be able to run [**ARS_code**](ARS_code) at first. It may take around 2.1 hours on Win 10 (i7-6700 @3.4GHz and 16GB ram).
