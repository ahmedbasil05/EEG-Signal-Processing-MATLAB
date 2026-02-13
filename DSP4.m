%% ==============================
%% DSP Assignment 4 - EEG Analysis
%% Course: CP-303 Digital Signal Processing
%% ==============================

%% ------------------------------
%% TASK 0: Load Data from CSV & Parameters

filename = 'eegdata.csv';  % Replace with your actual file name
data = readtable(filename); % Assumes headers match: RAW_TP9, RAW_AF7, etc.

% Verify required columns exist
requiredCols = {'RAW_TP9', 'RAW_AF7', 'RAW_AF8', 'RAW_TP10'};
if ~all(ismember(requiredCols, data.Properties.VariableNames))
    error('CSV file must contain columns: RAW_TP9, RAW_AF7, RAW_AF8, RAW_TP10');
end

Fs = 256;             % Sampling frequency in Hz
epochLength = 5;      % Epoch length in seconds
samplesPerEpoch = Fs * epochLength; % Samples per epoch

% Extract raw EEG channels from table
TP9 = double(data.RAW_TP9);  % Ensure numeric
AF7 = double(data.RAW_AF7);
AF8 = double(data.RAW_AF8);
TP10 = double(data.RAW_TP10);

% Ensure we have enough samples for 200 epochs (5 sec each → 200*1280 = 256,000 samples)
totalNeeded = 200 * samplesPerEpoch;
if length(AF7) < totalNeeded
    warning('Data has fewer than 200 epochs. Truncating to available full epochs.');
    maxEpochs = floor(min([length(AF7), length(AF8), length(TP9), length(TP10)]) / samplesPerEpoch);
    if maxEpochs == 0
        error('Not enough data for even one 5-second epoch.');
    end
else
    maxEpochs = 200;
end

% Segment data into 5-second epochs (up to maxEpochs)
AF7_epochs = reshape(AF7(1:maxEpochs*samplesPerEpoch), samplesPerEpoch, maxEpochs);
AF8_epochs = reshape(AF8(1:maxEpochs*samplesPerEpoch), samplesPerEpoch, maxEpochs);
TP9_epochs = reshape(TP9(1:maxEpochs*samplesPerEpoch), samplesPerEpoch, maxEpochs);
TP10_epochs = reshape(TP10(1:maxEpochs*samplesPerEpoch), samplesPerEpoch, maxEpochs);

% Time vector for plotting
t = (0:samplesPerEpoch-1)/Fs;

%% ------------------------------
%% TASK 1 & 2: Time-Domain Analysis (Raw EEG)
%% ------------------------------
channels = {'AF7','AF8','TP9','TP10'};
epochs_struct = struct('AF7', AF7_epochs, 'AF8', AF8_epochs, 'TP9', TP9_epochs, 'TP10', TP10_epochs);

% Plot raw EEG separately for segment 1
for ch = channels
    figure;
    plot(t, epochs_struct.(ch{1})(:,1));
    xlabel('Time (s)'); ylabel('EEG Voltage (\muV)');
    title(['Raw EEG - ' ch{1} ' Channel - Segment 1']);
    grid on;
end

%% ------------------------------
%% TASK 3: Moving Average Filtering
%% ------------------------------
windowSize = 5;                     % Number of samples for moving average
b = (1/windowSize)*ones(1,windowSize);
a = 1;

% Apply moving average filter and plot
for ch = channels
    signal = epochs_struct.(ch{1})(:,1);
    signal_ma = filter(b, a, signal);
    % Save filtered signal back to struct
    epochs_struct.([ch{1} '_MA']) = signal_ma;
    
    % Plot
    figure;
    plot(t, signal); hold on;
    plot(t, signal_ma, 'r', 'LineWidth', 1.2);
    xlabel('Time (s)'); ylabel('EEG Voltage (\muV)');
    legend('Raw','Moving Avg');
    title([ch{1} ' - Moving Average Filter']);
    grid on;
end

%% ------------------------------
%% TASK 4: IIR Low-Pass Filtering (Butterworth)
%% ------------------------------
Fc = 30;                   % Cutoff frequency in Hz
order = 4;                  % Filter order
[b_iir, a_iir] = butter(order, Fc/(Fs/2), 'low'); % Normalize by Nyquist

% Apply IIR filter and plot comparison
for ch = channels
    signal = epochs_struct.(ch{1})(:,1);
    signal_ma = epochs_struct.([ch{1} '_MA']);
    signal_iir = filter(b_iir, a_iir, signal);
    epochs_struct.([ch{1} '_IIR']) = signal_iir;
    
    % Plot comparison
    figure;
    plot(t, signal); hold on;
    plot(t, signal_ma, 'r', 'LineWidth', 1.2);
    plot(t, signal_iir, 'g', 'LineWidth', 1.2);
    xlabel('Time (s)'); ylabel('EEG Voltage (\muV)');
    legend('Raw','Moving Avg','IIR Low-pass');
    title([ch{1} ' - Filter Comparison']);
    grid on;
end

%% ------------------------------
%% TASK 5: Frequency Band Power Analysis
%% ------------------------------
% Define EEG frequency bands (Hz)
bands = {'Delta','Theta','Alpha','Beta','Gamma'};
freqs = [0.5 4; 4 8; 8 13; 13 30; 30 50]; % Upper limit for gamma = 50 Hz

% Initialize results table (now using actual maxEpochs, but only analyzing epoch 1)
power_results = table('Size',[4 5], 'VariableTypes', repmat("double",1,5), ...
    'VariableNames', bands, 'RowNames', channels);

% Compute band powers for segment 1 safely
for ch = channels
    signal = epochs_struct.(ch{1})(:,1); % Segment 1
    signal = double(signal);             % Ensure numeric
    signal(~isfinite(signal)) = 0;       % Replace NaN/Inf with 0
    
    for k = 1:length(bands)
        power_results.(bands{k})(ch,:) = bandpower(signal, Fs, freqs(k,:));
    end
end

% Display table
disp('Average Power in EEG Bands (Segment 1):');
disp(power_results);

% Plot bar graph for each channel
for ch = channels
    figure;
    bar(power_results{ch{1},:});
    set(gca,'XTickLabel', bands);
    ylabel('Power (\muV^2)');
    title(['EEG Band Power - ' ch{1} ' - Segment 1']);
    grid on;
end