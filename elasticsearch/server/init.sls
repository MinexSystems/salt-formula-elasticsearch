{%- from "elasticsearch/map.jinja" import server with context %}
{%- if server.enabled %}

{%- if server.curator is defined %}
include:
  - elasticsearch.server.curator
{%- endif %}
  - elasticsearch.server.pkg

elasticsearch_packages:
  pkg.installed:
    - names: {{ server.pkgs }}


include:
  - elasticsearch.server.config
  - elasticsearch.server.logging
  - elasticsearch.server.jvm


{%- if grains.get('init') == 'systemd' %}
elasticsearch_override_limit_memlock_file:
  file.managed:
  - name: /etc/systemd/system/elasticsearch.service.d/override.conf
  - makedirs: True
  - contents: |
      [Service]
      LimitMEMLOCK=infinity
  - require:
    - pkg: elasticsearch_packages
  - watch_in:
    - module: elasticsearch_restart_systemd

elasticsearch_restart_systemd:
  module.wait:
  - name: service.systemctl_reload
  - watch_in:
    - service: elasticsearch_service
  {%- endif %}
{%- endif %}



elasticsearch_service:
  service.running:
  - enable: true
  - name: {{ server.service }}
  {%- if grains.get('noservices') %}
  - onlyif: /bin/false
  {%- endif %}
  - watch:
    - file: elasticsearch_config
    - file: elasticsearch_logging
    - file: elasticsearch_default

{%- endif %}
