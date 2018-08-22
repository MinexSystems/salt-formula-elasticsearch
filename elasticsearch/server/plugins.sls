{%- from "elasticsearch/map.jinja" import server with context %}

{%- if (server.plugins is defined) and (server.plugins is not none) %}
  {%- if (server.plugins.force_install is defined) and (server.plugins.force_install is not none) and (server.plugins.force_install) %}

    {%- for plugin_name, plugin_path in server.plugins.lsit.items() -%}
elastic_install_plugin_{{ plugin_name }}:
  cmd.run:
    - name: '/usr/share/elasticsearch/bin/plugin install {{ plugin_path }} --verbose'
    {%- endfor -%}
  {%- else %}
elastic_install_plugin_info:
  test.configurable_test_state:
    - name: state_warning
    - changes: False
    - result: True
    - comment: "Plugin installer is not active."
  {%- endif %}
{%- endif %}
