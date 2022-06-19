motd_file:
  file.managed:
    - name: /etc/motd
    - source: salt://modules/motd/motd.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
