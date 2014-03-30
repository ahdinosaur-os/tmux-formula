{% from "tmux/map.jinja" import tmux with context %}

tmux:
  pkg.installed

tmux_conf:
  file.symlink:
    - name: {{ tmux.share_dir }}/{{ tmux.conf_name }}
    - target: {{ tmux.tmux_conf }}/tony-config/.tmux.conf
    - require:
      - pkg: tmux
      - git: tmux_conf
  git.latest:
    - name: https://github.com/tony/tmux-config
    - target: {{ tmux.tmux_conf }}/tony-config
    - submodules: True
    - require:
      - pkg: tmux

tmux_mem_cpu:
  cmd.run:
    - name: |
      cd {{ tmux.tmux_conf }}/tony-config
      cmake .
      make
      make install
    - cwd: {{ tmux.tmux_conf }}/tony-config
    - shell: true
    - timeout: 600
    - unless
      - test -x /usr/local/bin/tmux-mem-cpu
    - require:
      - git: tmux_conf
  file.managed:
    - name: /usr/local/bin/tmux-mem-cpu
    - mode: 755
    - require:
      - cmd: tmux_mem_cpu