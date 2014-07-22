%% 
folder1 = 'data_20140717T174320';
folder2 = 'data_20140718T101718';

list = dir(folder2);
nfiles = length(list);

%%
% Needed to start from the third item in the list. The two first ones are never files
cpoints = [];
for i = 4:nfiles
    cpoints1 = [];
    filename = [folder2 '\' list(i).name];
    fid = fopen(filename);
    mydata = textscan(fid,['%f\n%f\n%f\n' repmat('%n,',1,1999) '%n\n' repmat('%n,',1,1999) '%n\n' repmat('%n,',1,1999) '%n\n']);
    
    %rpoints = [mydata{1,1} mydata{1,2} mydata{1,3}];
    j = 4:2003;
    cpoints1 = [mydata{1,j}; mydata{1,(j+2000)}; mydata{1,(j+4000)}];
    
    long = size(cpoints1,1);
    for k = 1:long/3
        cpoints = [cpoints; cpoints1(k,:); cpoints1((k+long/3),:); cpoints1((k+long*2/3),:)];
    end
end

myvar = var(cpoints');
myvar2 = [];
for h = 3:3:length(myvar)
    myvar2 = [myvar2 sum([myvar(h-2) myvar(h-1) myvar(h)])];
end

myvar20 = [];
for h = 3:120:(length(myvar)-120)
    myvar20 = [myvar20 sum([myvar(h-2) myvar(h-1) myvar(h)])];
end

myvar10 = [];
for h = 3:60:(length(myvar)-60)
    myvar10 = [myvar10 sum([myvar(h-2) myvar(h-1) myvar(h)])];
end

myvar_interp10 = interp(myvar10, floor(length(myvar2)/length(myvar10)), 1, 1);
myvar_interp20 = interp(myvar20, floor(length(myvar2)/length(myvar20)), 1, 1);

dvar = diff(myvar2);
dvar10 = diff(myvar_interp10);
dvar20 = diff(myvar_interp20);

figure
plot(myvar2)
hold on
plot(myvar_interp10,'r')
plot(myvar_interp20,'g')
ylim([0 0.1])

figure
plot(dvar)
hold on
plot(dvar10,'r')
plot(dvar20,'g')
ylim([-0.01 0.01])


% figure
% plot(myvar20)
% ylim([0 0.2])










%     myvar3 = [];
%     for h = 1:100
%         myvar3 = [myvar3 (myvar(h*3-2)+myvar(h*3-1)+myvar(h*3))/3];
%     end

%     cpoints2 = zeros(3,100*2000);
    %     cpoints2(:) = cpoints1(1:100,:);
    %     cpoints2(2,:) = cpoints1(101:200,:);
    %     cpoints2(3,:) = cpoints1(201:300,:);
    %cpoints2(:) = [cpoints1(1:100,:); cpoints1(101:200,:); cpoints1(201:300,:)];

    %mydata = textscan(fid,['%f\n']);
    %mydata = fscanf(fid,'%f\n%f\n%f\n1000%f\n1000%f\n1000%f');
    %mydata = fscanf(fid,'%f\n%f\n%f\n%1000f\n%1000f\n%1000f');