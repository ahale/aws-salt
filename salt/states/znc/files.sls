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
# {% if 'sasl' in pillar['secrets']['znc']['users']['%s' % user]['modules'] %}
/home/ec2-user/.znc/users/{{ user }}/networks/{{ network }}/moddata/sasl:
    file.directory:
        - user: ec2-user
        - group: ec2-user
        - mode: 700
        - makedirs: True
# {% endif %}
{% endfor %}
{% endfor %}

/home/ec2-user/.znc/znc.pem:
    cmd:
        - run
        - name: sh /root/zncpem.sh
        - require:
            - sls: common.letsencrypt
            - file: /root/zncpem.sh
