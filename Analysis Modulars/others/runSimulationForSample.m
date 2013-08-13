function[LINK, ROUND_SAMPLES] = runSimulationForSample(FUNDAMENTAL, PARAMETER, CONFIG, simu_configID, index, simu_evolutionDataFolder,...
    LINK, JUNCTION, SOURCE_LINK, SINK_LINK, ROUND_SAMPLES, occuDataMatrix_source, occuDataMatrix_sink)

% load config & para & map
[deltaTinSecond, deltaT, nT, numIntervals, numEns,...
    startTime, endTime, startTimePara, unixTimeStep, guessedFUNDAMENTAL, trueNodeRatio,...
    vmaxVar, dmaxVar, dcVar, trueNodeRatioVar, modelFirst, modelLast, populationSize,...
    samplingSize, criteria, stateNoiseGamma, measNoiseGamma, etaW, junctionSolverType,...
    numTimeSteps, samplingInterval, trueStateErrorMean, trueStateErrorVar,...
    measConfigID, measNetworkID, caliNetworkID, testingDataFolder, evolutionDataFolder,...
    sensorDataFolder, configID, T, thresholdVector] = getConfigAndPara(CONFIG,PARAMETER);
numTimeSteps = (endTime-startTime)*3600/deltaTinSecond;

load([caliNetworkID, '-graph.mat']);

% load LINK
[LINK, ROUND_SAMPLES] = loadLinksSample(LINK, FUNDAMENTAL, ROUND_SAMPLES);

% Set junction ratio
[JUNCTION] = loadNodeRatio(CONFIG.configID,JUNCTION,junctionSolverType,LINK);

% initialize links
[LINK, numCellsNet] = initializeAllLinks(LINK, deltaT, numEns, CONFIG);

% set FUNDA for SOURCE, SINK
[SOURCE_LINK, SINK_LINK] = setSourceSinkSample(SOURCE_LINK, SINK_LINK, LINK, deltaTinSecond);

% run simulation
[LINK] = runForwardSimulation(LINK, SOURCE_LINK, SINK_LINK, JUNCTION, deltaT, numEns, numTimeSteps, nT, junctionSolverType, occuDataMatrix_source, occuDataMatrix_sink);

saveSimulationResults_error(LINK,sensorMetaDataMap,numEns,numTimeSteps,samplingInterval,...
    startTimePara,unixTimeStep,trueStateErrorMean,trueStateErrorVar, index, configID, simu_evolutionDataFolder, CONFIG, PARAMETER);