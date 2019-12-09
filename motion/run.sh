#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

CONFIG=$(jq --raw-output ".config" $CONFIG_PATH)
VIDEODEVICE=$(jq --raw-output ".videodevice" $CONFIG_PATH)
INPUT=$(jq --raw-output ".input" $CONFIG_PATH)
WIDTH=$(jq --raw-output ".width" $CONFIG_PATH)
HEIGHT=$(jq --raw-output ".height" $CONFIG_PATH)
FRAMERATE=$(jq --raw-output ".framerate" $CONFIG_PATH)
TEXTRIGHT=$(jq --raw-output ".text_right" $CONFIG_PATH)
TARGETDIR=$(jq --raw-output ".target_dir" $CONFIG_PATH)
SNAPSHOTINTERVAL=$(jq --raw-output ".snapshot_interval" $CONFIG_PATH) 
SNAPSHOTNAME=$(jq --raw-output ".snapshot_name" $CONFIG_PATH) 
PICTUREOUTPUT=$(jq --raw-output ".picture_output" $CONFIG_PATH)
PICTURENAME=$(jq --raw-output ".picture_name" $CONFIG_PATH)
MOVIEOUTPUT=$(jq --raw-output ".movie_output" $CONFIG_PATH)
MOVIENAME=$(jq --raw-output ".movie_name" $CONFIG_PATH)
WEBCONTROLLOCAL=$(jq --raw-output ".webcontrol_local" $CONFIG_PATH)
WEBCONTROLHTML=$(jq --raw-output ".webcontrol_html" $CONFIG_PATH)
DELETE_IMAGES_INTERVAL=$(jq --raw-output ".delete_images_interval" $CONFIG_PATH)


echo "[Info] Show connected usb devices"
ls -al /dev/video*

if [ ! -f "$CONFIG" ]; then
	echo "[Info] Config motion"
	sed -i "s|%%VIDEODEVICE%%|$VIDEODEVICE|g" /etc/motion.conf
	sed -i "s|%%INPUT%%|$INPUT|g" /etc/motion.conf
	sed -i "s|%%WIDTH%%|$WIDTH|g" /etc/motion.conf
	sed -i "s|%%HEIGHT%%|$HEIGHT|g" /etc/motion.conf
	sed -i "s|%%FRAMERATE%%|$FRAMERATE|g" /etc/motion.conf
	sed -i "s|%%TEXTRIGHT%%|$TEXTRIGHT|g" /etc/motion.conf
	sed -i "s|%%TARGETDIR%%|$TARGETDIR|g" /etc/motion.conf
	sed -i "s|%%SNAPSHOTINTERVAL%%|$SNAPSHOTINTERVAL|g" /etc/motion.conf
	sed -i "s|%%SNAPSHOTNAME%%|$SNAPSHOTNAME|g" /etc/motion.conf
	sed -i "s|%%PICTUREOUTPUT%%|$PICTUREOUTPUT|g" /etc/motion.conf
	sed -i "s|%%PICTURENAME%%|$PICTURENAME|g" /etc/motion.conf
	sed -i "s|%%MOVIEOUTPUT%%|$MOVIEOUTPUT|g" /etc/motion.conf
	sed -i "s|%%MOVIENAME%%|$MOVIENAME|g" /etc/motion.conf
	sed -i "s|%%WEBCONTROLLOCAL%%|$WEBCONTROLLOCAL|g" /etc/motion.conf
	sed -i "s|%%WEBCONTROLHTML%%|$WEBCONTROLHTML|g" /etc/motion.conf
fi

if [ ! -f "$CONFIG" ]; then
	echo "[Info] Config Script delete_images"
	cp /delete_images.sh /share/motion/delete_images.sh

	REMOVECMD='find '$TARGETDIR'/ -type f ! -name "lastsnap.jpg" -exec rm -rf {} \\;'
	echo REMOVECMD
	sed -i "s|%%PLACEHOLDER%%|$REMOVECMD|g" /share/motion/delete_images.sh
	sed -i "s|%%DELETE_IMAGES_INTERVAL%%|$DELETE_IMAGES_INTERVAL|g" /share/motion/delete_images.sh

	CONFIG=/etc/motion.conf
fi

chmod a+x /share/motion/delete_images.sh

echo "[Info] Run delete_images"
/share/motion/delete_images.sh &

# start server
motion -c $CONFIG