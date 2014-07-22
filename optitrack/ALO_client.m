%% Client for Optitrack and Robot (server) to collect position information

clear all
home

%% Settings

IPclient = 'localhost';
RemotePort = 30000;
% Seconds checking BytesAvailable for a message until exiting
scan_timeout = 30;

% Optitrack calibration file
calibration_file = 'CalibrationResult 2014-06-02 4.03pm.cal';
% number of measures for each point to make the average
number = 50;
% total number of points of the trajectory
total = 36;

% csv file name
filename = input('name of the file? \n','s');
if isempty(filename)
	filename = ['data_client_', datestr(now,30)];
end



%% Script

% Ready Optitrack system in Matlab, including calibration
LIM_Optitrack_ON(calibration_file);

% Loads marker positions of trackable and its pointer (tip)
LIM_cargarPunteroLIM();

% Loads client and connects to server
t = tcpip(IPclient, RemotePort, 'NetworkRole', 'client');
fopen(t)

pause(1)
if ~( strcmp(get(t, 'Status'),'open') )
    disp('WARN: connection is not open');
end


% Start tracking
disp('Starting to track');

receive = [];
FinalData = zeros(total,7);
%Points = zeros(3,number);    % Points = zeros(3,size(Datos,3));

for i = 1:total
    disp('Ready for next point')
    system('pause')

    % Start tracking and saving positions:
    LIM_trackear('myTrack',number)
    load('myTrack.mat');    % Loads position data (Datos) from saved file
    
    % Calculate average and std. deviation
    Points = zeros(3,number);
    Points(:) = [Datos(1,4,:) Datos(2,4,:) Datos(3,4,:)];
    Points = Points';
    % Difference with mean
    Diff = Points - repmat(mean(Points), size(Points,1), 1);
    % Std deviation
    stddev = mean(sqrt(sum(Diff.^2, 2)));
    
    FinalData(i,1) = stddev;  % Store std. deviation
    FinalData(i,2:4) = mean(Points);    % Store optitrack mean point (centroid)
    
    disp('Requesting next point to server')
    fprintf(t, 'next');
    
    % FinalData(i,5:7) = fscanf(t, '%f\n%f\n%f')';
    
    disp('Reading')
    j = 0;
    while(j < scan_timeout)
        if( get(t, 'BytesAvailable') > 0)
            receive = fscanf(t, '%f');
            
            bytes = get(t, 'BytesAvailable');   % Checks is entire message
            while( bytes > 0)
                disp( sprintf('WARN: Message incomplete.\n\tMessage: %s\tBytes available: %d',receive,bytes));
%                 rescan = input('re-scan? [0/1]\n');
%                 if (rescan)
%                     receive = [receive fscanf(t, '%f')];
%                     bytes = get(t, 'BytesAvailable');
%                 else
                    break;
%                 end
            end
            
            j = 0;
            break
        else
            pause(1)
            j = j+1;
        end
    end
    
    if ~isempty(receive)
        disp('Copying data') 
        FinalData(i,5:7) = receive;
    end

end

csvwrite([filename, '.txt'], FinalData);   % strcat(filename,'.txt') also [myname, '.txt']
disp('Requesting communication ending')
fprintf(t, 'end');

fclose(t)
delete(t)
clear t
disp('Transmission closed')

% unload library, but it usually causes Matlab to crash
% unloadlibrary('NPTrackingToolsx64')

% Displaying tracked points with std deviation
% Works in 3D, but will not adapt to zoom nor axes changes)
if(false)
    figure
    s = 2*FinalData(:,1);   % Marker full width in units of X
    h = scatter3(-FinalData(:,3), -FinalData(:,2), FinalData(:,4)); % Create a scatter plot and return a handle
    axis([-0.5 1 -0.5 1])   % Custom axes dimension before drawing error
    
    %Obtain the axes size (in axpos) in Points
    currentunits = get(gca,'Units');
    set(gca, 'Units', 'Points');
    axpos = get(gca,'Position');
    set(gca, 'Units', currentunits);
    markerWidth = s./diff(xlim).*axpos(3); % Calculate Marker width in points
    set(h, 'SizeData', markerWidth.^2)  % Marker as square area

end