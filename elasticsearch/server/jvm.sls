elasticsearch_jvm_options:
  file.managed:
    - name: /etc/elasticsearch/jvm.options
    - source: salt://elasticsearch/files/v5/jvm.options
    - template: jinja
    - require:
        - pkg: elasticsearch_packages