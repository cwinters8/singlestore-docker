FROM ubuntu:latest

# package installs
RUN apt-get update && apt-get install -y sudo gnupg wget net-tools vim netcat supervisor openssh-server apt-transport-https

COPY ./singlestorekey.pem /home/ubuntu/.ssh/
COPY ./singlestorekey.pub /home/ubuntu/.ssh/authorized_keys
COPY ./sysctl.conf ./sudoers /etc/
COPY ./sshd_config /etc/sshd/
COPY ./ssh_config ./sshd_config /etc/ssh/

# setup dependencies
RUN mkdir -p /run/systemd /var/run/sshd && echo 'docker' > /run/systemd/container && \
  adduser --gecos "" --disabled-password ubuntu && usermod -aG sudo ubuntu && chmod 755 /var/run/sshd && \
  chown ubuntu /home/ubuntu/.ssh && chmod 700 /home/ubuntu/.ssh && chown ubuntu:ubuntu /home/ubuntu/.ssh/singlestorekey.pem && \
  wget -O - 'https://release.memsql.com/release-aug2018.gpg'  2>/dev/null | apt-key add - && \
  echo "deb [arch=amd64] https://release.memsql.com/production/debian memsql main" | tee /etc/apt/sources.list.d/memsql.list && \
  apt update && apt -y install singlestore-client singlestoredb-toolbox singlestoredb-studio

EXPOSE 22 3306 8080

# enable supervisor services, including singlestoredb-studio
COPY ./supervisord.conf /etc/supervisor/

CMD [ "/usr/bin/supervisord" ]
