%% Client for Optitrack and Robot (server) to collect position information

clear all

%% Settings
% csv file name
filename = 'data_stddev_points'; %input('name of the file? \n','s');

IPclient = 'localhost';
RemotePort = 30000;
% Seconds checking BytesAvailable for a message until exiting
scan_timeout = 30;

% number of measures for each point to make the average
number = 10;
% total number of points of the trajectory
total = 2;



%% Script
home
% Loads client and connects to server
t = tcpip(IPclient, RemotePort, 'NetworkRole', 'client');
fopen(t)

pause(1)
if ~( strcmp(get(t, 'Status'),'open') )
    disp('WARN: connection is not open');
end


% Start tracking

%disp('Proceed to track?');
%system('pause')

load('myTrack.mat');
receive = [];
FinalData = zeros(total,7);

for i = 1:total
    disp('Next set of data')
    Points = zeros(3,number);
    % Calculate average and std. deviation
    Points(:) = [Datos(1,4,(i*number-9):i*number) Datos(2,4,(i*number-9):i*number) Datos(3,4,(i*number-9):i*number)];
    Points = Points';
    % Difference with mean
    Diff = Points - repmat(mean(Points), size(Points,1), 1);
    % Std deviation
    stddev = mean(sqrt(sum(Diff.^2, 2)));
    
    FinalData(i,1) = stddev;  % Store std. deviation
    FinalData(i,2:4) = mean(Points);    % Store optitrack mean point (centroid)
    
    disp('Requesting next')
    %system('pause')
    fprintf(t, 'next');
    
    disp('Reading')
    j = 0;
    while(j < scan_timeout)
        if( get(t, 'BytesAvailable') > 0)
            receive = fscanf(t, '%f');
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
        % fprintf(t, 'wait');
    end

end

csvwrite([filename, '.txt'], FinalData);   % strcat(filename,'.txt') also [myname, '.txt']
disp('Requesting communication ending')
fprintf(t, 'end');

fclose(t);
delete(t)
clear t  
disp('Transmission closed')