#!/bin/bash

yum install -y https://repo.saltstack.com/yum/amazon/salt-amzn-repo-latest-1.ami.noarch.rpm
yum clean -y expire-cache
yum update -y
yum upgrade -y
yum install -y salt-minion python26-pip.noarch git
pip-2.6 install 'requests==2.2.1'
pip-2.6 install 'GitPython<2.0.9'
pip-2.6 install argparse

echo "
file_client: local
fileserver_backend:
    - git

gitfs_remotes:
    - https://github.com/ahale/aws-salt.git:
        - name: myznc_salt_states
        - root: salt/states
    - https://github.com/ahale/aws-salt.git:
        - name: myznc_salt_files
        - root: salt/files

ext_pillar:
    - git:
      - master git@github.com:ahale/aws-salt-private.git
        - privkey: /root/id_rsa_ghub
        - pubkey: /root/id_rsa_ghub.pub
    - git:
      - master https://github.com/ahale/aws-salt.git
        - root: salt/pillar


" > /etc/salt/minion

chkconfig salt-minion off
service salt-minion stop
aws s3 cp s3://secrets.ydna.io/id_rsa_ghub /root/id_rsa_ghub
aws s3 cp s3://secrets.ydna.io/id_rsa_ghub.pub /root/id_rsa_ghub.pub

mkdir -p /root/.ssh
echo -e 'host *\n    StrictHostKeyChecking no' > /root/.ssh/config
chmod -R 600 /root/.ssh

salt-call saltutil.sync_grains
salt-call --local -l debug  state.highstate
