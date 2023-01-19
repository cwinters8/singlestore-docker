FROM singlestoretraining/ubuntu_master:latest

ARG LICENSE
ARG PASSWORD

# ENV MASTER_HOST=ubuntu@${MASTER_HOST}
# ENV CHILD_HOST=ubuntu@${CHILD_HOST}
# ENV LEAF1_HOST=ubuntu@${LEAF1_HOST}
# ENV LEAF2_HOST=ubuntu@${LEAF2_HOST}

# pem key
COPY ./singlestorekey.pem /home/ubuntu/.ssh/
RUN chown ubuntu:ubuntu /home/ubuntu/.ssh/singlestorekey.pem

# dependencies
RUN apt-get update && \
  wget -O - 'https://release.memsql.com/release-aug2018.gpg'  2>/dev/null | apt-key add - && \
  apt -y install apt-transport-https netcat && \
  echo "deb [arch=amd64] https://release.memsql.com/production/debian memsql main" | tee /etc/apt/sources.list.d/memsql.list && \
  apt update && apt -y install singlestoredb-toolbox

# deploy SingleStoreDB
ENTRYPOINT sdb-deploy setup-cluster -i /home/ubuntu/.ssh/singlestorekey.pem --license ${LICENSE} \
  --master-host ubuntu@${MASTER_HOST} --aggregator-hosts ubuntu@${CHILD_HOST} \
  --leaf-hosts ubuntu@${LEAF1_HOST},ubuntu@${LEAF2_HOST} --password ${PASSWORD} --version 8.0
