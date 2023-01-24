FROM golang:latest

ARG LICENSE
ARG PASSWORD

COPY ./singlestorekey.pem /root/.ssh/

# setup dependencies
RUN mkdir -p /run/systemd && echo 'docker' > /run/systemd/container && apt-get update && \
  apt-get install -y gnupg wget net-tools vim netcat apt-transport-https openssh-server && \
  rm -f /etc/ssh/ssh_host_rsa_key* && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
  wget -O - 'https://release.memsql.com/release-aug2018.gpg'  2>/dev/null | apt-key add - && \
  echo "deb [arch=amd64] https://release.memsql.com/production/debian memsql main" | tee /etc/apt/sources.list.d/memsql.list && \
  apt update && apt -y install singlestoredb-toolbox

# install wait4x
RUN go install github.com/atkrad/wait4x/cmd/wait4x@latest

# deploy SingleStoreDB
ENTRYPOINT wait4x tcp master:22 -t 10s && sdb-deploy setup-cluster -i /root/.ssh/singlestorekey.pem --license ${LICENSE} \
  --master-host ubuntu@${MASTER_HOST} --aggregator-hosts ubuntu@${CHILD_HOST} \
  --leaf-hosts ubuntu@${LEAF1_HOST},ubuntu@${LEAF2_HOST} --password ${PASSWORD} --version 7.8 -y
