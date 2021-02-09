% UPDATED Feb 4, 2021
%% Section A: Data and graphs for individual animals
%Most analysis we've done so far has only used 1-6. However, I included
%other code in case we ever want it
%MAKE SURE DATA IS IMPORTED AS COLUMN VECTORS

%% 1 load data from one animal (recorded AIN1)
pulses = DIO1;
fileGCamP = AIn1DemodulatedLockIn;
fileContChan = AIn2DemodulatedLockIn;
times = Times;

%% 1 load data from another animal (recorded AIn3)
pulses = DIO1;
fileGCamP = AIn3DemodulatedLockIn;
fileContChan = AIn4DemodulatedLockIn;
times = Times;

%% 1 OPTIONAL - if first cell of extracted columns is NaN
pulses(1)=[];
fileGCamP(1)=[];
fileContChan(1)=[];
times(1)=[];

%% 2 converting to DFF without time bins
p = polyfit(fileContChan, fileGCamP,1);
fittedCont = polyval(p,fileContChan);

sessionDFF = (fileGCamP-fittedCont)./fittedCont;

detrendDFF = detrend(sessionDFF, 'linear');
zscoreDFF = zscore(sessionDFF);
%% 2 converting to DFF with time bins
[sessionDFF, zscoreDFF] = dffCalculation_RD_Jan4_2019(times, fileContChan, fileGCamP);

%sessionDFF is DFF without standardization
% zscoreDFF is sessionDFF standardized

%% 3 get the trains parsed out (1,2,4,8 pulses)
[session_pulses, train_stamps1, train_stamps2, train_stamps4, train_stamps8] = trainparser(pulses, times);
%session_pulses is array with time stamps for pulse trains with the
%corresponding numbers of pulses that occurred there

%% 3 get the trains parsed out (2,4,8,16 pulses)
[session_pulses, train_stamps1, train_stamps2, train_stamps4, train_stamps8] = trainparser24816(pulses, times);

%for simplicity of the program, extracted train_stamps will still be named
%as 1,2,4,8 even though they are really 2,4,8,16. 

