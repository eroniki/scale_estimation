clc; clear all; close all;

rng(9);
x = mvnrnd([0;0], [5 0; 0, 5], 100);

y = [1 1;1 -1;-1 1;-1 -1]*10;

MahalDist = mahal(y,x);
sqEuclidDist = sum((y - repmat(mean(x),4,1)).^2, 2)
plot(x(:,1),x(:,2),'b.',y(:,1),y(:,2),'ro');
chontour(x, y, F(:, :, ii), [.05:.1:.95]);   
 