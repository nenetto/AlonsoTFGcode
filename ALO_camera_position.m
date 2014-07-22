%% Function to obtain the cameras position
function [ncamera, pos_cam] = ALO_camera_position(calibration_file)

calllib('NPTrackingToolsx64', 'TT_Update');
ncamera = calllib('NPTrackingToolsx64', 'TT_CameraCount');

pos_cam = zeros(ncamera,3);
for i = 1:ncamera
    pos_cam(i,1) = calllib('NPTrackingToolsx64', 'TT_CameraXLocation',i);
    pos_cam(i,2) = calllib('NPTrackingToolsx64', 'TT_CameraYLocation',i);
    pos_cam(i,3) = calllib('NPTrackingToolsx64', 'TT_CameraZLocation',i);
end

end