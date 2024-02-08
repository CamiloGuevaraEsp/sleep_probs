%Set the directory
dir = "/Users/camilog/Desktop/P_WAKE_TESTS"

%Write the monitor file name and number
fileName = "Monitor11"
monitorNumber = 11;
channelRange = 1:32;

%Write the time range you want to analyze
start_day = "20 Jun 23";
start_hour = "9:00:00";
end_day = "23 Jun 23";
end_hour = "9:00:00";
%Write bin size 
bin = 5;

%Write the name of your output filename

outputName = "20240208";

%------DO NOT WRITE ANYTHING BELOW--------------------
cd(dir)
epoch_length = bin * (1/1440);

D = readCountData(fileName, monitorNumber,start_day,start_hour,end_day,end_hour);
D.counts = D.counts(:,channelRange); 

start_time = strrep(start_day,' ','-');
start_time = start_time + ' ' + start_hour; 
start_time = datetime(start_time,'InputFormat','dd-MMM-yy HH:mm:SS');
%start_time = datestr(dateParsed, 'dd-MMM-yyyy HH:mm:ss');

end_time = strrep(end_day,' ','-');
end_time = end_time + ' ' + end_hour;
end_time = datetime(end_time,'InputFormat','dd-MMM-yy HH:mm:SS');



%start_time = '20-Jun-2023 09:00:00';
%end_time = "23-Jun-2023 09:00:00";

D.START_TIME = start_time;
% Specify the format
%format = 'dd-MMM-yyyy HH:mm:SS';
% Convert to datetime
%D.START_TIME = datetime(D.START_TIME, 'InputFormat', format);

D.END_TIME = end_time
%format = 'dd-MMM-yyyy HH:mm:SS';
% Convert to datetime
%D.END_TIME = datetime(D.END_TIME, 'InputFormat', format);

epoch_idx = epochBounds(D, epoch_length);

doze_prob = calculateConditionalDozeProb(D.counts, epoch_idx);
wake_prob = calculateConditionalWakeProb(D.counts, epoch_idx);

x = nanmean(wake_prob,2);
plot(x,'LineWidth', 1.5)
hold on
y = nanmean(doze_prob,2);
plot(y, 'LineWidth',1.5)

legend('p(wake)','p(doze)', 'FontSize', 15)
ylabel("Probability")

writematrix(doze_prob,outputName + '.xls','Sheet','doze')
writematrix(wake_prob,outputName + '.xls','Sheet','wake')


