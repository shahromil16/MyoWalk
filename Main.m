function [fall,reel1,reel2,reel3,reel4,reel5,n] = Main()

clear all
clc
format long
delete('*.csv');
trin = 0;

prompt = {'Enter total time period:','Enter intervals:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'2','60'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

totals = str2num(answer{1});
intervals = str2num(answer{2});

while trin<totals
    
    trin = trin + 1;
    b = 0;
    system('ThalmicLabs\MyoConnect\MyoConnect.exe &');
    pause(10);
    inc = 0;

    while b<intervals

        b = b+1
        
        if mod(b,5)==0
            runfile;
            files = dir('*.csv');
            num_files = length(files);
            inc = inc + 1;
            for i=1:num_files
                filename = files(i).name;
                datas{i} = importdata(filename);
                if inc==1
                    if i==1
                        reel1 = [datas{1}.data];
                        n(i) = length(reel1);
                    elseif i==2
                        reel2 = [datas{2}.data];
                        n(i) = length(reel2);
                    elseif i==3
                        reel3 = [datas{3}.data];
                        n(i) = length(reel3);
                    elseif i==4
                        reel4 = [datas{4}.data];
                        n(i) = length(reel4);
                    elseif i==5
                        reel5 = [datas{5}.data];
                        n(i) = length(reel5);
                    end
                elseif inc>1
                    if i==1
                        reel1 = cat(1,reel1, datas{1}.data);
                        n(i) = length(reel1);
                    elseif i==2
                        reel2 = cat(1,reel2, datas{2}.data);
                        n(i) = length(reel2);
                    elseif i==3
                        reel3 = cat(1,reel3, datas{3}.data);
                        n(i) = length(reel3);
                    elseif i==4
                        reel4 = cat(1,reel4, datas{4}.data);
                        n(i) = length(reel4);
                    elseif i==5
                        reel5 = cat(1,reel5, datas{5}.data);
                        n(i) = length(reel5);
                    end
                end
            end
        end
        delete('*.csv');

    end
    
    fall = 0;
    
    [wid,len]=size(reel1);
    for i=1:intervals/5:wid-intervals/5
        data1 = reel1(i:i+intervals/5,4);
        data2 = reel4(i:i+intervals/5,5);
        data3 = reel5(i:i+intervals/5,3);
        if abs((abs(max(data1))-abs(min(data1)))>0.5) || abs((abs(max(data2))-abs(min(data2))>10)) || abs((abs(max(data3))-abs(min(data3)))>5)
            %if (find(data1==max(data1))>find(data1==min(data1)))
                send_text_message('857-919-7147','tmobile','Alert','Fall Detected');
                fall = 1;
            %end
        end  
    end
    
%     if fall == 1
%         for i=1:5
%             if i==1
%                 realdata = reel1;
%             elseif i==2
%                 realdata = reel2;
%             elseif i==3
%                 realdata = reel3;
%             elseif i==4
%                 realdata = reel4;
%             elseif i==5
%                 realdata = reel5;
%             end
%             [wid,len]=size(realdata);
%             colorVec = hsv(len);
%             figure(i)
%             title(num2str(i));
%             for j=2:len
%                 realdata(:,j) = realdata(:,j)/max(realdata(:,j));
%                 hold on
%                 plot(1:n(i),realdata(:,j),'Color',colorVec(j-1,:))
%             end
%         end
%     end
    
    cd('C:\Users\user\Desktop\Myo Data Capture Windows\ThalmicLabs\MyoConnect');
    !taskkill /f /im MyoConnect.exe
    cd('C:\Users\user\Desktop\Myo Data Capture Windows');
    % send_text_message('857-919-7147','tmobile','Alert','Kindly check.')
    
end