{%- from "elasticsearch/map.jinja" import server with context %}
elasticsearch_default:
  file.managed:
    - name: /etc/default/elasticsearch
    - source: salt://elasticsearch/files/v{{ server.version }}/elasticsearch
    - template: jinja
    - require:
        - pkg: elasticsearch_packages

elasticsearch_config:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://elasticsearch/files/v{{ server.version }}/elasticsearch.yml
    - template: jinja
    - require:
        - pkg: elasticsearch_packages