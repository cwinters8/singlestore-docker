FROM singlestoretraining/ubuntu_master:latest

COPY ./singlestorekey.pem /home/ubuntu/.ssh/
# enable supervisor services, including singlestoredb-studio
COPY ./supervisord.conf /etc/supervisor/

# setup dependencies
RUN chown ubuntu:ubuntu /home/ubuntu/.ssh/singlestorekey.pem && \
  wget -O - 'https://release.memsql.com/release-aug2018.gpg'  2>/dev/null | apt-key add - && \
  echo "deb [arch=amd64] https://release.memsql.com/production/debian memsql main" | tee /etc/apt/sources.list.d/memsql.list && \
  apt update && apt -y install singlestore-client singlestoredb-toolbox singlestoredb-studio

CMD [ "/usr/bin/supervisord" ]
