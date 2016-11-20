common_packages:
    pkg:
        - installed
        - skip_verify: True
        - refresh: True
        - pkgs:
            - curl
            - traceroute
            - strace
            - gcc
            - dialog
            - openssl-devel
            - ca-certificates
            - libffi-devel
            - augeas-libs
