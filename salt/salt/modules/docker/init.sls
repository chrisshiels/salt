docker_packages:
  pkg.installed:
    - names:
        - docker-ce
        - docker-ce-cli
        - containerd.io
        - docker-compose-plugin
        - docker-compose
    - refresh: True
    - require:
        - repositories_sources_docker


docker_groupmembership:
  group.present:
    - name: docker
    - addusers:
        - vagrant


docker_service:
  service.running:
    - name: docker
    - enable: True
    - require:
        - docker_packages
