@echo off
setlocal EnableDelayedExpansion
echo "Encryption Time"

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\points.shp -out O:\public\points.shp.enc -k password -pbkdf2
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo points.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\france-waterways.shp -out O:\public\france-waterways.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo france-waterways.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\france-natural.shp -out O:\public\france-natural.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo france-natural.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\indonesia-natural.shp -out O:\public\indonesia-natural.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo indonesia-natural.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\germany-points.shp -out O:\public\germany-points.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo germany-points.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\waterways.shp -out O:\public\waterways.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo waterways.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\buildings.shp -out O:\public\buildings.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo buildings.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%



set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\india-natural.shp -out O:\public\india-natural.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo india-natural.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\natural.shp -out O:\public\natural.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo natural.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%



set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\india-waterways.shp -out O:\public\india-waterways.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo india-waterways.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\spain-roads.shp -out O:\public\spain-roads.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo spain-roads.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\quebec_water.shp -out O:\public\quebec_water.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo quebec_water.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\Camb3D_Bldg_Active_MP_SHP_1.shp -out O:\public\Camb3D_Bldg_Active_MP_SHP_1.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo Camb3D_Bldg_Active_MP_SHP_1.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\landuse.shp -out O:\public\landuse.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo landuse.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in O:\public\Camb3D_Bldg_Active_MP_SHP.shp -out O:\public\Camb3D_Bldg_Active_MP_SHP.shp.enc -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo Camb3D_Bldg_Active_MP_SHP.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%


echo "####################################################################"
echo "Decryption Time"


set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\points.shp.enc -out O:\public\pointsX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo points.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\france-waterways.shp.enc -out O:\public\france-waterwaysX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo france-waterways.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\france-natural.shp.enc -out O:\public\france-naturalX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo france-natural.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\indonesia-natural.shp.enc -out O:\public\indonesia-naturalX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo indonesia-natural.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\germany-points.shp.enc -out O:\public\germany-pointsX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo germany-points.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\waterways.shp.enc -out O:\public\waterwaysX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo waterways.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\buildings.shp.enc -out O:\public\buildingsX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo buildings.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%



set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\india-natural.shp.enc -out O:\public\india-naturalX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo india-natural.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\natural.shp.enc -out O:\public\naturalX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo natural.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%



set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\india-waterways.shp.enc -out O:\public\india-waterwaysX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo india-waterways.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\spain-roads.shp.enc -out O:\public\spain-roadsX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo spain-roads.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\quebec_water.shp.enc -out O:\public\quebec_waterX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo quebec_water.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\Camb3D_Bldg_Active_MP_SHP_1.shp.enc -out O:\public\Camb3D_Bldg_Active_MP_SHP_1X.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo Camb3D_Bldg_Active_MP_SHP_1.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\landuse.shp.enc -out O:\public\landuseX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo landuse.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

set "startTime=%time: =0%"
openssl enc -d -aes-256-cbc -in O:\public\Camb3D_Bldg_Active_MP_SHP.shp.enc -out O:\public\Camb3D_Bldg_Active_MP_SHPX.shp -k password -pbkdf2 
set "endTime=%time: =0%"
rem Get elapsed time:
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
rem echo Start:    %startTime%
rem echo End:      %endTime%
echo Camb3D_Bldg_Active_MP_SHP.shp Elapsed:  %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%

echo "####################################################################"
del O:\public\Camb3D_Bldg_Active_MP_SHP.shp.enc
del O:\public\Camb3D_Bldg_Active_MP_SHP_1.shp.enc
del O:\public\buildings.shp.enc
del O:\public\france-natural.shp.enc
del O:\public\france-waterways.shp.enc
del O:\public\germany-points.shp.enc
del O:\public\india-natural.shp.enc
del O:\public\india-waterways.shp.enc
del O:\public\indonesia-natural.shp.enc
del O:\public\landuse.shp.enc
del O:\public\natural.shp.enc
del O:\public\points.shp.enc
del O:\public\quebec_water.shp.enc
del O:\public\spain-roads.shp.enc
del O:\public\waterways.shp.enc

del O:\public\Camb3D_Bldg_Active_MP_SHPX.shp
del O:\public\Camb3D_Bldg_Active_MP_SHP_1X.shp
del O:\public\buildingsX.shp
del O:\public\france-naturalX.shp
del O:\public\france-waterwaysX.shp
del O:\public\germany-pointsX.shp
del O:\public\india-naturalX.shp
del O:\public\india-waterwaysX.shp
del O:\public\indonesia-naturalX.shp
del O:\public\landuseX.shp
del O:\public\naturalX.shp
del O:\public\pointsX.shp
del O:\public\quebec_waterX.shp
del O:\public\spain-roadsX.shp
del O:\public\waterwaysX.shp
