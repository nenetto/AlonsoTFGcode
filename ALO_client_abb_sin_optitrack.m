%% Client to communicate with ABB Robot to send position

clear all
home


%% Settings

% Optitrack calibration file
%calibration_file = 'CalibrationResult 2014-06-17 11.15am.cal';
% number of measures for each point to make the average
%number = 1000;

% step between trajectory points (mm)
step = 100;
% Trajectory points (mm) in robot coordinate system
%robot_data_file = 'ALO_traj_1.txt';
%ALO_parse();
ALO_my_path_matlab();
initial_point = 1;
final_point = n;

IPhost = '192.168.125.1';
%IPhost = '127.0.0.1'; %(local, for simulation with robotstudio)
RemotePort = 3000;
% Seconds checking BytesAvailable for a message until exiting
scan_timeout = 30;

% csv file name
%filename = input('name of the file? \n','s');
%if isempty(filename)
	filename = ['data_client_', datestr(now,30)]; % Data\\
%end
disp(sprintf('Data file name: %s.txt', filename))





%% Script

% Ready Optitrack system in Matlab, including calibration
%LIM_Optitrack_ON(calibration_file);

% Loads marker positions of trackable and its pointer (tip)
%LIM_cargarPunteroLIM();

% Loads client and connects to server
t = tcpip(IPhost, RemotePort, 'NetworkRole', 'client');
pause(2)
disp('Waiting for open connection...')
fopen(t);

pause(3)
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


% Start tracking
%disp('Starting to track');

scan = [];
%FinalData = zeros(n,7);

pause(3)
disp('Requesting check connection')
fprintf(t, '0');    % Order to check connection
pause(3)

scan = ALO_wait_message(t,scan_timeout);
if ( scan == 1 )
    disp('Received ok connection')
else
    disp('Failed to receive ok connection')
end


for i = initial_point:final_point %1:n
    
    dlmwrite([filename, '.txt'], [str2num(x_pos(i,:)) str2num(y_pos(i,:)) str2num(z_pos(i,:))], '-append');

    disp('Ready for next point of trajectory')
    disp(i)
    disp('Requesting positioning state')
    fprintf(t, '1');    % Order to get position
    
    scan = ALO_wait_message(t,scan_timeout);
    if ( scan == 4 )
        disp('Received ok ready')
    else
        disp('Failed to receive ok ready')
    end
    
    %pause(5)    
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
    %pause(10)
    
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
    
    disp('Now Optitrack should be tracking...')
    
end

disp('Requesting communication ending')
fprintf(t, '2');    % Order end of communication
pause(2)

scan = ALO_wait_message(t,10);
if ( scan == 3 )
    disp('Received ok finalized')
else
    disp('Failed to receive ok finalized')
end


fclose(t);
delete(t)
clear t
disp('Transmission closed')










%% xtra code

% Calculate average and std. deviation
%     Points = zeros(3,number);
%     Points(:) = [Datos(1,4,:) Datos(2,4,:) Datos(3,4,:)];
%     Points = Points';
    % Difference with mean
%     Diff = Points - repmat(mean(Points), size(Points,1), 1);
%     % Std deviation
%     stddev = mean(sqrt(sum(Diff.^2, 2)));
%     
%     FinalData(i,1) = stddev;  % Store std. deviation
%     FinalData(i,2:4) = mean(Points);    % Store optitrack mean point (centroid)
    
%csvwrite([filename, '.txt'], FinalData);

% x_pos; y_pos; z_pos;
% 
% qx_pos; qy_pos; qz_pos; qw_pos;
% 
% x1_pos; x2_pos; x3_pos; x4_pos; x5_pos;
% 
% x6_pos; x7_pos; x8_pos; x9_pos; x10_pos;


% x_posLon; y_posLon; z_posLon;...	
% 	qx_posLon; qy_posLon; qz_posLon; qw_posLon;...
%     x1_posLon; x2_posLon; x3_posLon; x4_posLon;...	
%     x5_posLon; x6_posLon; x7_posLon; x8_posLon; x9_posLon; x10_posLon;...
%     x_pos; y_pos; z_pos;...
%     qx_pos; qy_pos; qz_pos; qw_pos;...
% 	x1_pos; x2_pos; x3_pos; x4_pos;...
% 	x5_pos; x6_pos; x7_pos; x8_pos; x9_pos; x10_pos

% 
% point = [x_posLon y_posLon z_posLon...	
% 	qx_posLon qy_posLon qz_posLon qw_posLon...
%     x1_posLon x2_posLon x3_posLon x4_posLon...	
%     x5_posLon x6_posLon x7_posLon x8_posLon x9_posLon x10_posLon...
%     x_pos y_pos z_pos...
%     qx_pos qy_pos qz_pos qw_pos...
% 	x1_pos x2_pos x3_pos x4_pos...
% 	x5_pos x6_pos x7_pos x8_pos x9_pos x10_pos];



%            % OK, but must specify correct string terminator (which is what?)
%                     scan = fscanf(t, '%f')
%                     scan = fscanf(t, '%f\n')
%                     scan = fscanf(t, '%f\n%f\n')
%                     scan = fscanf(t, '%f%f')
%                     scan = fscanf(t, '%f%f\n')