%% 3 optional (code doesn't parse out equal amounts of pulse trains)

x = find(session_pulses(:,2) ~= 1 & session_pulses(:,2) ~= 2 & session_pulses(:,2) ~= 4 & session_pulses(:,2) ~= 8);
% once you get that index number, train_stampsNUMBER(41) = session_pulses(x,1);
% often times, pulse number will appear 1 less than it should be, ie 3
% pulses instead of 4

%% 3 optional (when decimation mistakes train_stamps2 for train_stamps1, so train_stamps1 is 1 cell greater than train_stamps2)
j=1;
for i = 0:4:160
    test = session_pulses(i+1:i+4,2)
    if sum(test) == 14
        exclude = i
    end
end
exclude = exclude+1;
%exclude is the starting index for the group of 4 you will look at for
%removal (because trains occur in random order of 1,2,4,8, then repeat
% go to that index of session pulses and see if there is two sets of 1 in
% that grouping of 4
% get the time points of both of those 1's (MISTAKETIME1 and MISTAKETIME2) and type the following:
% train_stamps1(train_stamps1 == [MISTAKETIME1]) = [];
% train_stamps1(train_stamps1 == [MISTAKETIME2]) = [];

%% 4 averaging every value for plotting them
% https://www.mathworks.com/help/matlab/ref/legend.html
%user changes e to define how many seconds before and after a pulse train
%they want to examine
e =2; %user defined variable of time in seconds
[averagedDFF1, averagedZScore1, averagedTimeDiff1, sem1] = trainplotter(train_stamps1, sessionDFF, zscoreDFF, times, e);

[averagedDFF2, averagedZScore2, averagedTimeDiff2, sem2] = trainplotter(train_stamps2, sessionDFF, zscoreDFF, times, e);

[averagedDFF4, averagedZScore4, averagedTimeDiff4, sem4] = trainplotter(train_stamps4, sessionDFF, zscoreDFF, times, e);

[averagedDFF8, averagedZScore8, averagedTimeDiff8, sem8] = trainplotter(train_stamps8, sessionDFF, zscoreDFF, times, e);

% averagedDFF = avg all DFF values e seconds before and after stimulation 
% averagedZcore = avg all z-scored DFF values e sec before and after stim
% averagedTimeDiff = time before/after stimulation, from -e to +e
% sem = Standard Error Mean of all trials along the entire trace

% 
% don't worry if you get an error after the next loop, uncomment if you
% need it
% allAveragedTimeDiff = [];
% for i = 1:length(averagedTimeDiff1)
%     allAveragedTimeDiff(i) = (averagedTimeDiff1(i) + averagedTimeDiff2(i) + averagedTimeDiff4(i) + averagedTimeDiff8(i))/4;
% end





%% 5 making figures
%VERY IMPORTANT- After you make the figure, and before you save it as PDF,
%make sure the renderer is set to 'painter.' To do this, go to print
%preview, make sure colors are RGB, and then go to advanced and change
%renderer setting to 'painter.'

zScoreFig = figure(2);
set(gca, 'fontname', 'Arial', 'FontSize', 10); %font settings

%comment all stimulations you are not plotting
plot(averagedTimeDiff1, averagedZScore1, 'LineWidth', 1);
hold on;
plot(averagedTimeDiff2, averagedZScore2,'LineWidth', 1);
hold on;
plot(averagedTimeDiff4, averagedZScore4,'LineWidth', 1);
hold on;
plot (averagedTimeDiff8, averagedZScore8, 'LineWidth', 1);
hold on;
%change legend, title, and axis labels as needed
legend('1 Pulse', '2 Pulses', '4 Pulses', '8 Pulses');
title('CAM7');
xlabel('Time relative to Pulse Train (s)');
ylabel('dF/F (Z-Score)');
hold on;
plot([0, 0],[-.5, 8], 'k--'); 
%plots a dotted line to indicate start of pulse. adjust the length of the line as needed through the second pair of bracketed numbers

axis([-2 2 -.5 8]); 
%%change axis as needed [lower x, higher x, lower y, higher y]

set(0, 'DefaultFigureRenderer', 'painters');
figure(2).Renderer='Painters';
figure(1).Renderer='Painters';

%% 5 optional... put lines on the graph to indicate the times of half-max values
hold on;
[width] = widthAtHalfMax(averagedZScore8, averagedTimeDiff8);
a = width(1); b = width(2);
y = max(averagedZScore8)*.5;
plot([a,b], [y, y], 'k:', 'LineWidth', 2);

hold on;
plot([a, a], [-.5, y], 'k:', 'LineWidth', 2);
aL = {num2str(a)};
text(a,-.5,aL, 'FontSize', 7, 'FontWeight', 'bold');
hold on;
plot([b ,b], [-.5, y], 'k:', 'LineWidth', 2);
bL = {num2str(b)};
text(b,-.5,bL,'FontSize', 7, 'FontWeight', 'bold');

set(0, 'DefaultFigureRenderer', 'painters');
figure(2).Renderer='Painters';
figure(1).Renderer='Painters';


%% 5 OPTIONAL - adding error bar shading to graph
%https://www.mathworks.com/matlabcentral/answers/180829-shade-area-between-graphs
semLow1 = averagedZScore1-sem1;
semHigh1 = averagedZScore1+sem1;
x1 = [averagedTimeDiff1, fliplr(averagedTimeDiff1)]
inBetween1 = [semLow1, fliplr(semHigh1)];
color1 = [0 0.4471 0.7412];
fill(x1, inBetween1, color1, 'LineStyle', 'none')
alpha(.3); 

hold on;

semLow2 = averagedZScore2-sem2;
semHigh2 = averagedZScore2+sem2;
x2 = [averagedTimeDiff2, fliplr(averagedTimeDiff2)]
inBetween2 = [semLow2, fliplr(semHigh2)];
color2 = [1 0 0];
fill(x2, inBetween2, color2, 'LineStyle', 'none')
alpha(.3); 

hold on;

semLow4 = averagedZScore4-sem4;
semHigh4 = averagedZScore4+sem4;
x4 = [averagedTimeDiff4, fliplr(averagedTimeDiff4)]
inBetween4 = [semLow4, fliplr(semHigh4)];
color4 = [0.9294 0.6941 0.1255];
fill(x4, inBetween4, color4, 'LineStyle', 'none');
alpha(.3); 

hold on;

semLow8 = averagedZScore8-sem8;
semHigh8 = averagedZScore8+sem8;
x8 = [averagedTimeDiff8, fliplr(averagedTimeDiff8)]
inBetween8 = [semLow8, fliplr(semHigh8)];
% color8 = [0.9451 0.6784 1.0000]
% fill(x8, inBetween, color, 'LineStyle', 'none')
color8 = [ 0.4941 0.1843 0.5569];
fill(x8, inBetween8, color8, 'LineStyle', 'none');
alpha(.3); 

set(0, 'DefaultFigureRenderer', 'painters');
figure(2).Renderer='Painters';
figure(1).Renderer='Painters';

%% 6 AUC before and after
e = 2; %user changes e to define how many seconds before and after a pulse train
%they want to examine. Make sure e here matches e for making graphs
 [beforeAUC1, afterAUC1] = extractdataSTIM(train_stamps1, times, zscoreDFF, e);
 [beforeAUC2, afterAUC2] = extractdataSTIM(train_stamps2, times, zscoreDFF, e);
 [beforeAUC4, afterAUC4] = extractdataSTIM(train_stamps4, times, zscoreDFF, e);
 [beforeAUC8, afterAUC8] = extractdataSTIM(train_stamps8, times, zscoreDFF, e);
 
 %use before and after to make ANOVAs in Prism
 

%% 7 Latency to percent maxs
%How much time to reach a percentage of the peak's max, from 1-100

latencyPercentMax8 = latencyPercentMax(averagedDFF8, averagedTimeDiff8);
latencyPercentMax4 = latencyPercentMax(averagedDFF4, averagedTimeDiff4);
latencyPercentMax2 = latencyPercentMax(averagedDFF2, averagedTimeDiff2);
latencyPercentMax1 = latencyPercentMax(averagedDFF1, averagedTimeDiff1);

%% 8 duration between half-maxs
%Gives you the time to 1st half-max and time to 2nd half-max

width1 = widthAtHalfMax(averagedZScore1, averagedTimeDiff1);
width2 = widthAtHalfMax(averagedZScore2, averagedTimeDiff2);
width4 = widthAtHalfMax(averagedZScore4, averagedTimeDiff4);
width8 = widthAtHalfMax(averagedZScore8, averagedTimeDiff8);

%% 9 binning data

%Get visual representation of how stimulation of one pulse-type changes
%across time

b = 5; %user defines b as minutes per bin
[binFig,x, binAvgZ, binAvgT] = BinningTrains(times, train_stamps8, sessionDFF, zscoreDFF, b);

title('4 pulses, Baseline');

%% 10 height of individual peaks
%Get the peak value after every instance of stimulation

r = .5;
%r is how much time after stimulation to look for max value. change
%accordingly depending on your data
for i = 1:length(train_stamps1)
    a = find(times == train_stamps1(i));
    b = find(times >= train_stamps1(i) + r, 1, 'first');
    heights1(i) = max(zscoreDFF(a:b));
end

for i = 1:length(train_stamps2)
    a = find(times == train_stamps2(i));
    b = find(times >= train_stamps2(i) + r, 1, 'first');
    heights2(i) = max(zscoreDFF(a:b));
end

for i = 1:length(train_stamps4)
    a = find(times == train_stamps4(i));
    b = find(times >= train_stamps4(i) + r, 1, 'first');
    heights4(i) = max(zscoreDFF(a:b));
end

for i = 1:length(train_stamps8)
    a = find(times == train_stamps8(i));
    b = find(times >= train_stamps8(i) + r, 1, 'first');
    heights8(i) = max(zscoreDFF(a:b));
end
    
heights1 = heights1'; heights2 = heights2'; heights4 = heights4'; heights8=heights8';


%% Section B: Making combined figures
%This section will allow you to make one single figure displaying
%recordings from every animal
%% Making combined figure - STEP 1
%save the data for combined plot by
%FILENAME = [averagedTimeDiff8;averagedZScore8]
% csvwrite('FILENAME.csv', FILENAME);

%Import data for individual animals 1 by 1
%Delete x and y
%After every animal imported, move to step2

% x = VarName1; y = VarName2;
hold on
plot(x,y);
hold on

%% Making combined figure - STEP 2
%change title and axis labels as necessary
set(gca, 'fontname', 'Arial', 'FontSize', 10);
title('MNV VTA Combined');
xlabel('Time Relative to 8-Pulse Train (s)');
ylabel('dF/F (Z-Score)');
%change legend to reflect animal ID number
legend('MNV1', 'MNV2', 'MNV3', 'MNV4', 'MNV5', 'MNV7');
hold on;
%change axis and 0 line to match those of the previously made graphs
axis([-2 2 -.5 8])
plot([0, 0],[-.5, 8], 'k--');

%Save files in both .pdf and .fig format

