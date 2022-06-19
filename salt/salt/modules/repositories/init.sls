repositories_packages:
  pkg.installed:
    - pkgs:
        - ca-certificates
        - curl
        - gnupg
        - lsb-release


{% for repository in pillar.repositories_repositories.keys() %}
repositories_sources_{{ repository }}:
  pkgrepo.managed:
    - humanname: {{ pillar.repositories_repositories[repository].humanname }}
    - name: {{ pillar.repositories_repositories[repository].name }}
    - file: {{ pillar.repositories_repositories[repository].file }}
    - gpgcheck: {{ pillar.repositories_repositories[repository].gpgcheck }}
    - key_url: {{ pillar.repositories_repositories[repository].key_url }}
    - require:
        - repositories_packages
{% endfor %}


# Note:
# - The key is added into /etc/apt/trusted.gpg presumably via apt-key.
