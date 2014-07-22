figure
hold on
point_size = 0.0254/72; % 1/72 inches per point, to meters
%side = FinalData(36,1)*2/sqrt(2);
scatter3(FinalData(:,3), FinalData(:,2), FinalData(:,4), (FinalData(:,1)/point_size).^2);

scatter3(FinalData(36,3), FinalData(36,2), FinalData(36,4), 'SizeData',FinalData(36,1)/point_size);    %(FinalData(36,1)/point_size).^2

% Scaling not good, does not work
figure
point_size = 0.0254/72; % 1/72 inches per point, to meters
h = scatter3(-FinalData(:,3), -FinalData(:,2), FinalData(:,4));
axis([-0.5 1 -0.5 1])
set(h,'SizeData', (FinalData(:,1)/point_size).^2);


%% Bueno:

% GOOD, works and in 3D (but will not adapt to zoom nor axes)
figure
%hold on
s = 2*FinalData(:,1); % Marker full width in units of X
h = scatter3(-FinalData(:,3), -FinalData(:,2), FinalData(:,4)); % Create a scatter plot and return a handle to the 'hggroup' object
axis([-0.5 1 -0.5 1])

%Obtain the axes size (in axpos) in Points
currentunits = get(gca,'Units');
set(gca, 'Units', 'Points');
axpos = get(gca,'Position');
set(gca, 'Units', currentunits);
markerWidth = s./diff(xlim).*axpos(3); % Calculate Marker width in points
set(h, 'SizeData', markerWidth.^2)  % Marker as square area



% GOOD works, but it uses loop and draws circles in 2D -> make it 3D?
figure
hold on
for i = 1:size(FinalData,1)
    radius = FinalData(i,1);
    centerX = -FinalData(i,3);
    centerY = -FinalData(i,2);
    rectangle('Position',[centerX - radius, centerY - radius, radius*2, radius*2],'Curvature',[1,1]);
end
difference = ceil(100*max(-FinalData(:,3)))/100-floor(100*min(-FinalData(:,3)))/100 - ( ceil(100*max(-FinalData(:,3)))/100-floor(100*min(-FinalData(:,2)))/100 );
if( difference > 0 )
    axis([floor(100*min(-FinalData(:,3)))/100 ceil(100*max(-FinalData(:,3)))/100 floor(100*min(-FinalData(:,2)))/100 ceil(100*max(-FinalData(:,3)))/100+difference])   % Custom axes dimension before drawing error
else
    axis([floor(100*min(-FinalData(:,3)))/100 ceil(100*max(-FinalData(:,3)))/100+abs(difference) floor(100*min(-FinalData(:,2)))/100 ceil(100*max(-FinalData(:,3)))/100])
end
%axis square


% 3D spheres
% First create the image.
imageSizeX = 100;
imageSizeY = 100;
imageSizeZ = 100;
[columnsInImage rowsInImage pagesInImage] = meshgrid(1:imageSizeX, 1:imageSizeY,1:imageSizeZ);
%columnsInImage = meshgrid(1:imageSizeX);
%rowsInImage = meshgrid(1:imageSizeY);
%pagesInImage = meshgrid(1:imageSizeZ);
% Next create the sphere in the image.
centerX = -FinalData(:,3);
centerY = -FinalData(:,2);
centerZ = FinalData(:,4);
radius = FinalData(:,1);
sphereVoxels = (rowsInImage - repmat(centerY,100,100,100)).^2 + (columnsInImage - repmat(centerX,100,100)).^2 + (pagesInImage - repmat(centerZ,100,100,100)).^2 <= radius.^2;

% sphereVoxels is a 3D "logical" array.
% Now, display it using an isosurface and a patch
fv = isosurface(sphereVoxels,0);
patch(fv,'FaceColor',[0 0 .7],'EdgeColor',[0 0 1]);




%% Other code

figure
hold on
scatter3(Points(:,1),Points(:,2),Points(:,3));
scatter3(FinalData(36,2), FinalData(36,3), FinalData(36,4), (FinalData(36,1)/point_size).^2);


radius = FinalData(36,1); 
centerX = FinalData(36,2);
centerY = FinalData(36,3);
rectangle('Position',[centerX - radius, centerY - radius, radius*2, radius*2],'Curvature',[1,1])%,...
    %'FaceColor','r');
axis square

axis([-0.9 0.1 -0.5 0.5])

% Displaying tracked points with std deviation
if(false)
    point_size = 0.0254/72; % 1/72 inches per point, to meters
    figure
    %hold on     % Uncomment to see in 2D
    scatter3((-1*FinalData(:,3)), (-1*FinalData(:,2)), FinalData(:,4), 'SizeData', FinalData(:,1)/point_size);
    grid on
    %scatter3((-1*FinalData(:,3)), (-1*FinalData(:,2)), FinalData(:,4), (FinalData(:,1)/point_size).^2);
    
    %for i = 1:size(FinalData,1)
        % Rotated image to visualize better (x and y swapped and inversed)
        %scatter3((-1*FinalData(i,3)), (-1*FinalData(i,2)), FinalData(i,4), FinalData(i,1)/point_size);
    %end
end