include:
  - znc.source
  - znc.files

run_process:
    cmd:
        - run
        - name: /usr/local/bin/znc
        - cwd: /home/ec2-user/
        - runas: ec2-user
        - require:
            - sls: znc.files
