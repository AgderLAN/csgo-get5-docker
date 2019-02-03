ARG FROM_TAG=alcs:latest

FROM $FROM_TAG
USER root
ADD files/update-csgo.sh /tmp/
RUN chmod +x /tmp/update-csgo.sh; \
  su -c "/tmp/update-csgo.sh" -m csgo; 

USER csgo
ENTRYPOINT [ "/app/start.sh" ]