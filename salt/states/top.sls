base:
  '*':
    - common
    - common.letsencrypt
    - common.supervisor

  'environment:tools':
      - match: grain
      - znc
