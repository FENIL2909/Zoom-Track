function [myTimer] = timerInBackground
global time
time = 0;
myTimer = timer('Name','MyTimer',               ...
                'Period',0.25,                 ... 
                'StartDelay',5,                 ... 
                'ExecutionMode','fixedRate', ...
                'TimerFcn',@myTimerCallback); 
start(myTimer);

function myTimerCallback(hObject, eventdata)    
global time
time = time + 0.1;
%fprintf("%d \n",time);



