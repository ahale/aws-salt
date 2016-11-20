letsencrypt_pip:
    pip:
        - installed
        - pkgs:
            - letsencrypt

/root/letsencrypt.sh:
    file.managed:
        - source: salt://root/letsencrypt.sh.jinja
        - template: jinja
        - user: root
        - group: root
        - mode: 755


/etc/cron.d/letsencrypt:
    file.managed:
        - source: salt://etc/cron.d/letsencrypt
        - template: jinja
        - user: root
        - group: root
        - mode: 644
        - require:
            - file: /root/letsencrypt.sh

generate_certs_onetime:
    cmd:
        - run
        - name: sh /root/letsencrypt.sh
        - require:
            - file: /etc/cron.d/letsencrypt
        - unless: test -d /etc/letsencrypt/live
