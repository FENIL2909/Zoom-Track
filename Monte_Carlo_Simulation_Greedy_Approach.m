global time

Velocity = 125; 

detectFlag_A(1:1000) =0;
detectFlag_AA(1:1000) =0;
detectFlag_AAA(1:1000) =0;

TimeDetect_A =0;
T_wait =0;
T_dataAssociation = 1;

Authenticated_TARGET(1:10000) = 0; 
Failed_TARGET(1:10000) = 0;
Authenticated_Target =0;
extra = 0;

%myTimer = timerInBackground;

Timer_Step_Change = 0;

for Step_no = 1:1:10000
    
    T_operation = (randi([80 120],1,1))*(0.25) ;
    T_authenticate = (randi([1 4],1,1))*(0.25);
    T_measurement = (randi([1 4],1,1))*(0.25);
    authenticatedTarget_theoretically = (T_operation - T_wait)/(T_measurement + T_dataAssociation + T_authenticate);
    Random_Limit = round(authenticatedTarget_theoretically);
    Half_Random_Limit = round(Random_Limit);
        
    K = randi([Half_Random_Limit Random_Limit],1,1);
    Target(1:K) =0;
    Target_no = 1;
    
    for time = 1:(Timer_Step_Change + T_operation)
    
            if ((time >= (TimeDetect_A + T_dataAssociation + T_measurement + T_authenticate))&&(detectFlag_A(Target_no) == 0))   
              TimeDetect_A = time;
              detectFlag_A(Target_no) = 1;
            end 
            
            for i = 1:1:K
                Target(i) = Target(i) + Velocity;
            end
            
            if ((detectFlag_A(Target_no) ==1)&&(time <= (TimeDetect_A + T_dataAssociation + T_authenticate))&& (detectFlag_AA(Target_no)==0)) 
                if time > (TimeDetect_A + T_authenticate)
                    extra =extra+1;
                else 
                    detectFlag_AA(Target_no) =1; 
                end
            else 
                    extra =extra+1;
            end
     
            if ((detectFlag_A(Target_no) == 1) && (detectFlag_AA(Target_no) ==1) &&(detectFlag_AAA(Target_no)==0)&&(Target(Target_no)<=1500))
                detectFlag_AAA(Target_no)==1;
                if Authenticated_Target < K
                    Authenticated_Target = Authenticated_Target+1;
                end
                if Target_no < K 
                    Target_no = Target_no + 1;
                end
            end    
            if ((detectFlag_A(Target_no) == 1) && (detectFlag_AA(Target_no) ==1) &&(detectFlag_AAA(Target_no)==0)&&(Target(Target_no)> 1500))
                detectFlag_AAA(Target_no)==1;
                if Target_no < K 
                    Target_no = Target_no + 1;
                end
            end    
    end
    
    Authenticated_TARGET(Step_no) = ((Authenticated_Target/K)*100);
    Failed_TARGET(Step_no) = (100 - Authenticated_TARGET(Step_no)); 
    Authenticated_Target = 0;
    Target_no =0;   
    detectFlag_Target(1:100) = 0;    
    detectFlag_TARGET(1:100) = 0;
    detectFlag_TARGET_T(1:100) = 0;
    TimeDetect_Target =0;
    extra =0;
    %myTimer = timerInBackground;
    Timer_Step_Change = time;
end

Step_no = 1:1:10000;
figure(1)
plot(Step_no,Authenticated_TARGET,'o')
xlabel('Number of simulations'),ylabel('Percentage of Success'),title('Success Graph - V=125 units')
grid on

figure(2)
plot(Step_no,Failed_TARGET,'o')
xlabel('Number of simulations'),ylabel('Percentage of Failure'),title('Failure Graph - V=125 units')
grid on