FROM singlestoretraining/ubuntu_master:latest

# pem key
COPY ./singlestorekey.pem /home/ubuntu/.ssh/
RUN chown ubuntu:ubuntu /home/ubuntu/.ssh/singlestorekey.pem

# dependencies
RUN apt-get update && \
  wget -O - 'https://release.memsql.com/release-aug2018.gpg'  2>/dev/null | apt-key add - && \
  apt -y install apt-transport-https netcat && \
  echo "deb [arch=amd64] https://release.memsql.com/production/debian memsql main" | tee /etc/apt/sources.list.d/memsql.list && \
  apt update && apt -y install singlestore-client singlestoredb-toolbox singlestoredb-studio

# enable running studio as an init service
COPY ./singlestoredb-studio /etc/init.d/
RUN update-rc.d singlestoredb-studio defaults && service singlestoredb-studio start

CMD [ "/usr/bin/supervisord" ]
