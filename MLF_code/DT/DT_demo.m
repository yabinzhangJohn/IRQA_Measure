% DT_demo

tic
foo = imread('input.pbm');
dt = DT(foo);
dt = dt.^0.5;
toc
% figure; imagesc(dt); axis equal; axis off; colormap gray;
figure; imagesc(dt); axis equal; axis off; 