clc;clear;close all
%% Load data
load('sample_data_subject_5.mat')
%% Visulization of fast wave, slow wave enevelope and enhanced signal
ch_num = 40;
figure
subplot(3,1,1)
plot(fastWave(ch_num,:))
xlabel('Time')
ylabel('Magnitude (mv)')
title('fast wave signal')
xlabel('Time')
subplot(3,1,2)
plot(slowEnv(ch_num,:))
ylabel('Magnitude (a.u.)')
title('slow wave envelope')
subplot(3,1,3)
plot(modulation(ch_num,:))
title('enhanced signal')
xlabel('Time')
ylabel('Magnitude (a.u.)')
%% Bad channel removal
ch_max = max(fastWave,[],2);
index1 = find(ch_max>0.3);
index2 = find(ch_max<0.01);
bad_channel = [index1;index2];
fastWave(bad_channel,:) = [];
modulation(bad_channel,:) = [];
torso = RawTorso.pts(activeElectrodes,:);
torso(bad_channel,:) = [];
%% ROC curve computation
signal = fastWave; %Change this to modulation if you want to show the results of enhanced signal
ch_num = size(signal,1);
w=50; % Window length
auc_array = zeros(ch_num,1);
for ch = 1:ch_num   
    [yupper,~] = envelope(signal(ch,:),w,'rms');
    count=1;
    step = -3:0.05:3;
    confusionMatrices = cell(1, length(step));
    for i = step
        c1 = rms_contraction_detection(yupper,w,i);
        confusionMatrices{count} = generateConfusionMatrix(toco, c1);
        count = count+1;
    end
    [auc2,~] = plotGroupROC(confusionMatrices,0);
    auc_array(ch,1) = auc2;
end

%% AUC distribution of all channels on body surface
high_con_ch = auc_array>0.8; %High consistency channels

ax = figure;
ax.Position=[10 10 900 800];
h = trimesh(RawTorso.tri,RawTorso.pts(:,1)*0.97,RawTorso.pts(:,2)*0.97,RawTorso.pts(:,3)*1.02,'EdgeColor', 'none');
h.FaceColor = '#E5C298';
h.FaceAlpha=.9;
hold on
scatter3(torso(:,1),torso(:,2),torso(:,3),40,auc_array,'filled')

view([4.8,-1.6])
xlabel('X');
ylabel('Y');
zlabel('Z');

colorbar;
colormap(jet);
clim([0 1])
%% High consistency channels
coordinates = RawTorso.pts(high_con_ch,:);
distance_matrix = pdist2(coordinates, coordinates);

ax = figure;
ax.Position=[10 10 900 800];
h = trimesh(RawTorso.tri,RawTorso.pts(:,1)*0.97,RawTorso.pts(:,2)*0.97,RawTorso.pts(:,3)*1.02,'EdgeColor', 'none');
h.FaceColor = '#E5C298';
h.FaceAlpha=.9;
hold on
scatter3(torso(:,1),torso(:,2),torso(:,3),40,high_con_ch,'filled')
hold on
plot3(toco_location(1), toco_location(2), toco_location(3), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
view([4.8,-1.6])
xlabel('X');
ylabel('Y');
zlabel('Z');

colorbar;
colormap(jet);
clim([0 1])
%% Fitting a convex hull
torso_h_con = torso(high_con_ch,:);
% figure
% scatter(torso_h_con(:,1),torso_h_con(:,3))
P = torso_h_con(:,[1 3]);
[k,av] = convhull(P);
outerindex = unique(k);
outerpoints = torso_h_con(outerindex,:);
figure
plot(P(:,1),P(:,2),'*')
hold on
plot(P(k,1),P(k,2))
hold on 
center = mean(outerpoints);
plot(center(1),center(3), 'ko')
ylim([-100 250])
xlim([-200 200])
%% Signaling distance estimation
distances = sqrt(sum((outerpoints - mean(outerpoints)).^2, 2));
sum_of_distances = sum(distances)/length(outerindex);
disp(['Sum of distances: ', num2str(sum_of_distances)]);