
include:
  - nginx

pypy-web-deps:
  pkg.installed:
    - pkgs:
      - git

/srv/pypy:
  file.directory:
    - user: nginx
    - group: nginx
    - mode: 755
    - makedirs: True

/etc/nginx/sites.d/pypy-web.conf:
  file.managed:
    - source: salt://pypy-web/config/nginx.conf.jinja
    - template: jinja
    - require:
      - file: /etc/nginx/sites.d/
      - file: /srv/pypy

pypy-web-clone:
  git.latest:
    - name: https://github.com/pypy/pypy.org
    - rev: gh-pages
    - target: /srv/pypy/pypy.org
    - user: nginx
    - clean: True
    - force: True
    - require:
      - pkg: pypy-web-deps

/etc/consul.d/service-pypy-web.json:
  file.managed:
    - source: salt://consul/etc/service.jinja
    - template: jinja
    - context:
        name: pypy-web
        port: 9000
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: consul-pkgs
