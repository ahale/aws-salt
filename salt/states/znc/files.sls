include:
    - znc.source
    - common.letsencrypt

/home/ec2-user/.znc/configs:
    file.directory:
        - user: ec2-user
        - group: ec2-user
        - mode: 755
        - makedirs: True
        - require:
            - sls: znc.source

/home/ec2-user/.znc/configs/znc.conf:
    file.managed:
        - source: salt://home/ec2-user/.znc/configs/znc.conf.jinja
        - template: jinja
        - user: ec2-user
        - group: ec2-user
        - mode: 600
        - require:
            - file: /home/ec2-user/.znc/configs

{% for user in pillar['secrets']['znc']['users'] %}
{% for network in pillar['secrets']['znc']['users']['%s' % user]['networks'] %}
/home/ec2-user/.znc/users/{{ user }}/networks/{{ network }}/moddata/sasl:
    file.directory:
        - user: ec2-user
        - group: ec2-user
        - mode: 700
        - makedirs: True

/home/ec2-user/.znc/users/{{ user }}/networks/{{ network }}/moddata/sasl/.registry:
    file.managed:
        - source: salt://home/ec2-user/.znc/sasl.jinja
        - template: jinja
        - context:
            mechanisms: {{ pillar['secrets']['znc']['users']['%s' % user]['networks']['%s' % network]['sasl']['mechanisms'] }}
            password: {{ pillar['secrets']['znc']['users']['%s' % user]['networks']['%s' % network]['sasl']['password'] }}
            username: {{ pillar['secrets']['znc']['users']['%s' % user]['networks']['%s' % network]['sasl']['username'] }}
        - user: ec2-user
        - group: ec2-user
        - mode: 600
{% endfor %}
{% endfor %}

/home/ec2-user/.znc/znc.pem:
    cmd:
        - run
        - name: sh /root/zncpem.sh
        - require:
            - sls: common.letsencrypt
            - file: /root/zncpem.sh
