FROM centos:7

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7; \
  yum update -y; \
  yum install -y \
  glibc.i686 \
  libstdc++.i686 \
  unzip; \
  yum clean all; \
  rm -rf /var/cache/yum; \
  rm -fr /tmp/*

COPY files /tmp/
RUN groupadd -r csgo; \
  useradd --no-log-init -r -g csgo csgo; \
  mkdir -p /app/csgo/; \
  chmod +x /tmp/*.sh; \
  mv -f /tmp/start.sh /app/; \
  chown -R csgo:csgo /app/; \
  su -c "/tmp/update-csgo.sh" -m csgo; \
  su -c "/tmp/install-get5.sh /app/csgo/" -m csgo;

USER csgo
ENTRYPOINT [ "/app/start.sh" ]