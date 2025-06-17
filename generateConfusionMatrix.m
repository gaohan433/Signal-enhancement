function CM = generateConfusionMatrix(actualLabels, predictedLabels)
% Generates a confusion matrix for binary classification.

% Check if inputs are valid
if ~isvector(actualLabels) || ~isvector(predictedLabels)
    error('Input labels must be vectors.');
end

if length(actualLabels) ~= length(predictedLabels)
    error('Input label vectors must have the same length.');
end

% Ensure labels are binary (0 or 1)
if ~all(ismember(actualLabels, [0 1])) || ~all(ismember(predictedLabels, [0 1]))
    error('Input labels must be binary (0 or 1).');
end

% Initialize confusion matrix
CM = zeros(2, 2);

% Populate confusion matrix
for i = 1:length(actualLabels)
    actual = actualLabels(i) + 1;      % Convert 0/1 to 1/2 for indexing
    predicted = predictedLabels(i) + 1; % Convert 0/1 to 1/2 for indexing
    CM(actual, predicted) = CM(actual, predicted) + 1;
end

%Optional: Add row and column labels for better readability
% CM = array2table(CM,'RowNames',{'Actual Negative','Actual Positive'},'VariableNames',{'Predicted Negative','Predicted Positive'});

end
