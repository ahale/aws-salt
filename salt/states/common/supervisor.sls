supervisor_pip:
    pip:
        - installed
        - ignore_installed: True
        - pkgs:
            - supervisor

/etc/supervisord.conf:
    file.managed:
        - source: salt://etc/supervisord.conf
        - user: root
        - group: root
        - mode: 644
        - require:
            - pip: supervisor_pip

/etc/supervisor.conf.d:
    file.directory:
        - user: root
        - group: root
        - dir_mode: 755
        - makedirs: True
        - require:
            - pip: supervisor_pip

/etc/init.d/supervisor:
    file.managed:
        - source: salt://etc/init.d/supervisor
        - user: root
        - group: root
        - mode: 755
        - require:
            - pip: supervisor_pip

supervisor_svc:
    service:
        - running
        - name: supervisor
        - enable: True
        - require:
            - file: /etc/init.d/supervisor
            - file: /etc/supervisord.conf
