function[PARAMETER]=setParameter43(PARAMETER)

% This file contains parameter settings for ABC algorithm

PARAMETER.parameterID=43;
PARAMETER.T=0.5;                         % time intervals (mins)
PARAMETER.deltaTinSecond=2;           % each time step is 2s long
PARAMETER.deltaT=secondsToHour(PARAMETER.deltaTinSecond);     % unit: hour
PARAMETER.nT=ceil(minutesToHour(PARAMETER.T)/PARAMETER.deltaT);   % # time steps in one interval
PARAMETER.samplingInterval = 1;          % sample density every # time steps

PARAMETER.startString='2011-10-22 00:00:00.000';
PARAMETER.endString='2011-10-22 00:25:00.000';
PARAMETER.startTime= 4;
PARAMETER.endTime= 10;
PARAMETER.startTimeDate=datenum(PARAMETER.startString);
PARAMETER.unixTimeStep=PARAMETER.deltaTinSecond*1/24/3600;

% compute number of intervals
endTime=datenum(PARAMETER.endString);
unixTimeInterval=PARAMETER.T/(24*60);
PARAMETER.numIntervals=round((endTime-PARAMETER.startTime)/unixTimeInterval);        

% fundamental diagram parameters
PARAMETER.vmax = 65;
PARAMETER.dmax = 150;
PARAMETER.dc = 30;
PARAMETER.FUNDAMENTAL=struct('vmax',PARAMETER.vmax,'dmax',PARAMETER.dmax,'dc',PARAMETER.dc);

% split ratio
PARAMETER.trueNodeRatio=0.5;

PARAMETER.numEns=1;
PARAMETER.etaW=0;
PARAMETER.trueStateErrorMean=0;
PARAMETER.trueStateErrorVar=0;
PARAMETER.stateNoiseGamma=0;
PARAMETER.measNoiseGamma=0;

%% New add-ons for Approximate Bayesian Computation 
PARAMETER.vmaxVar = 0;
PARAMETER.dmaxVar = 0;
PARAMETER.dcVar = 0;
PARAMETER.trueNodeRatioVar = 0;
PARAMETER.modelFirst = 1;    % for model selection function
PARAMETER.modelLast = 1;     % for model selection function
PARAMETER.populationSize = 500;
PARAMETER.samplingSize = 750;
PARAMETER.thresholdVector = [0.5 0.5; 50 50; 50 50; 50 50; 50 50;...
    50 50; 50 50; 50 50; 50 50; 50 50];
