FROM debian:buster

RUN apt-get update && apt-get install -q -y --no-install-recommends \
    motion \
    jq \
    mosquitto-clients

# Copy data
COPY run.sh /
COPY delete_images.sh /
COPY motion.conf /etc/

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]