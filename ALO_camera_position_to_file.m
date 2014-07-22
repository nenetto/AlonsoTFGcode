%% Function to obtain the cameras position

calibration_file = 'CalibrationResult 2014-07-21 1.01pm.cal';
name = ['camera_position', '.txt'];

LIM_Optitrack_ON(calibration_file);

[ncameras, pos_cam] = ALO_camera_position(calibration_file);

fid = fopen(name, 'a');
fprintf(fid, [datestr(now) '\n']);
dlmwrite(name, pos_cam, '-append');
fclose(fid);
