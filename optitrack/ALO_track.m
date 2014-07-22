%% TFG Alonso - Code to run Optitrack in Matlab and acquire position
%% data from the trackable pointer.

clear all, close all

% Ready Optitrack system in Matlab, including calibration.
% Loads shared library NPTrackingTools.h to be used by Matlab.
% Will initialize Tracking Tools (‘TT_Initialize’)
% ‘TT_LoadCalibration’ to load calibration data from a saved file (input).
% ‘TT_ClearTrackableList’ which deletes all previous rigid body data.
LIM_Optitrack_ON('CalibrationResult 2014-06-02 4.03pm.cal');

% Loads marker positions of trackable and its pointer (tip), in this case
% the trackable of the lab.
LIM_cargarPunteroLIM();

while(1)
    %clear all, close all
    home
    number = input('number of points? \n');
    if isempty(number)
          number = 2000;
    end
    
    disp('Proceed to track?');
    system('pause')
    % Start tracking and saving positions:
    LIM_trackear('myTrack',number)
    
    load('myTrack.mat');
    
    % Organizes data in a 500x12 matrix to save it separated in columns csv
    dim = size(Datos);
    myData = zeros((dim(1)*dim(2)),dim(3));
    myData(:) = Datos;
    myData = myData';
    
    figure, hold on;
    for i = 1:size(Datos,3)
        % Rotated image to visualize better (x and y swapped and inversed)
        scatter3((-1*Datos(2,4,i)), (-1*Datos(1,4,i)), Datos(3,4,i));
    end
    
    saving = input('save data? [1/0] \n');
    if saving
        myname = input('name of the file? \n','s');
        csvwrite(strcat(myname,'.txt'),myData);
    end
    
    rep = input('track again? [1/0] \n');
    if (~rep)
        break;
    end
    
     
end

% Image comparison with dot-to-dot. Set true to use.
if(false)
    figure, subplot(121)
    hold on;
    for i = 1:size(Datos,3)
        % Rotated image to visualize better (x and y swapped and inversed)
        plot3((-1*Datos(2,4,i)), (-1*Datos(1,4,i)), Datos(3,4,i));
    end
    hold off
    subplot(122)
    imshow(une,[])
end

if(false)
    % Extra code just in case...
    Points = zeros(3,size(Datos,3));
    Points(:) = [Datos(1,4,:) Datos(2,4,:) Datos(3,4,:)];
    Points = Points';
    
    figure, hold on;
    for i = 1:size(Points,1)
        % Rotated image to visualize better (x and y swapped and inversed)
        scatter3((-1*Points(i,2)), (-1*Points(i,1)), Points(i,3));
    end
end