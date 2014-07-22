% Limits x, y, z (mm)
x = 600:step:900;
y = -500:step:500;
z = 300:step:700;

% Calculates path on borders of limits:
i = 1;
k = 1;
Path = [repmat(x(i),length(y),1) y' repmat(z(k),length(y),1)];
j = length(y);
Path = [Path; [x(2:length(x)-1)' repmat(y(j),length(x)-2,1) repmat(z(k),length(x)-2,1)]];
i = length(x);
Path = [Path; [repmat(x(i),length(y),1) fliplr(y)' repmat(z(k),length(y),1)]];
j = 1;
Path = [Path; [repmat(x(i),length(z)-2,1) repmat(y(j),length(z)-2,1) z(2:length(z)-1)']];
k = length(z);
Path = [Path; [repmat(x(i),length(y),1) y' repmat(z(k),length(y),1)]];
j = length(y);
Path = [Path; [fliplr(x(2:length(x)-1))' repmat(y(j),length(x)-2,1) repmat(z(k),length(x)-2,1)]];
i = 1;
Path = [Path; [repmat(x(i),length(y),1) fliplr(y)' repmat(z(k),length(y),1)]];
j = 1;
% total number of points
n = size(Path,1);
% x y z coord
x_pos = num2str(Path(:,1));
y_pos = num2str(Path(:,2));
z_pos = num2str(Path(:,3));
% final tool axis configuration
qx_pos = num2str(repmat(0.5,n,1)); 
qy_pos = num2str(repmat(0,n,1)); 
qz_pos = num2str(repmat(0.866025404,n,1));
qw_pos = num2str(repmat(0,n,1));

% robot axis conf. depending on y (neg, 0, pos) and on z<500
where_y_zero = find(Path(:,2)==0);
where_y_neg = find(Path(:,2)<0);
where_z = find( Path(:,3)<500 );
where_z_y = find( Path(where_y_zero,3)<500 );
where_z_y_neg = find( Path(where_y_neg,3)<500 );

axis_pos = zeros(n,4);
axis_pos(where_z,:) = repmat([0,0,-1,1],length(where_z),1);
axis_pos(where_y_neg(where_z_y_neg),:) = repmat([-1,1,-2,0],length(where_z_y_neg),1);
axis_pos(where_y_zero(where_z_y),:) = repmat([0,0,0,1],length(where_z_y),1);

x1_pos = num2str(axis_pos(:,1));
x2_pos = num2str(axis_pos(:,2));
x3_pos = num2str(axis_pos(:,3));
x4_pos = num2str(axis_pos(:,4));
% By default, non specified = 9E9
x5_pos = repmat('9E9',n,1);
x6_pos = repmat('9E9',n,1);
x7_pos = repmat('9E9',n,1);
x8_pos = repmat('9E9',n,1);
x9_pos = repmat('9E9',n,1);
x10_pos = repmat('9E9',n,1);