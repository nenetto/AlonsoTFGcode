step = 0.5;
% Limits x, y, z
x = 500:step:800;
y = -500:step:500;
z = 300:step:700;

filename = 'MainModule.mod';

fid = fopen(filename, 'wb');
fprintf(fid, 'MODULE MainModule\n');

n = 0;
i = 1;
k = 1;
for j = 1:length(y)
    n = n + 1;
    fprintf(fid, sprintf('\tCONST robtarget Target_%d:=[[%.1f,%.1f,%.1f],[0.5,0,0.866025404,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];\n',n,x(i),y(j),z(k)));
end

for i = 1:length(x)
    n = n + 1;
    fprintf(fid, sprintf('\tCONST robtarget Target_%d:=[[%.1f,%.1f,%.1f],[0.5,0,0.866025404,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];\n',n,x(i),y(j),z(k)));
end

yp = fliplr(y);
for j = 1:length(yp)
    n = n + 1;
    fprintf(fid, sprintf('\tCONST robtarget Target_%d:=[[%.1f,%.1f,%.1f],[0.5,0,0.866025404,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];\n',n,x(i),yp(j),z(k)));
end

for k = 1:length(z)
    n = n + 1;
    fprintf(fid, sprintf('\tCONST robtarget Target_%d:=[[%.1f,%.1f,%.1f],[0.5,0,0.866025404,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];\n',n,x(i),yp(j),z(k)));
end

for j = 1:length(y)
    n = n + 1;
    fprintf(fid, sprintf('\tCONST robtarget Target_%d:=[[%.1f,%.1f,%.1f],[0.5,0,0.866025404,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];\n',n,x(i),y(j),z(k)));
end

xp = fliplr(x);
for i = 1:length(xp)
    n = n + 1;
    fprintf(fid, sprintf('\tCONST robtarget Target_%d:=[[%.1f,%.1f,%.1f],[0.5,0,0.866025404,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];\n',n,xp(i),y(j),z(k)));
end

for j = 1:length(yp)
    n = n + 1;
    fprintf(fid, sprintf('\tCONST robtarget Target_%d:=[[%.1f,%.1f,%.1f],[0.5,0,0.866025404,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];\n',n,xp(i),yp(j),z(k)));
end
fprintf(fid, '\tPROC main()\n');
fprintf(fid, '\t\tPath_10;\n');
fprintf(fid, '\tENDPROC\n');
fprintf(fid, 'ENDMODULE\n');

fclose(fid);

fid2 = fopen('MyModule.mod', 'wb');
fprintf(fid2, 'MODULE MyModule\n');
fprintf(fid2, '\tPROC Path_10()\n');
for l = 1:n
    fprintf(fid2, '\t\tMoveJ Target_%d,vmax,fine,tool0\\WObj:=wobj0;\n',l);
end

fprintf(fid2, '\tENDPROC\n');
%fprintf(fid2, '\tPath_10;\n');
fprintf(fid2, 'ENDMODULE\n');

fclose(fid2);

%mypath = repmat(sprintf('\tCONST robtarget Target_%d:=[[%f,%f,%f],[0.5,0,0.866025404,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];\n',n,x,y,z),3,1);