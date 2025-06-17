function [approxAUC,max_index] = plotGroupROC(confusionMatrices,plot_on)
% Plots ROC points, connects them with lines, and calculates an approximate AUC.
% Returns the approximate AUC and plot handles.

numGroups = numel(confusionMatrices);

% Preallocate arrays for storing TPR and FPR
TPR = zeros(1, numGroups);
FPR = zeros(1, numGroups);

max_dif = -Inf;
max_index = NaN;
for i = 1:numGroups
    CM = confusionMatrices{i};

    % Extract true positives, false positives, true negatives, and false negatives
    TP = CM(2, 2);
    FP = CM(1, 2);
    TN = CM(1, 1);
    FN = CM(2, 1);

    % Calculate True Positive Rate (Sensitivity) and False Positive Rate (1-Specificity)
    TPR(i) = TP / (TP + FN);  % Sensitivity
    FPR(i) = FP / (FP + TN);  % 1 - Specificity
    dif = TPR(i)-FPR(i);
    if dif>max_dif
        max_dif = dif;
        max_index = i;
    end
end

% Sort points by FPR for correct AUC calculation and line plotting
[FPR, sortIdx] = sort(FPR);
TPR = TPR(sortIdx);


% Plot as a connected line


% Calculate approximate AUC using trapezoidal rule
approxAUC = trapz(FPR, TPR);

% % Plot the chance line
% plot([0 1], [0 1], '--k', 'LineWidth', 1.5);
if plot_on
    figure('Position', [10 10 900 300]); 
    hold on; % Create a new figure and hold the plot
    h = plot(FPR, TPR,'LineWidth', 2);%, '-o', 'MarkerSize', 8,
    % Add labels and title
    xlabel('False Positive Rate (1 - Specificity)');
    ylabel('True Positive Rate (Sensitivity)');
    title(['ROC Points (Connected), Approximate AUC = ' num2str(approxAUC)]);
    
    grid on;
    hold off;
end

end


