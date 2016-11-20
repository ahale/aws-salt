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
