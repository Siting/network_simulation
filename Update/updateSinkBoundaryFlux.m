function[LINK]=updateSinkBoundaryFlux(node, sinkFeed,SINK_LINK,LINK,page,ensemble)

link = LINK(node.incomingLink_1_ID);
sinkLink = SINK_LINK(node.outgoingLink_1_ID);

% compute flux
qSink(node.incomingLink_1_ID) = RS(link.densityResult(end,ensemble,page-1),...
    link.vmax,link.dmax,link.dc,...
    sinkFeed(node.incomingLink_1_ID),...
    sinkLink.vmax,...
    sinkLink.dmax,...
    sinkLink.dc);

link.rightFlux = qSink(node.incomingLink_1_ID);


LINK(node.incomingLink_1_ID) = link;
