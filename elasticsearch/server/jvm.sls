{%- from "elasticsearch/map.jinja" import server with context %}

{%- if server.major_version == 5 %}
elasticsearch_jvm_options:
  file.managed:
    - name: /etc/elasticsearch/jvm.options
    - source: salt://elasticsearch/files/v5/jvm.options
    - template: jinja
    - require:
        - pkg: elasticsearch_pkg
{%- endif %}