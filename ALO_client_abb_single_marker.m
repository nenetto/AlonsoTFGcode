%% Client for Optitrack and Robot (server) to collect position information

clear all
clc


%% Settings

% Optitrack calibration file
calibration_file = 'CalibrationResult 2014-07-21 1.01pm.cal'
number = 2000;    % number of averaged measures per point

% puntero = input('type of tool? (1)NDI (2)LIM (3)star\n');
puntero = 1;
% CARE! zero-based
marker = 3;
occluded = 1;
position = 'front-left';

% step between trajectory points (mm)
step = 20;
% Trajectory points (mm) in robot coordinate system
ALO_my_path_matlab();
% initial and final points of path
initial_point = 1;
final_point = n;

% 127.0.0.1 (local) for simulation
IPclient = '192.168.125.1';
RemotePort = 3000;
% Seconds checking BytesAvailable before exiting
scan_timeout = 30;

foldername = ['data_' datestr(now,30)];
mkdir(foldername);




%% Script

% Ready Optitrack system in Matlab, including calibration
LIM_Optitrack_ON(calibration_file);

[ncameras, pos_cam] = ALO_camera_position(calibration_file);

% Save configuration file
fid = fopen([foldername '\\config_' foldername '.txt'], 'wb');
fprintf(fid, sprintf('ALO_client_abb_single_marker.m \n%s \n\n',datestr(now)));
fprintf(fid, sprintf('Calibration:\t%s\n',calibration_file));

switch puntero
    case 1
        tool = 'NDI';
    case 2
        tool = 'LIM';
    case 3
        tool = 'star';
end
fprintf(fid, sprintf('Tool:\t%s\n',tool));
fprintf(fid, sprintf('Marker:\t%d\n',marker));
fprintf(fid, sprintf('Step:\t%d\n',step));
fprintf(fid, sprintf('Samples per point:\t%d\n',number));
fprintf(fid, sprintf('Number of points of trajectory:\t%d\n',n));
fprintf(fid, sprintf('Initial point of trajectory:\t%d\n',initial_point));
fprintf(fid, sprintf('Final point of trajectory:\t%d\n',final_point));
fprintf(fid, sprintf('Number of cameras:\t%d\n',ncameras));
fprintf(fid, sprintf('Number of occluded cameras:\t%d\t%s\n',occluded,position));
fprintf(fid, sprintf('\nCamera positions:\n'));
dlmwrite([foldername '\\config_' foldername '.txt'], pos_cam, '-append');
fclose(fid);


% Loads client and connects to server
t = tcpip(IPclient, RemotePort, 'NetworkRole', 'client');
pause(1)
fopen(t)

disp('Waiting for open connection...')
pause(1)
i = 0;
while(i < scan_timeout)
    if ~( strcmp(get(t, 'Status'),'open') )
        disp('...');
        pause(1)
        i = i+1;
    else
        disp('Opened')
        break
    end
end

scan = [];
pause(3)
disp('Requesting check connection')
fprintf(t, '0');
pause(3)

scan = ALO_wait_message(t,scan_timeout);
if ( scan == 1 )
    disp('Received ok connection')
else
    disp('Failed to receive ok connection')
end


% Loads marker positions of trackable and its pointer (tip)

switch puntero
    case 1
        ALO_cargarPunteroPolaris(marker);
    case 2
        LIM_cargarPunteroLIM();
    case 3
        %cargar puntero star
end

% Start tracking
disp('Starting to track');
disp(sprintf('%d points',n));

filename = [foldername, '\\data_client_', datestr(now,30)];

MaxRow = 100;
cont_file = 1;

