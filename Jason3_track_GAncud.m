clear all
close all

%
% Data de
%
%https://podaac-opendap.jpl.nasa.gov/opendap/allData/jason3/preview/L2/GPS-OGDR/
%
% Tracks en
%
% https://openadb.dgfi.tum.de/en/passlocator/
%
ncfile='JA3_GPSOPR_2PdS133_213_20190926_143145_20190926_162937.nc.nc';
%ncfile='JA3_GPSOPR_2PdS133_217_20190926_182905_20190926_202553.nc.nc';
ncdisp(ncfile);
info=ncinfo(ncfile);
names = {info.Variables.Name};
 
Hs   = ncread(ncfile,'swh_ku');
lat  = ncread(ncfile,'lat');
lon  = ncread(ncfile,'lon');
time = ncread(ncfile,'time');
geoscatter(lat,lon,Hs);
%axis([])