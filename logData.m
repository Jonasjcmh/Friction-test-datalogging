function logData(src, evt,proj,f0,af,bf)
% Add the time stamp and the data values to data. To write data sequentially,
% transpose the matrix.

%   Copyright 2011 The MathWorks, Inc.

     
%      subplot(211)
     plot(evt.TimeStamps,-af*evt.Data(:,1)-bf+f0,'r')
     hold on
     
     
%      axis([0 src.DurationInSeconds -1 1])
     xlabel('time (s)')
     ylabel('Force (N)')    
%     
%      subplot(212)
%      plot(evt.TimeStamps,ap*evt.Data(:,2)+bp,'b')
%      hold on
%      axis([0 src.DurationInSeconds -1 25])
%      xlabel('time (s)')
%      ylabel('Pressure (kPa)')  
     
     
     dlmwrite ([proj '.csv'], [evt.TimeStamps evt.Data], '-append');


 
end