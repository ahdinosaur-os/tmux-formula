{% from "tmux/map.jinja" import tmux with context %}

tmux:
  pkg.installed

{% set tmux_config = "%s/tmux-config" % tmux.share_dir %}
tmux_conf:
  file.symlink:
    - name: {{ tmux.share_dir }}/{{ tmux.conf_name }}
    - target: {{ tmux_config }}/.tmux.conf
    - require:
      - pkg: tmux
      - git: tmux_conf
  git.latest:
    - name: https://github.com/ahdinosaur-os/tmux-config
    - target: {{ tmux_config }}
    - submodules: True
    - require:
      - pkg: tmux

tmux_mem_cpu:
  cmd.run:
    - names:
      - cmake .
      - make
      - make install
    - cwd: {{ tmux_config }}/vendor/tmux-mem-cpu-load
    - unless: "test -x /usr/local/bin/tmux-mem-cpu"
    - require:
      - git: tmux_conf
      - pkg: cmake
      - pkg: make
  file.managed:
    - name: /usr/local/bin/tmux-mem-cpu
    - mode: 755
    - require:
      - cmd: tmux_mem_cpu

cmake:
  pkg.installed

make:
  pkg.installed
