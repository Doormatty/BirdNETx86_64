#!/usr/bin/env bash
source /etc/birdnet/birdnet.conf
if [ ${APPRISE_WEEKLY_REPORT} == 1 ];then
	NOTIFICATION=$(curl 'localhost/views.php?view=Weekly%20Report&ascii=true')
	NOTIFICATION=${NOTIFICATION#*#}
	firstLine=`echo "${NOTIFICATION}" | head -1`
	NOTIFICATION=`echo "${NOTIFICATION}" | tail -n +2`
	/root/BirdNETx86_64/birdnet/bin/apprise -vv -t "${firstLine}" -b "${NOTIFICATION}" --input-format=html --config=/root/BirdNETx86_64/apprise.txt
fi