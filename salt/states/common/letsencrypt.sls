letsencrypt_pip:
    pip:
        - installed
        - pkgs:
            - letsencrypt

/etc/cron.d/letsencrypt:
    file.managed:
        - source: salt://etc/cron.d/letsencrypt.jinja
        - template: jinja
        - user: root
        - group: root
        - mode: 644

generate_certs_onetime:
    cmd:
        - run
        - name: sh /etc/cron.d/letsencrypt
        - require:
            - file: /etc/cron.d/letsencrypt
        - unless: test -d /etc/letsencrypt/live
