include:
  - .repo
  {% if salt['pkg.list_pkgs']().get('php5', False) -%}
  - .daemon
  - .php
  {% endif %}
  {% if salt['pillar.get']('newrelic:servers_enable', False) %}
  - .nrsysmond
  {% endif %}
  {% if salt['pillar.get']('newrelic:infrastructure_enable', False) %}
  - .repo-infra
  - .nrinfra
  {% endif %}
