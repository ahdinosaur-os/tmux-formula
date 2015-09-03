{% from "tmux/map.jinja" import tmux with context %}
{% for name, user in pillar.get('tmux', {}).items() %}
{%- if user == None -%}
{%- set user = {} -%}
{%- endif -%}
{%- set home = user.get('home', "/home/%s" % name) %}

tmux:
  pkg.installed:
    - name: {{ tmux.pkg }}

tmux_config_local:
  file.managed:
    - name: {{ home }}/{{ tmux.conf_name }}
    - source: salt://tmux/tmux.conf
    - template: jinja
    - context: {{ user | json() }}
    - defaults:
        conf: ""
    - mode: 644
    - user: {{ name }}
    - group: {{ name }}
    - require:
      - pkg: tmux

{% endfor %}
