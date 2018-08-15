{%- from "elasticsearch/map.jinja" import server with context %}
elasticsearch_default:
  file.managed:
    - name: /etc/default/elasticsearch
    - source: salt://elasticsearch/files/v{{ server.major_version }}/elasticsearch
    - template: jinja
    - require:
        - pkg: elasticsearch_pkg

elasticsearch_config:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://elasticsearch/files/v{{ server.major_version }}/elasticsearch.yml
    - template: jinja
    - require:
        - pkg: elasticsearch_pkg