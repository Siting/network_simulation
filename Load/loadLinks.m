function[LINK, SOURCE_LINK, SINK_LINK] = loadLinks(linkMap,FUNDAMENTAL, configID)

global funsOption

% LINK = containers.Map( ...
%     'KeyType', 'int64', 'ValueType', 'any');

linkIds = linkMap.keys;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if funsOption == 2
    fileName = (['.\Configurations\fundamental_setting\FUN_CONFIG-' num2str(configID) '.csv']);
    fid=fopen(fileName);
    funForLinks=textscan(fid,'%d %f %f %f %f %f %f','delimiter',',','headerlines',1);
    vmax_mean = funForLinks{2};
    dmax_mean = funForLinks{3};
    dc_mean = funForLinks{4};
    vmax_var = funForLinks{5};
    dmax_var = funForLinks{6};
    dc_var = funForLinks{7};
    fclose(fid);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%

guessedFUNDAMENTAL = FUNDAMENTAL;

for i = length(linkIds) : -1 : 1
    NTlink = linkMap(linkIds{i});
    LINK(i) = struct('linkId',NTlink.linkId,'incomingNode',NTlink.incomingNode,...
        'outgoingNode',NTlink.outgoingNode,'numLanes',NTlink.numberOfLanes,...
        'length',NTlink.lengthInMiles,'startLatLon',NTlink.startLatLon,...
        'endLatLon',NTlink.endLatLon,'vmax',[],'dmax',[],'dc',[],...
        'numCells',[],'leftFlux',[],'rightFlux',[],'deltaX',[],'densityResult',[],...
        'cellIndex',[],'offsetFromGraph',[],'sensors',NTlink.sensors);
    if funsOption == 1
        % fundamental diagram parameters
        LINK(i).vmax = FUNDAMENTAL.vmax;
        LINK(i).dc = NTlink(i).numberOfLanes * FUNDAMENTAL.dc;
        LINK(i).dmax = NTlink.numberOfLanes * FUNDAMENTAL.dmax;
    elseif funsOption == 2
        guessedFUNDAMENTAL.vmax = vmax_mean(i);
        guessedFUNDAMENTAL.dmax = dmax_mean(i);
        guessedFUNDAMENTAL.dc = dc_mean(i);
        [FUNDAMENTAL] = sampleFUNDA(guessedFUNDAMENTAL, vmax_var(i), dmax_var(i), dc_var(i));
        LINK(i).vmax = FUNDAMENTAL.vmax;
        LINK(i).dmax = NTlink.numberOfLanes * FUNDAMENTAL.dmax;
        LINK(i).dc = NTlink.numberOfLanes * FUNDAMENTAL.dc;
    end
    
%     LINK(linkIds{i}) = link;
end