for i = initial_point:final_point
    dlmwrite([filename, '.txt'], [str2num(x_pos(i,:)); str2num(y_pos(i,:)); str2num(z_pos(i,:))], '-append');
    
    disp('Ready for next point of trajectory')
    disp(i)
    disp('Requesting positioning state')
    fprintf(t, '1');
    
    scan = ALO_wait_message(t,scan_timeout);
    if ( scan == 4 )
        disp('Received ok ready')
    else
        disp('Failed to receive ok ready')
        break
    end
       
    x_posLon = ALO_mylength( x_pos(i,:));
    y_posLon = ALO_mylength( y_pos(i,:));
    z_posLon = ALO_mylength( z_pos(i,:));
    
    qx_posLon = ALO_mylength( qx_pos(i,:));
    qy_posLon = ALO_mylength( qy_pos(i,:));
    qz_posLon = ALO_mylength( qz_pos(i,:));
    qw_posLon = ALO_mylength( qw_pos(i,:));
    
    x1_posLon = ALO_mylength( x1_pos(i,:));
    x2_posLon = ALO_mylength( x2_pos(i,:));
    x3_posLon = ALO_mylength( x3_pos(i,:));
    x4_posLon = ALO_mylength( x4_pos(i,:));
    x5_posLon = ALO_mylength( x5_pos(i,:));
    x6_posLon = ALO_mylength( x6_pos(i,:));
    x7_posLon = ALO_mylength( x7_pos(i,:));
    x8_posLon = ALO_mylength( x8_pos(i,:));
    x9_posLon = ALO_mylength( x9_pos(i,:));
    x10_posLon = ALO_mylength( x10_pos(i,:));
        
    lon = [x_posLon y_posLon z_posLon...
        qx_posLon qy_posLon qz_posLon qw_posLon...
        x1_posLon x2_posLon x3_posLon x4_posLon...
        x5_posLon x6_posLon x7_posLon x8_posLon x9_posLon x10_posLon];
    
    disp('Sending lengths string')
    fprintf(t, lon);  % CARE: max. 80 characters in string
    
    scan = ALO_wait_message(t,scan_timeout);
    if ( scan == 5 )
        disp('Received ok length')
    else
        disp('Failed to receive ok length')
        break
    end

    point = [x_pos(i,:) y_pos(i,:) z_pos(i,:)...
        qx_pos(i,:) qy_pos(i,:) qz_pos(i,:) qw_pos(i,:)...
        x1_pos(i,:) x2_pos(i,:) x3_pos(i,:) x4_pos(i,:)...
        x5_pos(i,:) x6_pos(i,:) x7_pos(i,:) x8_pos(i,:) x9_pos(i,:) x10_pos(i,:)];
    
    disp('Sending positions string')
    fprintf(t, point);  % CARE: max. 80 characters in string
    %pause(5)
    
    scan = ALO_wait_message(t,scan_timeout);
    if ( scan == 2 )
        disp('Received ok positioned')
    else
        disp('Failed to receive ok positioned')
        break
    end

    % Once positioned, start tracking and saving points:
    disp('Now tracking with Optitrack...')
    Datos = ALO_trackear_single_marker('Track',number,marker);
    % Loads position data (Datos) from saved file
%     load('myTrack.mat');
    
    dlmwrite([filename, '.txt'], Datos, 'precision', 20, '-append');
    
    cont_file = cont_file +1;
    
    if(cont_file > MaxRow)
        filename = [foldername, '\\data_client_', datestr(now,30)];
        cont_file = 1;
    end

end

fid = fopen([foldername '\\config_' foldername '.txt'], 'a');
fprintf(fid,sprintf('\nTerminated at point:\t%d\n',i));
fclose(fid);

disp('Requesting communication ending')
fprintf(t, '2');    % Order end of communication
pause(2)

scan = ALO_wait_message(t,scan_timeout);
if ( scan == 3 )
    disp('Received ok finalized')
else
    disp('Failed to receive ok finalized')
end

fclose(t)
delete(t)
clear t
disp('Transmission closed')

% unload library, but it usually causes Matlab to crash
% unloadlibrary('NPTrackingToolsx64')
