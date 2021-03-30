%function oct_alti_sortsat(dire,lonmn,lonmx,latmn,latmx,doplot,niceplot)
%
% Reads a geographical subset of a GLOBWAVE altimeter NetCDF file. 
% Reads all the .nc files in a given directory
%
% Andres Sepulveda, 30/10/2013
%
% 
more off
close all
clear all

  lonmn=120;
  lonmx=296;
  latmn=-70.0;
  latmx=60.0;
  doplot=0;
  niceplot=1;

year=2015;
casenm="AllPacific";

dire='./NetCDF';

yearnm=num2str(year);

listfiles=readdir(dire);

lontmp=[];
lattmp=[];
timetmp=[];
swhtmp=[];
wstmp=[];
sigmatmp=[];
sattmp=[];

for ii=1:size(listfiles,1)

if (regexp(listfiles{ii,1},'.nc'))
listfiles{ii,1}
nc=netcdf([dire '/' listfiles{ii,1}],'r');

  lon=nc{'lon'}(:);
scale=nc{'lon'}.scale_factor;
fillv=nc{'lon'}._FillValue;
I=find(lon == fillv);
lon=double(lon).*scale;
lon(I)=NaN;
aux=find(lon< 0);
lon(aux)=lon(aux)+360;

  lat=nc{'lat'}(:);
scale=nc{'lat'}.scale_factor;
fillv=nc{'lat'}._FillValue;
I=find(lat == fillv);
lat=double(lat).*scale;
lat(I)=NaN;

  time=nc{'time'}(:);
scale=nc{'time'}.scale_factor;
fillv=nc{'time'}._FillValue;
I=find(time == fillv);
time=double(time).*scale;
time(I)=NaN;

  satellite=nc{'satellite'}(:);
scale=nc{'satellite'}.scale_factor;
fillv=nc{'satellite'}._FillValue;
I=find(satellite == fillv);
satellite=double(satellite).*scale;
satellite(I)=NaN;

  wind_speed=nc{'wind_speed_cor'}(:);
scale=nc{'wind_speed_cor'}.scale_factor;
fillv=nc{'wind_speed_cor'}._FillValue;
I=find(wind_speed == fillv);
wind_speed=double(wind_speed).*scale;
wind_speed(I)=NaN;

  swh=nc{'swhcor'}(:);
scale=nc{'swhcor'}.scale_factor;
fillv=nc{'swhcor'}._FillValue;
I=find(swh == fillv);
swh=double(swh).*scale;
swh(I)=NaN;

  sigma0=nc{'sigma0_cal'}(:);
scale=nc{'sigma0_cal'}.scale_factor;
fillv=nc{'sigma0_cal'}._FillValue;
I=find(sigma0 == fillv);
sigma0=double(sigma0).*scale;
sigma0(I)=NaN;

close(nc)

indx=find(lon <= lonmx & lon >= lonmn & lat <= latmx & lat >= latmn );

lontmp=[lontmp; lon(indx)];
lattmp=[lattmp; lat(indx)];
timetmp=[timetmp; time(indx)];
sattmp=[sattmp; satellite(indx)];
swhtmp=[swhtmp; swh(indx)];
sigmatmp=[sigmatmp; sigma0(indx)];
wstmp=[wstmp; wind_speed(indx)];
end % if is an nc file
end % for files

time0=datenum(1900,1,1);
timetmp=timetmp+time0;

nc=netcdf(['GLOBWAVE_Altimeters_' casenm '_' yearnm '.nc'],'c');
nc('time')=length(timetmp);
nc{'satellite'}=ncint('time');
nc{'satellite'}(:)=sattmp;
nc{'time'}=ncint('time');
nc{'time'}(:)=timetmp;
nc{'longitude'}=ncdouble('time');
nc{'longitude'}(:)=lontmp;
nc{'latitude'}=ncdouble('time');
nc{'latitude'}(:)=lattmp;
nc{'swh'}=ncdouble('time');
nc{'swh'}(:)=swhtmp;
nc{'wind_speed'}=ncdouble('time');
nc{'wind_speed'}(:)=wstmp;
nc{'sigma0'}=ncdouble('time');
nc{'sigma0'}(:)=sigmatmp;
close(nc)

for i = 1:10
indx=find(sattmp == i);
if (length(indx) == 0)
disp(['Sat' num2str(i) ': NO DATA'])
else
disp(['Sat' num2str(i) ': ' num2str(length(indx)) ' DATA points'])
end % if
end % for

