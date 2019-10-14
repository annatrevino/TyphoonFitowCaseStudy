%To setup NCTOOLBOX
cd 'C:\Work\Matlab Programs\nctoolbox-nctoolbox-20130305'
setup_nctoolbox
%----------------------------------------------------------------------
%Plotting 250 mb & WSPD
%Paths for accessing the data and saving the images
cd ('C:\Work\Model_065\Typhoon Fitow\GFS Output\Fitow_0.5degree\Data');
path=('C:\Work\Model_065\Typhoon Fitow\GFS Output\Fitow_0.5degree\');
S = shaperead('C:\Work\ShapeFiles\States_and_Provinces.shp');
nc=ncgeodataset('gfs_4_20131010_1800_000.grb2'); %create ncgeodataset object
Udirvar=nc.geovariable('u-component_of_wind_isobaric');
Vdirvar=nc.geovariable('v-component_of_wind_isobaric');
Udir=Udirvar.data(1,18,:);  %time=1, level 18=250 mb, all lat, all lon
Vdir=Vdirvar.data(1,18,:);  %time=1, level 18=250 mb, all lat, all lon
Ug=Udirvar.grid_interop(1,18,:,:); % get grid at 1st time step
Vg=Vdirvar.grid_interop(1,18,:,:); % get grid at 1st time step
lat=Ug.lat;
lon=Ug.lon;
u=squeeze(Udir);
u=double(u);
u=u*1.9438; %to put it in knots
v=squeeze(Vdir);
v=double(v);
v=v*1.9438; %to put it in knots
lat2=meshgrid(lon,lat);
lon2=meshgrid(lat,lon)';

%         V 90                  a
%         |                     |
%         |                     |
%180______|_______ U 0          |
%         |                     |
%         |                     |_______x
%         |270                  b        c
%
% theta = atand(ab/bc)
% direction = ab/[sin(theta)]

%Calculating the wind speed using u- and v-vectors
for i=1:361
for j=1:720
        i;
        j;
U=u(i,j);  %bc = U = 7.5
V=v(i,j);  %ab = V = -9.4

% if U==0 
%     U=0.00001;
% end

theta=atand(U/V);         
if U >= 0 & V >= 0      %if u=+,v=+ theta2=theta
    angle=abs(theta);        %direction of the wind
else if U < 0 & V >= 0  %if u=-,v=+ theta2=theta+90
    angle=abs(theta)+90;     %direction of the wind
else if U < 0 & V < 0   %if u=-,v=- theta2=theta+180
    angle=abs(theta)+180;    %direction of the wind
else if U >= 0 & V < 0  %if u=+,v=- theta2=theta+270
    angle=abs(theta)+270;    %direction of the wind
else if U==0 & V==0
    angle=0;
    theta=0;
end
end
end
end
end
speed=sqrt(U^2+V^2);
%speed=abs(U/sind(theta)); %magnitude of the wind
direction(i,j)=angle;
magnitude(i,j)=speed; 
end
end

%Now to plot
lon=Ug.lon(201:321,:);
lat=Ug.lat(91:171,:);
mag2=magnitude(91:171,201:321);
C=figure;
set(C,'Visible','on');
v2=[70:10:200];  %max is ~131
p=contourf(lon,lat,mag2,v2,'EdgeColor','none');
%[red,green,blue];
colormap([0.8,1,1; 0.6,1,1; 0.4,1,1; 0,1,1; 0.2,0.8,1; 1,1,0.8;])
c=colorbar;
caxis([70 200]) %setting the min/max values of the colorbar
ylabel(c,'Knots')
hold on

%To plot geopotential height contours
dirvar=nc.geovariable('Geopotential_height_isobaric');
dir=dirvar.data(1,18,:,:); %700mb=level 9
g=dirvar.grid_interop(1,18,:,:); % get grid at 1st time step
dir2=squeeze(dir);
dir2=dir2*0.98; %to convert from gpm to m
dir2=dir2/10; %to convert from m to decameters (15m=1.5 decameters)
v=(900:6:1500)';    %Contour interval set at 3 dam
[C,h]=contour(g.lon,g.lat,dir2,v,'color','k','LineWidth',1);%'ShowText','on'

%To add shapefile and title
plot([S.X],[S.Y], 'color',[0.5 0.5 0.5],'LineWidth',0.5); %plotting the shapefile grey
title1=('250 mb & WSPD');
title2=strcat(datestr(g.time,'dd-mmm-yyyy hh'),'z');
title({title1,title2})
xlim([100 160]);
ylim([5 45]);
ch=clabel(C,h,'FontSize',6,'LabelSpacing',240);
hold off
string=strcat(path,datestr(g.time,'ddmmmyyyy_hh'),'z_250mb&WSPD.jpg');
saveas(c,string);
clear c



%----------------------------------------------------------------------
%Plotting SLP mb & Surface WSPD
%Paths for accessing the data and saving the images
cd ('C:\Work\Model_065\Typhoon Fitow\GFS Output\Fitow_0.5degree\Data');
path=('C:\Work\Model_065\Typhoon Fitow\GFS Output\Fitow_0.5degree\');
S = shaperead('C:\Work\ShapeFiles\States_and_Provinces.shp');
nc=ncgeodataset('gfs_4_20131008_0000_000.grb2'); %create ncgeodataset object

%To plot sea level pressure contours
dirvar=nc.geovariable('MSLP_Eta_model_reduction_msl');
dir=dirvar.data(1,91:171,201:321);  %time=1, all lat, all lon
g=dirvar.grid_interop(1,:,:); % get grid at 1st time step
lon=g.lon(201:321,:);
lat=g.lat(91:171,:);
dir2=squeeze(dir/100);
C=figure;
set(C,'Visible','off');
v2=(800:4:1050)';    %Contour interval set at 4
[C,h]=contour(lon,lat,dir2,v2,'color','k','LineWidth',1);%'ShowText','on'
hold on


%To plot surface wind speeds
Udirvar=nc.geovariable('u-component_of_wind_isobaric');
Vdirvar=nc.geovariable('v-component_of_wind_isobaric');
Udir=Udirvar.data(1,1,:);  %time=1, level 18=250 mb, all lat, all lon
Vdir=Vdirvar.data(1,1,:);  %time=1, level 18=250 mb, all lat, all lon
Ug=Udirvar.grid_interop(1,1,:,:); % get grid at 1st time step
Vg=Vdirvar.grid_interop(1,1,:,:); % get grid at 1st time step
lat=Ug.lat;
lon=Ug.lon;
u=squeeze(Udir);
u=double(u);
u=u*1.9438; %to put it in knots
v=squeeze(Vdir);
v=double(v);
v=v*1.9438; %to put it in knots
%quiver(lon(1:2:end),lat(1:2:end),u(1:2:end,1:2:end),v(1:2:end,1:2:end),1.5,'LineWidth',.95,'Color','b') %creates arrows to simulate wind barbs
quiver(lon,lat,u,v,1.5,'LineWidth',.95,'Color','b') %creates arrows to simulate wind barbs

%To add shapefile and title
plot([S.X],[S.Y], 'color',[0.5 0.5 0.5],'LineWidth',0.3); %plotting the shapefile grey
title1=('SLP & Surface Wind Speed (knots)');
title2=strcat(datestr(g.time,'dd-mmm-yyyy hh'),'z');
title({title1,title2})
xlim([110 135]);
ylim([20 35]);
ch=clabel(C,h,'FontSize',8,'LabelSpacing',240);
hold off
string=strcat(path,datestr(g.time,'ddmmmyyyy_hh'),'z_SLP&SFWS.png');
saveas(gcf,string);
clear C
