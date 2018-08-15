{%- from "elasticsearch/map.jinja" import server with context %}

{%- if server.major_version == 2 %}
elasticsearch_logging:
  file.managed:
    - name: /etc/elasticsearch/logging.yml
    - source: salt://elasticsearch/files/v2/logging.yml
    - template: jinja
    - require:
      - pkg: elasticsearch_pkg
{%- endif %}

{%- if server.major_version == 5 %}
elasticsearch_logging:
  file.managed:
    - name: /etc/elasticsearch/log4j2.properties
    - source: salt://elasticsearch/files/v5/log4j2.properties
    - template: jinja
    - require:
      - pkg: elasticsearch_pkg
{%- endif %}


{%- if server.get('log', {}).logrotate|default(True) and not
    salt['file.file_exists' ]('/etc/logrotate.d/elasticsearch') %}
{#
Create logrotate config only if it doesn't already exist to avoid conflict
with logrotate formula or possibly package-shipped config
#}

elasticsearch_logrotate:
    file.managed:
      - name: /etc/logrotate.d/elasticsearch
      - source: salt://elasticsearch/files/logrotate.conf
      - template: jinja

{%- endif %}