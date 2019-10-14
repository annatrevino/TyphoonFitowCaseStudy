
%This code will allow you to read GRIB data using the NCTOOLBOX add-on.
%Downloaded data should be placed in the toolbox folder.

%NEED TO CHANGE SAVE AS TYPE TO PNG FOR BETTER QUALITY
%ALSO NEED TO CHANGE THE PATH AND CD FOR EACH ONE

%To setup NCTOOLBOX
cd 'C:\Work\Matlab Programs\nctoolbox-nctoolbox-20130305'
setup_nctoolbox
%var=nc.variables; % list variables
%att=dirvar.attributes; %gets attributes of dirvar

%Plotting SLP & 1000-500 mb THK
%Paths for accessing the data and saving the images
cd ('C:\Work\Alert\LikeEvents\StochStorm_Search\Output\Fitow2013\GFS Output\Fitow_0.5degree\Data');
path=('C:\Work\Alert\LikeEvents\StochStorm_Search\Output\Fitow2013\GFS Output\Fitow_0.5degree\');
S = shaperead('C:\Work\ShapeFiles\States_and_Provinces.shp');
nc=ncgeodataset('gfs_4_20131005_0000_000.grb2'); %create ncgeodataset object
dirvar=nc.geovariable('MSLP_Eta_model_reduction_msl');
dir=dirvar.data(1,:,:);  %time=1, all lat, all lon
g=dirvar.grid_interop(1,:,:); % get grid at 1st time step
p=figure;
set(p,'Visible','on');
lon=g.lon;
lat=g.lat;
dir2=squeeze(dir/100);
v=(800:4:1050)';    %Contour interval set at 4
p=contour(lon,lat,dir2,v,'ShowText','on','LineWidth',2);
%clabel(p,'manual') %IF I WANT TO FIND A SPECIFIC CONTOUR
hold on
plot([S.X],[S.Y], 'k');
xlim([100 160]);
ylim([5 45]);
title1=('SLP');% & 1000-500 mb THK');
title2=strcat(datestr(g.time,'dd-mmm-yyyy hh'),'z');
title({title1,title2})
hold off
string=strcat(path,datestr(g.time,'ddmmmyyyy_hh'),'z_SLP.jpg');%_500to1000THK');
saveas(p,string);
clear p

%----------------------------------------------------------------------
%Plotting 850 mb & TMP
%Paths for accessing the data and saving the images
cd ('C:\Work\Alert\LikeEvents\StochStorm_Search\Output\Fitow2013\GFS Output\Fitow_0.5degree\Data');
path=('C:\Work\Alert\LikeEvents\StochStorm_Search\Output\Fitow2013\GFS Output\Fitow_0.5degree\');
S = shaperead('C:\Work\ShapeFiles\States_and_Provinces.shp');
nc=ncgeodataset('gfs_4_20131010_1800_000.grb2'); %create ncgeodataset object
dirvar=nc.geovariable('Temperature_isobaric');  %units in K
dir=dirvar.data(1,6,:,:);  %time=1, level 6=850 mb, all lat/lon for .5 degree
g=dirvar.grid_interop(1,5,:,:); % get grid at 1st time step
dir2=squeeze(dir);
C=figure;
set(C,'Visible','off');
C=contourf(g.lon,g.lat,dir2,'EdgeColor','none');
%p=pcolorjw(g.lon,g.lat,dir);
c=colorbar;%('SouthOutside')
caxis([200 300]) %setting the min/max values of the colorbar
ylabel(c,'K')
hold on

%To plot geopotential height contours
dirvar=nc.geovariable('Geopotential_height_isobaric');
dir=dirvar.data(1,6,:,:); %700mb=level 9
g=dirvar.grid_interop(1,6,:,:); % get grid at 1st time step
dir2=squeeze(dir);
dir2=dir2*0.98; %to convert from gpm to m
dir2=dir2/10; %to convert from m to decameters (15m=1.5 decameters)
v=(50:3:200)';    %Contour interval set at 3 dam
[C,h]=contour(g.lon,g.lat,dir2,v,'color','k','LineWidth',1);%'ShowText','on'

%To add shapefile and title
plot([S.X],[S.Y], 'color',[0.5 0.5 0.5],'LineWidth',0.5); %plotting the shapefile grey
title1=('850 mb hgt & TMP');
title2=strcat(datestr(g.time,'dd-mmm-yyyy hh'),'z');
title({title1,title2})
xlim([100 160]);
ylim([5 45]);
ch=clabel(C,h,'FontSize',6,'LabelSpacing',240);
hold off
string=strcat(path,datestr(g.time,'ddmmmyyyy_hh'),'z_850mb&TMP.jpg');
saveas(c,string);
clear c

%----------------------------------------------------------------------
%Plotting 700 mb & RH
%Paths for accessing the data and saving the images
cd ('C:\Work\Model_065\Typhoon Fitow\GFS Output\Fitow_0.5degree\Data');
path=('C:\Work\Model_065\Typhoon Fitow\GFS Output\Fitow_0.5degree\');
S = shaperead('C:\Work\ShapeFiles\States_and_Provinces.shp');
nc=ncgeodataset('gfs_4_20131007_1200_000.grb2'); %create ncgeodataset object
dirvar=nc.geovariable('Relative_humidity_isobaric');
%dir=dirvar.data(1,9,91:171,201:321);  %time=1, level 17=700 mb, all lat/lon, .5 degree
dir=dirvar.data(1,9,:,:);  %time=1, level 17=700 mb, all lat/lon, .5 degree
g=dirvar.grid_interop(1,9,:,:); % get grid at 1st time step
C=figure;
set(C,'Visible','off');
dir2=squeeze(dir);
dir2=dir2(91:171,201:321);
lon=g.lon(201:321,:);
lat=g.lat(91:171,:);
v=[70;90;100];
p=contourf(lon,lat,dir2,v,'EdgeColor','none');
%p=contourf(g.lon,g.lat,dir2,v,'EdgeColor','none');
%cmap=[white(1);flipud(gray(4))];
%colormap(cmap)
colormap([0.8,0.8,0.8;0.8,0.8,0.8;0.6,0.6,0.6])
c=colorbar;%('SouthOutside')
set(c,'YTick',[70 75 80 85 90 95 100])
set(c,'YTickLabel',{'70',' ',' ',' ','90',' ','100'})
%caxis([-0.0006 0.0008]) %setting the min/max values of the colorbar
caxis([70 100]) %setting the min/max values of the colorbar
ylabel(c,'%')
hold on

%To plot geopotential height contours
dirvar=nc.geovariable('Geopotential_height_isobaric');
dir=dirvar.data(1,9,:,:); %700mb=level 9
%dir=dirvar.data(1,9,91:171,201:321);  %time=1, level 17=700 mb, all lat/lon, .5 degree
g=dirvar.grid_interop(1,9,:,:); % get grid at 1st time step
dir2=squeeze(dir);
dir2=dir2*0.98; %to convert from gpm to m
dir2=dir2/10; %to convert from m to decameters (15m=1.5 decameters)
v=(200:6:350)';    %Contour interval set at 3 dam
[C,h]=contour(g.lon,g.lat,dir2,v,'color','k','LineWidth',1);%'ShowText','on'

%To add shapefile and title
plot([S.X],[S.Y], 'color',[0.5 0.5 0.5],'LineWidth',0.5); %plotting the shapefile grey
title1=('700 mb hgt & RH');
title2=strcat(datestr(g.time,'dd-mmm-yyyy hh'),'z');
title({title1,title2})
xlim([100 160]);
ylim([5 45]);
ch=clabel(C,h,'FontSize',8,'LabelSpacing',240);
hold off
string=strcat(path,datestr(g.time,'ddmmmyyyy_hh'),'z_700mb&RH.png');
saveas(c,string);
clear c

%----------------------------------------------------------------------
%Plotting 500 mb & AVORT
%Paths for accessing the data and saving the images
cd ('C:\Work\Alert\LikeEvents\StochStorm_Search\Output\Fitow2013\GFS Output\Fitow_0.5degree\Data');
path=('C:\Work\Alert\LikeEvents\StochStorm_Search\Output\Fitow2013\GFS Output\Fitow_0.5degree\');
S = shaperead('C:\Work\ShapeFiles\States_and_Provinces.shp');
nc=ncgeodataset('gfs_4_20131010_1800_000.grb2'); %create ncgeodataset object
dirvar=nc.geovariable('Absolute_vorticity_isobaric');
dir=dirvar.data(1,13,:,:);  %time=1, level 13=500 mb, all lat/lon, .5 deg
g=dirvar.grid_interop(1,13,:,:); % get grid at 1st time step
C=figure;
set(C,'Visible','off');
dir2=squeeze(dir);
dir2=dir2(91:171,201:321);
lon=g.lon(201:321,:);
lat=g.lat(91:171,:);
v=(0.0001:.0004:.001); %0.000984 max of dir2 (or 9.84 x 10^-4)
p=contourf(lon,lat,dir2,v,'EdgeColor','none');
%p=contourf(g.lon,g.lat,dir2,v,'EdgeColor','none');
cmap=[white(1);flipud(autumn(9))];
colormap(cmap)
c=colorbar;%('SouthOutside')
set(c,'YTick',[1 2 3 4 5])% 6 7 8 9 10])
set(c,'YTickLabel',{' ','2',' ','4',' ','6',' ','8',' ','10'})
caxis([0 0.001]) %setting the min/max values of the colorbar
ylabel(c,'x10^-^4 1/s')
hold on

%To plot geopotential height contours
dirvar=nc.geovariable('Geopotential_height_isobaric');
dir=dirvar.data(1,13,:,:); %700mb=level 9
g=dirvar.grid_interop(1,13,:,:); % get grid at 1st time step
dir2=squeeze(dir);
dir2=dir2*0.98; %to convert from gpm to m
dir2=dir2/10; %to convert from m to decameters (15m=1.5 decameters)
v=(450:6:600)';    %Contour interval set at 3 dam
[C,h]=contour(g.lon,g.lat,dir2,v,'color','k','LineWidth',1);%'ShowText','on'

%To add shapefile and title
plot([S.X],[S.Y], 'color',[0.5 0.5 0.5],'LineWidth',0.5); %plotting the shapefile grey
title1=('500 mb hgt & AVORT');
title2=strcat(datestr(g.time,'dd-mmm-yyyy hh'),'z');
title({title1,title2})
xlim([100 160]);
ylim([5 45]);
ch=clabel(C,h,'FontSize',6,'LabelSpacing',240);
hold off
string=strcat(path,datestr(g.time,'ddmmmyyyy_hh'),'z_500mb&AVORT.jpg');
saveas(c,string);
clear all

%----------------------------------------------------------------------
%Plotting 250 mb & WSPD
%See 'WindSpeeds.m'

%----------------------------------------------------------------------
%Plotting SLP mb & Surface WSPD
%See 'WindSpeeds.m'

%----------------------------------------------------------------------
%To plot sea level pressure contours
cd ('C:\Work\Alert\LikeEvents\StochStorm_Search\Output\Fitow2013\GFS Output\Fitow_0.5degree\Data');
path=('C:\Work\Alert\LikeEvents\StochStorm_Search\Output\Fitow2013\GFS Output\Fitow_0.5degree\');
S = shaperead('C:\Work\ShapeFiles\States_and_Provinces.shp');
nc=ncgeodataset('gfs_4_20131010_1800_000.grb2'); %create ncgeodataset object
dirvar=nc.geovariable('MSLP_Eta_model_reduction_msl');
dir=dirvar.data(1,91:171,201:321);  %time=1, all lat, all lon
g=dirvar.grid_interop(1,:,:); % get grid at 1st time step
lon=g.lon(201:321,:);
lat=g.lat(91:171,:);
dir2=squeeze(dir/100);
C=figure;
set(C,'Visible','off');
v=(800:4:1050)';    %Contour interval set at 4
[C,h]=contour(lon,lat,dir2,v,'color','k','LineWidth',1);%'ShowText','on'
hold on

%To add shapefile and title
plot([S.X],[S.Y], 'color',[0.5 0.5 0.5],'LineWidth',0.5); %plotting the shapefile grey
title1=('Sea Level Pressure');
title2=strcat(datestr(g.time,'dd-mmm-yyyy hh'),'z');
title({title1,title2})
xlim([100 160]);
ylim([5 45]);
ch=clabel(C,h,'FontSize',6,'LabelSpacing',240);
hold off
string=strcat(path,datestr(g.time,'ddmmmyyyy_hh'),'z_SLP.jpg');
%hgexport(gcf, string, hgexport('factorystyle'), 'Format', 'jpeg');
saveas(gcf,string);
clear all

