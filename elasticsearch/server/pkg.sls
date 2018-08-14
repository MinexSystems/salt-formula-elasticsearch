{%- from "elasticsearch/map.jinja" import server with context %}

{% if pillar.elasticsearch.server.use_repo %}
include:
  - elasticsearch.repo
{% endif %}

elasticsearch_pkg:
  pkg.installed:
    - name: {{ server.pkgs }}
    {% if server.version %}
    - version: {{ elasticsearch.version }}
    {% endif %}
    {% if server.use_repo %}
    - require:
      - sls: elasticsearch.repo
    {% endif %}
