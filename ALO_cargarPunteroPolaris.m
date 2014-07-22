function ALO_cargarPunteroPolaris(marker)
%cargarPunteroPolarisfromPivoting Carga el Puntero de Polaris para su seguimiento
%
%   Las coordenadas de calibración son las extraídas mediante el pivoting
%   previamente realizado y guardado en OffsetPunteroPolaris.mat
   
%   E. Marinetto


% Eliminamos datos de trackables anteriores
calllib('NPTrackingToolsx64','TT_ClearTrackableList');

% Definición del puntero en RH
    bolaD_polaris = [100,-25,135];
    bolaC_polaris = [100,25,100];
    bolaB_polaris = [100,0,50];
    bolaA_polaris = [100,0,0];

    Puntero = [bolaA_polaris bolaB_polaris bolaC_polaris bolaD_polaris];
switch marker
    case 0
        Pivot = bolaA_polaris;
    case 1
        Pivot = bolaB_polaris;
    case 2
        Pivot = bolaC_polaris;
    case 3
        Pivot = bolaD_polaris;
end

% Paso a mm y 
Puntero = Puntero/1000;
Pivot = Pivot/1000;
% Niego la Z
Puntero = Puntero .* repmat([1 1 -1],1,4);
Pivot(3) = -Pivot(3);
% Defino la herramienta
puntos_definicion = libpointer('singlePtr',Puntero);
calllib('NPTrackingToolsx64', 'TT_CreateTrackable','PunteroPolarisCT',0,4,puntos_definicion);


% Traslado el pivot (no es necesario porque es el 0,0,0)
calllib('NPTrackingToolsx64', 'TT_TrackableTranslatePivot',0,Pivot(1),Pivot(2),Pivot(3));



end