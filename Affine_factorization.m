folder_name = 'assignment4_part2_data/';
D = importdata(strcat(folder_name, 'measurement_matrix.txt'));

%centering
[m, n] = size(D);
norm_D = zeros(m, n);
for i = 1:m
    norm_D(i,:) = D(i,:) - mean(D(i,:));
end

[U, S, V] = svd(norm_D);
U3 = U(:, 1:3);
W3 = S(1:3, 1:3);
V3 = V';
V3 = V3(1:3, :);
M = U3*W3^(1/2);
S = W3^(1/2)*V3;

%show 3d
figure()
plot3(S(3,:),S(2,:),S(1,:), '.');

%conpute residual
estimated_D = M*S;
per_frame_residual = zeros(m/2, 1);
for i = 1:m/2
    for j = 1:n
        per_frame_residual(i,1) = per_frame_residual(i,1) + ...
            sqrt(sumsqr(estimated_D(2*i-1:2*i, j) - norm_D(2*i-1:2*i, j))); 
    end
end

selected_frame  = [1,50,100];
for i = 1:size(selected_frame, 2)
    index = selected_frame(i);
    file_name = strcat(folder_name, 'frame00000', num2str(index, '%.3d'), '.jpg');
    I = imread(file_name);
    figure()
    imshow(I);
    hold on;
    
    scatter(D(2*index-1, :), D(2*index, :), 'r*');
    scatter(estimated_D(2*index-1, :) + mean(D(2*index-1,:)) ...
        , estimated_D(2*index, :) + mean(D(2*index,:)), 'go');
    title(strcat('Frame', num2str(index)))
end

disp('total residual:');
disp(sum(per_frame_residual));

figure()
plot(per_frame_residual);
axis([0 101 0 400]);
title('Residuals (per frame) ')
xlabel('frame number');
ylabel('residules');


