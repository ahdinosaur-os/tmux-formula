{% from "tmux/map.jinja" import tmux with context %}

tmux:
  pkg.installed

{% set tmux_tony = "%s/tmux-tony" % tmux.share_dir %}
tmux_conf:
  file.symlink:
    - name: {{ tmux.share_dir }}/{{ tmux.conf_name }}
    - target: {{ tmux_tony }}/.tmux.conf
    - require:
      - pkg: tmux
      - git: tmux_conf
  git.latest:
    - name: https://github.com/tony/tmux-config
    - target: {{ tmux_tony }}
    - submodules: True
    - require:
      - pkg: tmux

tmux_mem_cpu:
  cmd.run:
    - names:
      - cmake .
      - make
      - make install
    - cwd: {{ tmux_tony }}
    - unless: "test -x /usr/local/bin/tmux-mem-cpu"
    - require:
      - git: tmux_conf
  file.managed:
    - name: /usr/local/bin/tmux-mem-cpu
    - mode: 755
    - require:
      - cmd: tmux_mem_cpu