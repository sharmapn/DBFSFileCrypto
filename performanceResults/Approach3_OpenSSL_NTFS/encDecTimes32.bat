@echo off
setlocal EnableDelayedExpansion
echo "Encryption Time"

set "startTime=%time: =0%"
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\points.shp -out D:\OpenSSLencryptionTimes\points.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\france-waterways.shp -out D:\OpenSSLencryptionTimes\france-waterways.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\france-natural.shp -out D:\OpenSSLencryptionTimes\france-natural.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\indonesia-natural.shp -out D:\OpenSSLencryptionTimes\indonesia-natural.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\germany-points.shp -out D:\OpenSSLencryptionTimes\germany-points.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\waterways.shp -out D:\OpenSSLencryptionTimes\waterways.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\buildings.shp -out D:\OpenSSLencryptionTimes\buildings.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\india-natural.shp -out D:\OpenSSLencryptionTimes\india-natural.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\natural.shp -out D:\OpenSSLencryptionTimes\natural.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\india-waterways.shp -out D:\OpenSSLencryptionTimes\india-waterways.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\spain-roads.shp -out D:\OpenSSLencryptionTimes\spain-roads.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\quebec_water.shp -out D:\OpenSSLencryptionTimes\quebec_water.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHP_1.shp -out D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHP_1.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\landuse.shp -out D:\OpenSSLencryptionTimes\landuse.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -aes-256-cbc -in D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHP.shp -out D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHP.shp.enc -k passwordpasswordpasswordpassword -pbkdf2
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\points.shp.enc -out D:\OpenSSLencryptionTimes\pointsX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\france-waterways.shp.enc -out D:\OpenSSLencryptionTimes\france-waterwaysX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\france-natural.shp.enc -out D:\OpenSSLencryptionTimes\france-naturalX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\indonesia-natural.shp.enc -out D:\OpenSSLencryptionTimes\indonesia-naturalX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\germany-points.shp.enc -out D:\OpenSSLencryptionTimes\germany-pointsX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\waterways.shp.enc -out D:\OpenSSLencryptionTimes\waterwaysX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\buildings.shp.enc -out D:\OpenSSLencryptionTimes\buildingsX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\india-natural.shp.enc -out D:\OpenSSLencryptionTimes\india-naturalX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\natural.shp.enc -out D:\OpenSSLencryptionTimes\naturalX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\india-waterways.shp.enc -out D:\OpenSSLencryptionTimes\india-waterwaysX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\spain-roads.shp.enc -out D:\OpenSSLencryptionTimes\spain-roadsX.shp -k passwordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\quebec_water.shp.enc -out D:\OpenSSLencryptionTimes\quebec_waterX.shp -k passwordpasswordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHP_1.shp.enc -out D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHP_1X.shp -k passwordpasswordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\landuse.shp.enc -out D:\OpenSSLencryptionTimes\landuseX.shp -k passwordpasswordpasswordpasswordpassword -pbkdf2 
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
openssl enc -d -aes-256-cbc -in D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHP.shp.enc -out D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHPX.shp -k passwordpasswordpasswordpasswordpassword -pbkdf2 
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
del D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHP.shp.enc
del D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHP_1.shp.enc
del D:\OpenSSLencryptionTimes\buildings.shp.enc
del D:\OpenSSLencryptionTimes\france-natural.shp.enc
del D:\OpenSSLencryptionTimes\france-waterways.shp.enc
del D:\OpenSSLencryptionTimes\germany-points.shp.enc
del D:\OpenSSLencryptionTimes\india-natural.shp.enc
del D:\OpenSSLencryptionTimes\india-waterways.shp.enc
del D:\OpenSSLencryptionTimes\indonesia-natural.shp.enc
del D:\OpenSSLencryptionTimes\landuse.shp.enc
del D:\OpenSSLencryptionTimes\natural.shp.enc
del D:\OpenSSLencryptionTimes\points.shp.enc
del D:\OpenSSLencryptionTimes\quebec_water.shp.enc
del D:\OpenSSLencryptionTimes\spain-roads.shp.enc
del D:\OpenSSLencryptionTimes\waterways.shp.enc

del D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHPX.shp
del D:\OpenSSLencryptionTimes\Camb3D_Bldg_Active_MP_SHP_1X.shp
del D:\OpenSSLencryptionTimes\buildingsX.shp
del D:\OpenSSLencryptionTimes\france-naturalX.shp
del D:\OpenSSLencryptionTimes\france-waterwaysX.shp
del D:\OpenSSLencryptionTimes\germany-pointsX.shp
del D:\OpenSSLencryptionTimes\india-naturalX.shp
del D:\OpenSSLencryptionTimes\india-waterwaysX.shp
del D:\OpenSSLencryptionTimes\indonesia-naturalX.shp
del D:\OpenSSLencryptionTimes\landuseX.shp
del D:\OpenSSLencryptionTimes\naturalX.shp
del D:\OpenSSLencryptionTimes\pointsX.shp
del D:\OpenSSLencryptionTimes\quebec_waterX.shp
del D:\OpenSSLencryptionTimes\spain-roadsX.shp
del D:\OpenSSLencryptionTimes\waterwaysX.shp
