function[SOURCE_LINK SINK_LINK] = loadSourceSinkLinks(nodeMap,FUNDAMENTAL, LINK)

global funsOption

% SOURCE_LINK = containers.Map( ...
%     'KeyType', 'int64', 'ValueType', 'any');
% 
% SINK_LINK = containers.Map( ...
%     'KeyType', 'int64', 'ValueType', 'any');


nodeIds = nodeMap.keys;
% 1st: check if it is source
% 2nd: check if it is sink
for i = length(nodeIds) : -1 : 1
    node = nodeMap(nodeIds{i});
    if isempty(node.sources) == 0
        % this is a source (it's the left boundary node of the network)
        source_link(i) = struct('linkID',[],'linkDesc',[],'numLanes',[],'vmax',[],'dmax',[],...
            'dc',[],'sensorID',[],'densityResult',[],'outgoingLinkID',[]);
        source_link(i).linkID = node.sources.sourceIds;
        source_link(i).linkDesc = 'source';
        
        if funsOption == 1
            source_link(i).vmax = FUNDAMENTAL.vmax;
            source_link(i).dc = node.sources.numberOfLanes * FUNDAMENTAL.dc;
            source_link(i).dmax = node.sources.numberOfLanes * FUNDAMENTAL.dmax;
        elseif funsOption == 2
            source_link(i).vmax = LINK(node.outgoingLinks).vmax;
            source_link(i).dmax = LINK(node.outgoingLinks).dmax;
            source_link(i).dc =  LINK(node.outgoingLinks).dc;
        end
        
        source_link(i).outgoingLinkID = node.outgoingLinks;
        %         source_link.numLanes = LINK(source_link.outgoingLinkID).numLanes;
        SOURCE_LINK(node.sources.sourceIds) = source_link(i);
    elseif isempty(node.sinks) == 0
        % this is a sink (it's the right boundary node of the network)
        sink_link(i) = struct('linkID',[],'linkDesc',[],'numLanes',[],'vmax',[],'dmax',[],...
            'dc',[],'sensorID',[],'densityResult',[],'incomingLinkID',[]);
        sink_link(i).linkID = node.sinks.sinkIds;
        sink_link(i).linkDesc = 'sink';
        
        if funsOption == 1
            sink_link(i).vmax = FUNDAMENTAL.vmax;
            sink_link(i).dc = node.sinks.numberOfLanes * FUNDAMENTAL.dc;
            sink_link(i).dmax = node.sinks.numberOfLanes * FUNDAMENTAL.dmax;
        elseif funsOption == 2
            sink_link(i).vmax = LINK(node.incomingLinks).vmax;
            sink_link(i).dmax = LINK(node.incomingLinks).dmax;
            sink_link(i).dc =  LINK(node.incomingLinks).dc;
        end
        
        sink_link(i).incomingLinkID = node.incomingLinks;
%         sink_link.numLanes = LINK(sink_link.incomingLinkID).numLanes;
        SINK_LINK(node.sinks.sinkIds) = sink_link(i);
    end
end

