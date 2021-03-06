# photometry-recording-w-stim
Preparing MATLAB for your first time using OptoStimRecording…
-	Save and unzip the latest version of OptoStimRecording.zip
-	Copy and paste the unzipped files to a specific directory location where you will be working.
o	For example, /Users/sikemoto/Documents/MATLAB/RD-MPFC Project/OptoStimRecording
o	Wherever you save the code, your directory MUST be in that location. You can see your current working directory in the highlighted area.



Basic background of OptoStimRecording.m

-	Open the script titled OptoStimRecording.m . This is the main script that the user interacts with.
-	The script is divided into two main parts.
o	Part A will allow you to extract data from individual animals and create photometry traces for the individual animals.
o	Part B will combine the photometry traces for every animal onto one graph.
-	This script is divided into different numbered sections. To run each section one at a time, click the cursor into the section you want to run – which will highlight the section yellow
– and click “Run Section.” The screenshot below, for example, will run Section 4.
 
 

-	Importing raw data: Save the csv file into your MATLAB working directory. Double click on the file, make sure “Output Type” is “Column vectors” and press “Import Selection”


 


 
Using OptoStimRecording - Part A: Data and Graphs for Individual Animals

Below is a summary flowchart for navigating Part A. This provides the order to run individual sections, and what each section will accomplish. Sections 5 and 6 are the respective sections where graphs are made, and data is extracted for statistical analysis.



Section 1 – Load data from one animal

-	Import your data. We recorded photometry signaling from two different animals in a given session.
o	Animal 1: GCaMP recorded in AIn1, Control recorded in AIn2
o	Animal 2: GCaMP recorded in AIn3, Control recorded in AIn4
-	Use EITHER 1A or 1B to load in the raw data from either animal. After that, progress through the rest of the steps before loading in the data from the other animal.
-	Run section 1 TROUBLESHOOT if the imported data has ‘NaN’ in the first row

Section 2 – Converting to DFF
 
-	Run 2A if you are converting the raw data to dF/F without time bins.
-	Run 2B if you are converting raw data to dF/F after time-binning your data. We binned our data into 1 minute time bins. To change the size of the time bins, go to dffCalculation_RD_Jan4_2019.m and change the value of the variable called dffBins.

Section 3 – Parse out the timestamps for stimulation trains
-	Run 3A if the experiment used stimulation trains of 1, 2, 4, 8 pulses.
-	Run 3B if the experiment used stimulation trains of 2, 4, 8, 16 pulses.
o	Note: To avoid having too many different types of train_stamps variables, the 2, 4, 8, 16 timestamps will be named train_stamps1, train_stamps2, train_stamps4, and train_stamps8 respectively.
-	3-TROUBLESHOOT1 will fix issues where the code doesn’t properly parse out the correct amount of pulse trains. Follow instructions in the comments.
-	3-TROUBLESHOOT2 will fix issue where decimation counts an instance of 2-pulses as 1-pulse, so that there are two more 2-pulses than 1-pulse. Follow instructions in the comments.

Section 4 – Average the photometry before/after stimulation to display on a graph
-	Change the variable “e” to reflect how many seconds before and after stimulation you want to display on the graph.
-	This script will find every instance of the different stimulation trains and average the photometry traces e seconds before and after the stimulation train.
-	Can move on to Part B to make the combined figure.

Section 5 – Creating figure for individual animal
-	This section will create figures similar to that shown below. Edit the legends and titles directly in the OptoStimRecording.m script as needed.

 
-	5 OPTIONAL1 will put lines on the graph to indicate the time to half-max for the 8/16- pulse stimulation train.




-	5 OPTIONAL2 will add error bar shading to the graph.



-	IMPORTANT: Before saving the figure in both pdf and fig format…
o	File>Print Preview
 
 

o	Confirm ‘Color’ is set to ‘RGB’

o	Confirm ‘Renderer’ is set to ‘painters’


Section 6 – Extracting the area under the photometry curve before and after stimulation for future statistical analysis
-	We use the AUC before and after every stimulation train for statistical analysis.
-	Copy and paste the before/after variables into an excel sheet, organized in a way that is easy to put into Prism for ANOVA.
