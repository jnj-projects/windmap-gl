#!/bin/bash

GFS_DATE="20230106"
GFS_TIME="00"; # 00, 06, 12, 18
RES="1p00" # 0p25, 0p50 or 1p00
BBOX="leftlon=0&rightlon=360&toplat=90&bottomlat=-90"
LEVEL="lev_10_m_above_ground=on"
GFS_URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_${RES}.pl?file=gfs.t${GFS_TIME}z.pgrb2.${RES}.f000&${LEVEL}&${BBOX}&dir=%2Fgfs.${GFS_DATE}%2F${GFS_TIME}%2Fatmos"

echo "${GFS_URL}&var_UGRD=on"

curl "${GFS_URL}&var_UGRD" -o utmp.grib
curl "${GFS_URL}&var_VGRD=on" -o vtmp.grib

grib_set -r -s packingType=grid_simple utmp.grib utmp.grib1
grib_set -r -s packingType=grid_simple vtmp.grib vtmp.grib1

printf "{\"u\":`grib_dump -j utmp.grib1`,\"v\":`grib_dump -j vtmp.grib1`}" > tmp.json

rm utmp.grib vtmp.grib

DIR=`dirname $0`
node ${DIR}/prepare.js ${1}/${GFS_DATE}${GFS_TIME}

rm tmp.json
