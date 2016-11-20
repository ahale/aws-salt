include: znc.source

/home/ec2-user/.znc/configs:
    file.directory:
        - user: ec2-user
        - group: ec2-user
        - mode: 755
        - makedirs: True
        - require:
            sls: znc.source

/home/ec2-user/.znc/configs/znc.conf:
    file.managed:
    - source: salt://home/ec2-user/.znc/configs/znc.conf.jinja
    - template: jinja
    - user: ec2-user
    - group: ec2-user
    - mode: 600
    - requires:
        - file: /home/ec2-user/.znc/configs
