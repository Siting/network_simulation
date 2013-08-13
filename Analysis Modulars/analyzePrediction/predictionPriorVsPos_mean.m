clear all
clc

global boundarySourceSensorIDs
global boundarySinkSensorIDs
global testingSensorIDs
global sensorDataSource
global sensorMode

series = 60;
stage = 5;
startTimeStamp = 5;
studyLinks = [1; 3; 5; 7];
cali_configID = 41;
cali_paraID = 41;
simu_configID = series + 100;
numSamplesStudied = 2; % !!!!!!!!!! only study the mean values
boundarySourceSensorIDs = [400468; 402955; 402954; 402950];
boundarySinkSensorIDs = [402953; 400698];
testingSensorIDs = [400739; 400363];
sensorDataSource = 2;
sensorMode = 2;

% load prior and posterior
fileName = (['.\Configurations\fundamental_setting\FUN_CONFIG-' num2str(cali_configID) '.csv']);
fid=fopen(fileName);
funForLinks=textscan(fid,'%d %f %f %f %f %f %f','delimiter',',','headerlines',1);
vmax_mean = funForLinks{2};
dmax_mean = funForLinks{3};
dc_mean = funForLinks{4};
fclose(fid);
load(['.\ResultCollection\series' num2str(series) '\-calibrationResult.mat']);

% load CONFIG & PARA &...
load(['.\Configurations\configs\CONFIG-' num2str(cali_paraID) '.mat']);
load(['.\Configurations\parameters\PARAMETER-' num2str(cali_paraID) '.mat']);
load([CONFIG.caliNetworkID, '-graph.mat']);

% directories
simu_sensorEvolutionDataFolder = ['.\Result\testingData\config-' num2str(simu_configID)];
simu_linkEvolutionDataFolder = ['.\Result\evolutionData\config-' num2str(simu_configID)];
mkdir(simu_sensorEvolutionDataFolder);
mkdir(simu_linkEvolutionDataFolder);

% load noisy sensor data
[sensorDataMatrix] = getNoisySensorData_network(testingSensorIDs, PARAMETER.T,...
    PARAMETER.startTime, PARAMETER.endTime);

ROUND_SAMPLES = initializeAllSamples(linkMap);

% SIMULATION
for sample = 1 : numSamplesStudied
    [LINK, JUNCTION, SOURCE_LINK, SINK_LINK] = preloadAndCompute(linkMap, nodeMap, PARAMETER.T, PARAMETER.startTime, PARAMETER.endTime);

    % extract sample for every link & assign to links
    for i = 1 : size(meanForRounds,2)
        if sample == 1
            FUNDAMENTAL(i).vmax = vmax_mean(i);
            FUNDAMENTAL(i).dmax = dmax_mean(i);
            FUNDAMENTAL(i).dc = dc_mean(i);
        elseif sample == 2
            FUNDAMENTAL(i).vmax = meanForRounds(1, i, stage);
            FUNDAMENTAL(i).dmax = meanForRounds(2, i, stage);
            FUNDAMENTAL(i).dc = meanForRounds(3, i, stage);
        end
    end

    % run simulation
    [LINK, ROUND_SAMPLES] = runSimulationForSample(FUNDAMENTAL, PARAMETER, CONFIG, simu_configID, sample, simu_sensorEvolutionDataFolder,...
        LINK, JUNCTION, SOURCE_LINK, SINK_LINK, ROUND_SAMPLES);    

    % all links density results
    save([simu_linkEvolutionDataFolder '\LINK-CONFIG-' num2str(cali_configID) '-sample-' num2str(sample)],'LINK');

    % get model simulation data (cumulative)
    modelDataMatrix = getModelSimulation_analyze(simu_configID, sample, testingSensorIDs, PARAMETER.T, PARAMETER.deltaTinSecond, ROUND_SAMPLES);
    
    % save cumulative density Matrix
    save([simu_sensorEvolutionDataFolder '\' num2str(sample) '\cumuDensity'],'modelDataMatrix');

    if mod(sample, 20) == 0
        disp(['sample ' num2str(sample) ' is finished']);
    end
end

% PLOT
figure
for i = 1 : length(testingSensorIDs)
    
    subplot(2,1,i)
    
    load(['.\Result\testingData\config-' num2str(simu_configID) '\1\cumuDensity.mat']);  % prior
    priorDensityMatrix = modelDataMatrix(:,i);
    
    load(['.\Result\testingData\config-' num2str(simu_configID) '\2\cumuDensity.mat']);  % pos
    postDensityMatrix = modelDataMatrix(:,i);
    
    sensorData = sensorDataMatrix(:,i);   % sensor
    
    plot(priorDensityMatrix(startTimeStamp:end),'r');
    hold on
    plot(postDensityMatrix(startTimeStamp:end), 'k');
    plot(sensorData(startTimeStamp+1:end), 'g');
    legend('prior','pos','true');
    hold off

    saveas(gcf, ['../Plots\series' num2str(series) '\predictionSensorPriorVsPos_sensor_ ' num2str(testingSensorIDs(i)) '_mean.pdf']);
    saveas(gcf, ['../Plots\series' num2str(series) '\predictionSensorPriorVsPos_sensor_ ' num2str(testingSensorIDs(i)) '_mean.fig']);
    saveas(gcf, ['../Plots\series' num2str(series) '\predictionSensorPriorVsPos_sensor_ ' num2str(testingSensorIDs(i)) '_mean.eps'], 'epsc');
end


