
numero = 3;
pos_polaris = zeros(3,numero+1);
for j = 0:numero
    ALO_cargarPunteroPolaris(j);
    [Xp,Yp,Zp,qx,qy,qz,qw,yaw,pitch,roll] = calllib('NPTrackingToolsx64', 'TT_TrackableLocation',0,Xp,Yp,Zp,qx,qy,qz,qw,yaw,pitch,roll);
    pos_polaris(1,j+1) = Xp;
    pos_polaris(2,j+1) = Yp;
    pos_polaris(3,j+1) = Zp;
end