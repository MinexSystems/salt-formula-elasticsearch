{%- from "elasticsearch/map.jinja" import server with context %}

{% if pillar.elasticsearch.server.use_repo %}
include:
  - elasticsearch.server.repo
{% endif %}

elasticsearch_pkg:
  pkg.installed:
    - name: {{ server.pkg }}
    {% if server.version %}
    - version: {{ server.version }}
    {% endif %}
    {% if server.use_repo %}
    - require:
      - sls: elasticsearch.server.repo
    {% endif %}
