step = 0.5;
ALO_my_path_matlab();

filename = 'MainModule.mod';

fid = fopen(filename, 'wb');
fprintf(fid, 'MODULE MainModule\n');

for g = 1:n
    fprintf(fid, sprintf('\tCONST robtarget Target_%d:=[[%s,%s,%s],[0.5,0,0.866025404,0],[%s,%s,%s,%s],[9E9,9E9,9E9,9E9,9E9,9E9]];\n',g,x_pos(g,:),y_pos(g,:),z_pos(g,:),x1_pos(g,:),x2_pos(g,:),x3_pos(g,:),x4_pos(g,:)));
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