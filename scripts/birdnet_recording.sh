#!/usr/bin/env bash
# Performs the recording from the specified RTSP stream or soundcard
#set -x
source /etc/birdnet/birdnet.conf

# Set the logging level
LOGGING_LEVEL='error'

[ -z $RECORDING_LENGTH ] && RECORDING_LENGTH=15

if [ ! -z $RTSP_STREAM ];then
  [ -d $RECS_DIR/StreamData ] || mkdir -p $RECS_DIR/StreamData
  # Explode the RSPT steam setting into an array so we can count the number we have
  RTSP_STREAMS_EXPLODED_ARRAY=(${RTSP_STREAM//,/ })

  while true;do
# Original loop
#    for i in ${RTSP_STREAM//,/ };do
#      ffmpeg -nostdin -i  ${i} -t ${RECORDING_LENGTH} -vn -acodec pcm_s16le -ac 2 -ar 48000 file:${RECS_DIR}/StreamData/$(date "+%F")-birdnet-$(date "+%H:%M:%S").wav
#    done

    # Initially start the count off at 1 - our very first stream
    RTSP_STREAMS_STARTED_COUNT=1
    FFMPEG_PARAMS=""

    # Loop over the streams
    for i in "${RTSP_STREAMS_EXPLODED_ARRAY[@]}"
    do
      # Map id used to map input to output, this is 0 based in ffmpeg decrement
      MAP_ID=$((RTSP_STREAMS_STARTED_COUNT-1))
      # Build up the parameters to process the RSTP stream, including mapping for the output
      FFMPEG_PARAMS+="-vn -thread_queue_size 512 -i ${i} -map ${MAP_ID}:a:0 -t ${RECORDING_LENGTH} -acodec pcm_s16le -ac 2 -ar 48000 file:${RECS_DIR}/StreamData/$(date "+%F")-birdnet-RTSP_${RTSP_STREAMS_STARTED_COUNT}-$(date "+%H:%M:%S").wav "
      # Increment counter
      ((RTSP_STREAMS_STARTED_COUNT += 1))
    done

  # Make sure were passing something valid to ffmpeg, ffmpeg will run interactive and control our look by waiting ${RECORDING_LENGTH} between loops
  if [ -n "$FFMPEG_PARAMS" ];then
    ffmpeg -hide_banner -loglevel $LOGGING_LEVEL -nostdin $FFMPEG_PARAMS
  fi

  done
else
  if ! pulseaudio --check;then pulseaudio --start;fi
  if pgrep arecord &> /dev/null ;then
    echo "Recording"
  else
    until grep 5050 <(netstat -tulpn 2>&1);do
      sleep 1
    done
    if [ -z ${REC_CARD} ];then
      arecord -f S16_LE -c${CHANNELS} -r48000 -t wav --max-file-time ${RECORDING_LENGTH}\
	      --use-strftime ${RECS_DIR}/%B-%Y/%d-%A/%F-birdnet-%H:%M:%S.wav
    else
      arecord -f S16_LE -c${CHANNELS} -r48000 -t wav --max-file-time ${RECORDING_LENGTH}\
        -D "${REC_CARD}" --use-strftime \
	${RECS_DIR}/%B-%Y/%d-%A/%F-birdnet-%H:%M:%S.wav
    fi
  fi
fi
