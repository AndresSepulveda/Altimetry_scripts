
%
%  Andres Sepulveda - DGEO 20221103
%
%  Get data from https://www.star.nesdis.noaa.gov/data/pub0010/lsa/johnk/coastwatch/3a/
%                https://www.star.nesdis.noaa.gov/data/pub0010/lsa/johnk/coastwatch/3b/
% 		  https://www.star.nesdis.noaa.gov/data/pub0010/lsa/johnk/coastwatch/j3/
%		  https://www.star.nesdis.noaa.gov/data/pub0010/lsa/johnk/coastwatch/c2/
%
nc=netcdf('3a_20221102.nc','r');
	lat=nc{'lat'}(:);               % time
	lon=nc{'lon'}(:);
	swh=nc{'swh'}(:,:,:);           % time, lat, lon
	ws=nc{'wind_speed_alt'}(:,:,:);
	tiempo=nc{'time'}(:);
close(nc)

indx=find(lat > -45.0 & lat < -41.0);



