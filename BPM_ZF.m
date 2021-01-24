%% Informations about author and program ----------------------------------
% Program: BPM_ZF (Beats Per Minute Zebrafish)
% Description: Analyzes the heart rhythm of the zebrafish embryo and
%              checks whether the time series of heartbeats are within
%              the given range
% Author: Paweł Łabuz
% Version: v.1.0 (24.01.2021)
% License: CC0

%% Calibration ------------------------------------------------------------
table = readtable( 'program_calibration.txt' );
calibrationTab = table.( 'Var2' );

findHeartAutomatically = calibrationTab( 1 );
findHeartAutomaticallyMethod = calibrationTab( 2 );
heartArea = calibrationTab( 3 );
timeSeriesError = calibrationTab( 4 );
timeSkip = calibrationTab( 5 );

%% Variables --------------------------------------------------------------
frames = 0;
frameHeight = 0;
frameWidth = 0;
cropX = 0;
cropY = 0;
cropLengthX = 0;
cropLengthY = 0;
timeSeriesErrorBool = false;

%% Import video -----------------------------------------------------------
[ file, path ] = uigetfile( '*.AVI' );

videoFileReader = VideoReader( fullfile( path, file ) );
depVideoPlayer = vision.DeployableVideoPlayer;

%% Read frames from file --------------------------------------------------
videoFrameCell = cell( [], 1 ) ;
frameRate = videoFileReader.FrameRate;
videoFileReader.CurrentTime = timeSkip;

while hasFrame( videoFileReader )
    frames = frames + 1;
    videoFrameCell{ frames } = readFrame( videoFileReader );
end

%% Find heart -------------------------------------------------------------
% If 0 - determine the location of the heart manually, if 1 - determine the
% location of the heart automatically
if findHeartAutomatically == 0
    [ cropX, cropY, cropLengthX, cropLengthY, frameHeight, frameWidth ] = manualLocateHeart( videoFrameCell );
else
    [ cropX, cropY, cropLengthX, cropLengthY, frameHeight, frameWidth ] = automaticLocateHeart( videoFrameCell, findHeartAutomaticallyMethod, heartArea );
end

%% BPM and Time series ----------------------------------------------------
meanValueArray = averageValuePixelArray( videoFrameCell, frames, cropX, cropY, cropLengthX, cropLengthY );

% Calculate avarage distance between between adjacent maxima / minima
MinPeakDistanceAVG = calculateMinimumDistancePoints( meanValueArray );

% Find maxima
[ peakY, peakX ] = findpeaks( meanValueArray, 'MinPeakDistance', MinPeakDistanceAVG * 0.25 );
% and minima
[ valleyY, valleyX ] = findpeaks( -meanValueArray, 'MinPeakDistance', MinPeakDistanceAVG * 0.25 );

numberOfElementsMax = size( peakX );
countMaxima = numberOfElementsMax( 2 );
numberOfElementsMin = size( valleyY );
countMinimums = numberOfElementsMin( 2 );

peakDistance = calculatePeakDistance( countMaxima, peakX );

% Viudeos last less than a minute, so to display the result in the correct 
% unit, there's a need to create a variable which, when multiplied by the 
% obtained data, will give the results in a correct unit
timeScale = 60 / ( frames / frameRate );

% check if time series is in range
[ timeSeriesErrorBool, averageDisctanceTab, averageDisctanceUpperError, averageDisctancelowerError ] = calculateTimeSeriesBool( countMaxima, peakX, timeSeriesError );

% Determine BPM
BPM = ( ( countMaxima * timeScale ) + ( countMinimums * timeScale ) ) / 2;

%% Display BPM graph and times series graph -------------------------------
drawGraph( frames, meanValueArray, peakX, peakY, valleyX, -valleyY, frameRate, peakDistance, averageDisctanceTab, averageDisctanceUpperError, averageDisctancelowerError, timeSeriesError, BPM );

%% Save and display video with informations -------------------------------
displayVideo( frameRate, videoFrameCell, BPM, frames, timeSeriesErrorBool, cropX, cropY, cropLengthX, cropLengthY, frameHeight, heartArea, findHeartAutomatically, depVideoPlayer );
