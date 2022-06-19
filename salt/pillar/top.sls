base:
  '*':
    - hierarchy/common
{% for f in [ grains['region'],
              salt.file.join(grains['region'],
                             grains['datacentre']),
              salt.file.join(grains['region'],
                             grains['datacentre'],
                             grains['application']),
              salt.file.join(grains['region'],
                             grains['datacentre'],
                             grains['application'],
                             grains['environment']),
              salt.file.join(grains['region'],
                             grains['datacentre'],
                             grains['application'],
                             grains['environment'],
                             grains['role']) ] %}
{% if salt.file.access(salt.file.join('/srv/pillar/hierarchy', f, 'init.sls'),
                       'r') %}
    - {{ salt.file.join('hierarchy', f) }}
{% endif %}
{% endfor %}
