function [Datos] = ALO_trackear_single_marker(file_name,N,marker)

% Esta función guarda N Muestras del trackable con ID = 0

data_file = file_name;%[file_name,'.mat'];

ID = 0;
contador = N;
contador2 = 0;
Datos = zeros(3,N);

% Deficinición de variables
X = 0;Y = 0;Z = 0;
Xp = 0;Yp = 0;Zp = 0;
qx = 0;qy = 0;qz = 0;qw = 0;
yaw = 0;pitch = 0;roll = 0;


%%
while(true)
    calllib('NPTrackingToolsx64', 'TT_Update');
    if(calllib('NPTrackingToolsx64', 'TT_IsTrackableTracked',0) == 1)
        contador2 = 0;
        [Xp,Yp,Zp,qx,qy,qz,qw,yaw,pitch,roll] = calllib('NPTrackingToolsx64', 'TT_TrackableLocation',0,Xp,Yp,Zp,qx,qy,qz,qw,yaw,pitch,roll);
        n_markers = calllib('NPTrackingToolsx64', 'TT_FrameMarkerCount');
        pos_markers = zeros(3,n_markers);
        for i = 1:n_markers
            pos_markers(1,i) = calllib('NPTrackingToolsx64', 'TT_FrameMarkerX',i);
            pos_markers(2,i) = calllib('NPTrackingToolsx64', 'TT_FrameMarkerY',i);
            pos_markers(3,i) = calllib('NPTrackingToolsx64', 'TT_FrameMarkerZ',i);
        end
        
        %compare((1+3*(N-contador)):(3+3*(N-contador)),:) = [pos_markers [Xp Yp Zp]' abs((pos_markers-repmat([Xp;Yp;Zp],1,n_markers)))];
        compare = sum(abs(pos_markers-repmat([Xp;Yp;Zp],1,n_markers)));
        %compare = sqrt(sum((pos_markers-repmat([Xp;Yp;Zp],1,n_markers).^2)));
        index = find(compare == min(compare(compare > 0)));
        
        if(~isnan(X))
        
        Datos(:,contador) = [pos_markers(1,index); pos_markers(2,index); -pos_markers(3,index)]*1000;
        
%         for i=1:10
%               disp(['[' ,num2str(Datos(1,contador)), ',' , num2str(Datos(2,contador)) ,  ',' , num2str(-Datos(3,contador)) , ',' , num2str(index) ']']);
%         end
        %disp([Datos(1,contador); Datos(2,contador); Datos(3,contador)])

        contador = contador - 1;
        %pause(1e-400)
        end
    else
        disp('Trackable not tracked')
        contador2 = contador2 + 1;
    end
    
    
    if((contador == 0)||(contador2 == N))
        break;
    end
    
%     pause(0.002);

end
    
%% Guardar los datos

% save(data_file,...
% 'Datos');
% close all

%clear Datos
disp('FIN')

end
