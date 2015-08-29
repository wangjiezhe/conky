#!/bin/sh

AK="04023690aac687a660fb05931b870407"
LOC="嘉峪关"
API="http://api.map.baidu.com/telematics/v3/weather?location=${LOC}&output=json&ak=${AK}"

TMPDIR="/tmp/conky"
JSON="${TMPDIR}/weather.json"


for DIR in "${TMPDIR}" "${TMPDIR}/day" "${TMPDIR}/night"
do
	mkdir -p ${DIR}
done

curl -s ${API} -o ${JSON}

for day in 0 1 2 3
do
	weather_data[$day]=$(cat ${JSON} | jq ".results | .[] | .weather_data | .[$day]")

	date[$day]=$(echo ${weather_data[$day]} | jq ".date")
	weather[$day]=$(echo ${weather_data[$day]} | jq ".weather")
	temperature[$day]=$(echo ${weather_data[$day]} | jq ".temperature")
	wind[$day]=$(echo ${weather_data[$day]} | jq ".wind")
	dayPicUrl[$day]=$(echo ${weather_data[$day]} | jq ".dayPictureUrl")
	nightPicUrl[$day]=$(echo ${weather_data[$day]} | jq ".nightPictureUrl")

	daypic[$day]="${TMPDIR}/day/${day}.png"
	nightpic[$day]="${TMPDIR}/night/${day}.png"

	echo "${dayPicUrl[$day]}" | xargs curl -s -o "${daypic[$day]}"
	echo "${nightPicUrl[$day]}" | xargs curl -s -o "${nightpic[$day]}"
done

test() {
	echo ${date[*]}
	echo ${weather[*]}
	echo ${temperature[*]}
	echo ${wind[*]}
	echo ${dayPicUrl[*]}
	echo ${nightPicUrl[*]}
}