if (doplot == 1)

for i = 1:10

indx=find(sattmp == i);

auxlon=lontmp(indx);
auxlat=lattmp(indx);
auxswh=swhtmp(indx);
auxtime=timetmp(indx);
auxws=wstmp(indx);
auxsigma0=sigmatmp(indx);

[yy mm dd hh mn ss]=datevec(auxtime);
ss=round(ss);

[yymn  mmmn ddmn ]=datevec(min(auxtime));
[yymx  mmmx ddmx ]=datevec(max(auxtime));

if (size(auxtime,1) == 0)
%disp(['Sat' num2str(i) ': NO DATA'])
else
%disp(['Sat' num2str(i) ': ' num2str(size(auxtime,1)) ' DATA points'])
figure(i)

if (niceplot == 1)

warning off
addpath('/ocean/m_map');
addpath('/ocean/m_map/private');

m_proj('equid','lon',[lonmn lonmx],'lat',[latmn latmx]);
m_plot(auxlon,auxlat,'.')
m_coast('patch',[1 1 1]/10);
m_grid('box','xtick',[-180:1:180],'ytick',[-90:1:90]);
else

plot(auxlon,auxlat,'.')
axis([lonmn lonmx latmn latmx]);
grid('on');
end % if niceplot
title(['Satellite ' num2str(i) ': ' num2str(yymn) '/' num2str(mmmn) '/' num2str(ddmn) '-' num2str(yymx) '/' num2str(mmmx) '/' num2str(ddmx) '  n = ' num2str(size(auxtime,1))])
xlabel('Longitude')
ylabel('Latitude')

plotname=['Position_Sat' num2str(i) '_' yearnm '_' casenm];
print(plotname,'-dgif')

figure(10+i)
hist(auxswh)
title(['Satellite ' num2str(i) ': ' num2str(yymn) '/' num2str(mmmn) '/' num2str(ddmn) '-' num2str(yymx) '/' num2str(mmmx) '/' num2str(ddmx) '  n = ' num2str(size(auxtime,1))])
xlabel('SWH [m]')
plotname=['HIST_Sat' num2str(i) '_' yearnm '_' casenm];

print(plotname,'-dgif')
figure(20+i)
%m_proj('equid','lon',[lonmn lonmx],'lat',[latmn latmx]);
%m_plot(auxlon,auxlat,'.')
%hold on
scatter(auxlon,auxlat,9,auxswh)
caxis([0 max(auxswh)]);
colorbar()
%m_coast('patch',[1 1 1]/10);
%m_grid('box','xtick',[-180:1:180],'ytick',[-90:1:90]);
grid('on')
xlabel('Longitude')
ylabel('Latitude')
title(['Satellite ' num2str(i) ': ' num2str(yymn) '/' num2str(mmmn) '/' num2str(ddmn) '-' num2str(yymx) '/' num2str(mmmx) '/' num2str(ddmx) '  n = ' num2str(size(auxtime,1))])
%hold off
plotname=['Hs_alongtrack_Sat' num2str(i) '_' yearnm '_' casenm];

print(plotname,'-dgif')

figure(30+i)
plot(auxws,auxswh,'.')
title(['Satellite ' num2str(i) ': ' num2str(yymn) '/' num2str(mmmn) '/' num2str(ddmn) '-' num2str(yymx) '/' num2str(mmmx) '/' num2str(ddmx) '  n = ' num2str(size(auxtime,1))])
xlabel('Wind Speed Magnitude [m/s]')
ylabel('SWH [m]')
plotname=['Ws_vs_Hs_Sat' num2str(i) '_' yearnm '_' casenm];

print(plotname,'-dgif')

figure(40+i)
plot(auxtime,auxswh,'.')
title(['Satellite ' num2str(i) ': ' num2str(yymn) '/' num2str(mmmn) '/' num2str(ddmn) '-' num2str(yymx) '/' num2str(mmmx) '/' num2str(ddmx) '  n = ' num2str(size(auxtime,1))])
datetick(12)
xlabel('Date')
ylabel('SWH [m]')
plotname=['Hs_Time_Sat' num2str(i) '_' yearnm '_' casenm ];
print(plotname,'-dgif')

end % if data

end % for sat

end; % if doplot


