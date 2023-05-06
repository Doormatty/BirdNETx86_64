#!/usr/bin/env bash
# This script removes all data that has been collected. It is tantamount to
# starting all data-collection from scratch. Only run this if you are sure
# you are okay will losing all the data that you've collected and processed
# so far.
set -x
source /etc/birdnet/birdnet.conf
USER=$(awk -F: '/1000/ {print $1}' /etc/passwd)
HOME=$(awk -F: '/1000/ {print $6}' /etc/passwd)
BIRDNETDIR=${HOME}/BirdNETx86_64/scripts
echo "Stopping services"
sudo systemctl stop birdnet_recording.service
sudo systemctl stop birdnet_analysis.service
sudo systemctl stop birdnet_server.service
echo "Removing all data . . . "
sudo rm -drf "${RECS_DIR}"
sudo rm -f "${IDFILE}"
sudo rm -f $(dirname ${BIRDNETDIR})/BirdDB.txt

echo "Re-creating necessary directories"
[ -d ${EXTRACTED} ] || sudo -u ${USER} mkdir -p ${EXTRACTED}
[ -d ${EXTRACTED}/By_Date ] || sudo -u ${USER} mkdir -p ${EXTRACTED}/By_Date
[ -d ${EXTRACTED}/Charts ] || sudo -u ${USER} mkdir -p ${EXTRACTED}/Charts
[ -d ${PROCESSED} ] || sudo -u ${USER} mkdir -p ${PROCESSED}

sudo -u ${USER} ln -fs $(dirname $BIRDNETDIR)/exclude_species_list.txt $BIRDNETDIR
sudo -u ${USER} ln -fs $(dirname $BIRDNETDIR)/include_species_list.txt $BIRDNETDIR
sudo -u ${USER} ln -fs $(dirname $BIRDNETDIR)/homepage/* ${EXTRACTED}
sudo -u ${USER} ln -fs $(dirname $BIRDNETDIR)/model/labels.txt ${BIRDNETDIR}
sudo -u ${USER} ln -fs $BIRDNETDIR ${EXTRACTED}
sudo -u ${USER} ln -fs $BIRDNETDIR/play.php ${EXTRACTED}
sudo -u ${USER} ln -fs $BIRDNETDIR/spectrogram.php ${EXTRACTED}
sudo -u ${USER} ln -fs $BIRDNETDIR/overview.php ${EXTRACTED}
sudo -u ${USER} ln -fs $BIRDNETDIR/stats.php ${EXTRACTED}
sudo -u ${USER} ln -fs $BIRDNETDIR/todays_detections.php ${EXTRACTED}
sudo -u ${USER} ln -fs $BIRDNETDIR/history.php ${EXTRACTED}
sudo -u ${USER} ln -fs $BIRDNETDIR/weekly_report.php ${EXTRACTED}
sudo -u ${USER} ln -fs $BIRDNETDIR/homepage/images/favicon.ico ${EXTRACTED}
sudo -u ${USER} ln -fs ${HOME}/phpsysinfo ${EXTRACTED}
sudo -u ${USER} ln -fs $(dirname $BIRDNETDIR)/templates/phpsysinfo.ini ${HOME}/phpsysinfo/
sudo -u ${USER} ln -fs $(dirname $BIRDNETDIR)/templates/green_bootstrap.css ${HOME}/phpsysinfo/templates/
sudo -u ${USER} ln -fs $(dirname $BIRDNETDIR)/templates/index_bootstrap.html ${HOME}/phpsysinfo/templates/html
chmod -R g+rw $BIRDNETDIR
chmod -R g+rw ${RECS_DIR}


echo "Dropping and re-creating database"
createdb.sh
echo "Re-generating BirdDB.txt"
touch $(dirname ${BIRDNETDIR})/BirdDB.txt
echo "Date;Time;Sci_Name;Com_Name;Confidence;Lat;Lon;Cutoff;Week;Sens;Overlap" > $(dirname ${BIRDNETDIR})/BirdDB.txt
ln -sf $(dirname ${BIRDNETDIR})/BirdDB.txt ${BIRDNETDIR}/BirdDB.txt
chown $USER:$USER ${BIRDNETDIR}/BirdDB.txt && chmod g+rw ${BIRDNETDIR}/BirdDB.txt
echo "Restarting services"
restart_services.sh
