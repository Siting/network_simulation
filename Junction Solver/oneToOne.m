function[LINK] = oneToOne(sourceFeed,sinkFeed,node, LINK,page,ensemble,SOURCE_LINK,SINK_LINK)

% source?
if strcmp(num2str(node.junctionType),'source')
    [LINK] = updateSourceBoundaryFlux(node, sourceFeed,SOURCE_LINK,LINK,page,ensemble);
    
    % sink?
elseif strcmp(num2str(node.junctionType),'sink')
    [LINK] = updateSinkBoundaryFlux(node, sinkFeed,SINK_LINK,LINK,page,ensemble);
    
    
    % in the network?
else
    leftDensity = LINK(node.incomingLink_1_ID).densityResult(end,ensemble,page-1);
    rightDensity = LINK(node.outgoingLink_1_ID).densityResult(1,ensemble,page-1);
    
    result = RS(leftDensity,LINK(node.incomingLink_1_ID).vmax,...
        LINK(node.incomingLink_1_ID).dmax,...
        LINK(node.incomingLink_1_ID).dc,rightDensity,...
        LINK(node.outgoingLink_1_ID).vmax,...
        LINK(node.outgoingLink_1_ID).dmax,...
        LINK(node.outgoingLink_1_ID).dc);
    
    
    LINK(node.incomingLink_1_ID).rightFlux = result;
    LINK(node.outgoingLink_1_ID).leftFlux = result;
    
end

