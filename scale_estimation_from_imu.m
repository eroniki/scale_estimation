clc; clear all; close all;
k = 1:4;
t_gt = [3, 4; 3, 3; 4, 2; 5, 1];

pose = cumsum(t_gt);
pose = [0, 0; pose];
Sigma = [2.5 3; 3 10]/10;
imu_mean = t_gt + normrnd(0, 1, [numel(k), 2])/5;
imu_odom = cumsum(imu_mean);
vo_mean = t_gt + normrnd(0, .3, [numel(k), 2]);
vo_odom = normr(vo_mean);
% vo_odom_pose = pose(2:end, :)+vo_odom;
F = zeros(100, 100, numel(k));
for ii = 1:numel(k)
    Sigma_k = Sigma*k(ii)^2/3;
    [xy_min] = min(pose);
    [xy_max] = max(pose);
    x = linspace(xy_min(1), xy_max(1), 100);
    y = linspace(xy_min(2), xy_max(2), 100);

    [X,Y] = meshgrid(x,y);
    F_ = mvnpdf([X(:) Y(:)], imu_odom(ii, :), Sigma_k);
    F(:, :, ii) = reshape(F_,length(y),length(x));
end

%% Estimate scaler
d_total = [];
for ii=1:1
    for lambda=1:0.2:2
        xx = sum(F(:, :, ii), 1);
        yy = sum(F(:, :, ii), 2);
        dist = [xx', yy];
        d = mahal(lambda*vo_odom(ii, :), dist);
        d_total = [d_total, d];
    end
end
plot(d_total);
%% Plot
figure(1);
scatter(pose(:, 1), pose(:, 2), 'k'); hold on;
plot(pose(:, 1), pose(:, 2), 'k-.>');
for ii=1:numel(k)
    contour(x, y, F(:, :, ii), [.05:.1:.95]);   
    quiver(pose(ii, 1), pose(ii, 2), vo_odom(ii, 1), vo_odom(ii, 2), 'r');
end
legend('loc', 't (gt)', 'imu', 'vo', 'Location', 'SouthEast');
grid on; grid minor;
axis equal;
