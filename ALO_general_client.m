%% Program to run the different client modes
% Real Robot and optitrack
% Real Robot only
% Simu Robot and Optitrack
% Simu Robot only

clear all
home


%% Settings

% Optitrack calibration file
calibration_file = 'CalibrationResult 2014-07-16 3.25pm.cal'
% number of averaged measures per point
number = 2000;

% step between trajectory points (mm)
step = 20;
% Trajectory points (mm) in robot coordinate system
ALO_my_path_matlab();
% final point of path
final_point = n;

% 127.0.0.1 (local) for simulation
IPhost = '192.168.125.1';
RemotePort = 3000;
% Seconds checking BytesAvailable before exiting
scan_timeout = 30;

%filename = input('name of the file? \n','s');
%if isempty(filename)
    % folder = 'Data\\';
	filename = ['data_client_', datestr(now,30)];   % csv file name
%end
%disp(sprintf('Data file name: %s.txt', filename))
