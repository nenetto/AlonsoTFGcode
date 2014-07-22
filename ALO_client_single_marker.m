%% Client for Optitrack and Robot (server) to collect position information

clear all
home


%% Settings

calibration_file = 'CalibrationResult 2014-07-04 12.16pm.cal'  % Optitrack calibration file
number = 100;    % number of averaged measures per point
total = 3;     % total number of points of the trajectory
%marker = input('number of the marker (zero based from pivot)? [4 by default] \n');
%if isempty(filename)
	marker = 4;
%end

%filename = input('name of the file? \n','s');
%if isempty(filename)
	filename = ['data_client_', datestr(now,30)];   % csv file name
%end
disp(sprintf('Data file name: %s.txt', filename))



%% Script

% Ready Optitrack system in Matlab, including calibration
LIM_Optitrack_ON(calibration_file);

% Loads marker positions of trackable and its pointer (tip)
LIM_cargarPunteroLIM();


% Start tracking
disp('Starting to track');

for i = 1:total
    disp('Ready for next point')
    system('pause')

    % Start tracking and saving positions:
    ALO_trackear_single_marker('myTrack',number,marker)
    load('myTrack.mat');    % Loads position data (Datos) from saved file
    
    %Points = zeros(3,number);
    %Points(:) = [Datos(1,4,:) Datos(2,4,:) Datos(3,4,:)];
    
    dlmwrite([filename, '.txt'], Datos, '-append');

end

disp('THE END')
