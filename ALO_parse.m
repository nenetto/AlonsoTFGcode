%% Script to parse positioning data from RAPID to Matlab

fid = fopen('robot_data.txt');
%C = textscan(fid, 'CONST robtarget Target_%d:=[[%f,%f,%f],[%f,%f,%f,%f],[%f,%f,%f,%f],[%f,%f,%f,%f,%f,%f]];');

C = textscan(fid, 'CONST robtarget Target_%d:=[[%f,%f,%f],[%f,%f,%f,%f],[%f,%f,%f,%f],[%3s,%3s,%3s,%3s,%3s,%3s]];');

%C = textscan(fid, 'CONST robtarget Target_%d:=[[%s,%s,%s],[%s,%s,%s,%s],[%s,%s,%s,%s],[%s,%s,%s,%s,%s,%s]];');
%A = fscanf(fid,'CONST robtarget Target_%d:=[[%f,%f,%f],[%f,%f,%f,%f],[%f,%f,%f,%f],[%f,%f,%f,%f,%f,%f]];\n')';
%A = fscanf(fid,'%f, %f %f  %f %f %f %f  %f %f %f %f  %f %f %f %f %f %f]',[1,17]);

fclose(fid);

total = size(C{1,1},1);

x_pos = num2str(C{1,2});
y_pos = num2str(C{1,3});
z_pos = num2str(C{1,4});

qx_pos = num2str(C{1,5});
qy_pos = num2str(C{1,6});
qz_pos = num2str(C{1,7});
qw_pos = num2str(C{1,8});

x1_pos = num2str(C{1,9});
x2_pos = num2str(C{1,10});
x3_pos = num2str(C{1,11});
x4_pos = num2str(C{1,12});

x5_pos = char(C{1,13});
x6_pos = char(C{1,14});
x7_pos = char(C{1,15});
x8_pos = char(C{1,16});
x9_pos = char(C{1,17});
x10_pos = char(C{1,18});
