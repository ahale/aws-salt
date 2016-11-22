#!/bin/bash

yum install -y https://repo.saltstack.com/yum/amazon/salt-amzn-repo-latest-1.ami.noarch.rpm
yum clean -y expire-cache
yum update -y
yum upgrade -y
yum install -y gcc cmake libffi-devel libssh2-devel python26-devel salt-minion python26-pip.noarch git

git clone -b 'v0.24.3' https://github.com/libgit2/libgit2.git /root/libgit2
cd /root/libgit2 && mkdir build && cd build && cmake .. && cmake --build . && cmake --build . --target install

pip-2.6 install 'requests==2.2.1'
pip-2.6 install 'GitPython<2.0.9'
pip-2.6 install argparse
export LD_RUN_PATH=/usr/local/lib; pip-2.6 install pygit2

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

git_pillar_provider: pygit2
ext_pillar:
    - git:
      - master git@github.com:ahale/aws-salt-private.git:
        - privkey: /root/id_rsa_ghub
        - pubkey: /root/id_rsa_ghub.pub
    - git:
      - master https://github.com/ahale/aws-salt.git:
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

instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
eip_id=$(sudo salt-call pillar.fetch networking:tools:elastic_ip_id --out=txt | awk -F': ' '{print $2}')
aws ec2 associate-address --region eu-west-1 --instance-id ${instance_id} --allocation-id ${eip_id}

salt-call --local -l debug  state.highstate
