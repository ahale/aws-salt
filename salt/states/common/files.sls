
/etc/cron.d/highstate:
    file.managed:
        - source: salt://etc/cron.d/highstate
        - user: root
        - group: root
        - mode: 644
