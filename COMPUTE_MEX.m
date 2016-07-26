% mex file SIFT flow matching files

disp('Start the mex ...')

if exist('mexDenseSIFT.mexw64','file')==3
delete('mexDenseSIFT.mexw64');
end

if exist('mexDiscreteFlow.mexw64','file')==3
delete('mexDiscreteFlow.mexw64');
end


cd '.\MEX\mexDenseSIFT'
mex mexDenseSIFT.cpp Matrix.cpp Vector.cpp
mex_file01 = dir('*.mex*');
movefile(mex_file01.name,'..\..\')


cd '..\mexDiscreteFlow'
mex mexDiscreteFlow.cpp BPFlow.cpp Stochastic.cpp
mex_file02 = dir('*.mex*');
movefile(mex_file02.name,'..\..\')
cd '..\..\'

disp('Complete the mex and replacement!')