{%- from "elasticsearch/map.jinja" import server with context %}
{%- if server.enabled %}

include:
{%- if server.curator is defined %}
  - elasticsearch.server.curator
{%- endif %}
  - elasticsearch.server.pkg
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
    - pkg: elasticsearch_pkg
  - watch_in:
    - module: elasticsearch_restart_systemd

elasticsearch_restart_systemd:
  module.wait:
  - name: service.systemctl_reload
  - watch_in:
    - service: elasticsearch_service
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
{%- else %}
elasticsearch_log_not_enabled:
  test.configurable_test_state:
    - name: state_error
    - changes: False
    - result: False
    - comment: 'ERROR: Elasticsearch server is not enabled.'
{%- endif %}
