znc_packages:
    pkg:
        - installed
        - skip_verify: True
        - refresh: True
        - pkgs:
            - gcc-c++

/root/znc-1.6.3.tar.gz:
    file.managed:
        - source: http://znc.in/releases/znc-1.6.3.tar.gz
        - source_hash: md5=0dad0307e2faea26b9e304e308f7ec63
        - user: root
        - group: root
        - mode: 644
        - require:
            - pkg: znc_packages

untar_source:
    cmd:
        - run
        - name: tar -zxf znc-1.6.3.tar.gz
        - cwd: /root/
        - require:
            - file: /root/znc-1.6.3.tar.gz

configure_source:
    cmd:
        - run
        - name: sh configure
        - cwd: /root/znc-1.6.3/
        - require:
            - cmd: untar_source

make_from_source:
    cmd:
        - run
        - name: make
        - cwd: /root/znc-1.6.3/
        - require:
            - cmd: configure_source

make_install:
    cmd:
        - run
        - name: make install
        - cwd: /root/znc-1.6.3/
        - require:
            - cmd: make_from_source
