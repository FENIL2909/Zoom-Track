global time; 
TIMER = 1000;
Number_of_Targets = 200;
Total_Number_of_Simulations = 100;
MEAN(1:Total_Number_of_Simulations) = 0;
STANDARD_DEVIATION(1:Total_Number_of_Simulations) = 0;
Number_of_Simulation = 1;

T_dataAssociation = 1;
T_authenticate = 1;
T_measurement = 1;



    Time_of_Detection(1:Number_of_Targets) = NaN;
    Detection_Time(1:Number_of_Targets) = NaN;
    Target_Status(1:Number_of_Targets) = 0;

    detectFlag_A(1:Number_of_Targets) =0;
    detectFlag_AA(1:Number_of_Targets) =0;
    detectFlag_AAA(1:Number_of_Targets) =0;
    Detection_Time_Allocation_flag(1:Number_of_Targets) =0;
    Target_Flag = 0;
    Target_Flag_Wait = 0;

    Schedule_Time = (TIMER/Number_of_Targets);
    N = 1;

    TimeDetect = 0;

    Time_Start(1:Number_of_Targets) = 0;
    velocity(1:Number_of_Targets)=0;
    extra = 0;

    Target(1:Number_of_Targets) = 0;
    b = 0;
    Authenticated_Targets = 0;
    Failed_Targets = 0;
    Target_Authentication_Flag = 0;
    Target_Failure_Flag = 0;
        
    for Target_Number = 1:Number_of_Targets
    
        velocity(Target_Number) = randi([1 5],1,1);
    
        if time <= TIMER 
            for K = 1:1000
                if time < (N*Schedule_Time + ((Number_of_Simulation - 1)*Number_of_Targets*Schedule_Time)) && (Target_Flag_Wait == 0)
                    while time <= (N*Schedule_Time + ((Number_of_Simulation - 1)*Number_of_Targets*Schedule_Time))
                        extra = extra+1;
                        Target_Flag_Wait = 1;
                    end
                end
                if (time >= (N*Schedule_Time + ((Number_of_Simulation - 1)*Number_of_Targets*Schedule_Time))) && (Target_Flag == 0)
                    Target_Status(Target_Number) =1;
                    N = N + 1;
                    Time_Start(Target_Number) = time;
                    Target_Flag = 1;
                end
         
                Target(Target_Number) = Target(Target_Number) + velocity(Target_Number);    
                if (detectFlag_A(Target_Number) == 0)    
                        TimeDetect = time;
                        detectFlag_A(Target_Number) = 1;
                end
        
                if time >= (Time_Start(Target_Number) + 0.5)
                    detectFlag_AA(Target_Number) = 1;
                else 
                    for a = 1:10
                        b = b + 1
                    end
                end
        
                if ((detectFlag_A(Target_Number) == 1) && (detectFlag_AA(Target_Number) ==1) &&(detectFlag_AAA(Target_Number)==0)&&(Target(Target_Number)<=1000)&&(Target_Authentication_Flag == 0))
                    while time <= (TimeDetect + T_dataAssociation + T_authenticate + T_measurement)
                        extra =extra+1;
                    end
                    detectFlag_AAA(Target_Number)==1;
                    Time_of_Detection(Target_Number) = time;
                    Target_Status(Target_Number) = 2;
                    Authenticated_Targets = Authenticated_Targets + 1;
                    Target_Authentication_Flag = 1;
                
                else if ((detectFlag_AAA(Target_Number)==0)&&(Target(Target_Number)> 1000)&&(Target_Status(Target_Number) ~= 2)&&(Target_Failure_Flag == 0))
                    detectFlag_AAA(Target_Number)==1;
                    while time <= (TimeDetect + T_dataAssociation)
                        extra =extra+1;
                    end
                    Target_Status(Target_Number) = 3;
                    Failed_Targets = Failed_Targets + 1;
                    Target_Failure_Flag = 1;
                    end
                end
         
                if ((Target_Status(Target_Number) == 2)&& (Detection_Time_Allocation_flag(Target_Number)==0))
                    Detection_Time(Target_Number) =  Time_of_Detection(Target_Number) - Time_Start(Target_Number);
                    Detection_Time_Allocation_flag(Target_Number)= 1;
                else if ((Target_Status(Target_Number) == 3)&&(Detection_Time_Allocation_flag(Target_Number)==0))
                    Detection_Time(Target_Number) = NaN;
                    Detection_Time_Allocation_flag(Target_Number)=1;
                    end
                end
                if K >= 1000
                    Target_Flag = 0;
                    Target_Flag_Wait = 0;
                    Target_Failure_Flag = 0;
                    Target_Authentication_Flag = 0;
                end
       
            end
        else
            Target_Status(Target_Number) =1;
        end
    end

            
   MEAN_300_25 = mean(Detection_Time,'omitnan')
   STANDARD_DEVIATION_300_25 = std(Detection_Time,'omitnan')
 


    