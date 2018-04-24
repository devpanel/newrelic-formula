# todo: use map.jinja here
newrelic-infra-repo:
  {% if salt['grains.get']('os_family') == 'RedHat' -%}
    
  pkg.installed:
    - sources:
    {% if salt['grains.get']('osmajorrelease')|string == '6' -%}
      - newrelic-repo: https://download.newrelic.com/infrastructure_agent/linux/yum/el/6/x86_64/newrelic-infra.repo
    {% elif salt['grains.get']('osmajorrelease')|string >= '7' -%}
      - newrelic-repo: https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
    {% endif %}
  {% elif grains['os_family'] == 'Debian' -%}
  pkgrepo.managed:
    - humanname: newrelic-repo
    {% if salt['grains.get']('os') == 'Ubuntu' -%}
      {% if salt['grains.get']('osmajorrelease')|string == '12' -%}
    - name: deb http://download.newrelic.com/infrastructure_agent/linux/apt precise main
      {% elif salt['grains.get']('osmajorrelease')|string == '14' -%}
    - name: deb http://download.newrelic.com/infrastructure_agent/linux/apt trusty main
      {% elif salt['grains.get']('osmajorrelease')|string >= '16' -%}
    - name: deb http://download.newrelic.com/infrastructure_agent/linux/apt xenial main
      {% endif %}
    {% else %}
      {% if salt['grains.get']('osmajorrelease')|string == '7' -%}
    - name: deb http://download.newrelic.com/infrastructure_agent/linux/apt wheezy main
      {% elif salt['grains.get']('osmajorrelease')|string == '8' -%}
    - name: deb http://download.newrelic.com/infrastructure_agent/linux/apt jessie main
      {% elif salt['grains.get']('osmajorrelease')|string == '9' -%}
    - name: deb http://download.newrelic.com/infrastructure_agent/linux/apt stretch main
      {% elif salt['grains.get']('osmajorrelease')|string >= '10' -%}
    - name: deb http://download.newrelic.com/infrastructure_agent/linux/apt buster main
      {% endif %}
    {% endif %} 
    - file: /etc/apt/sources.list.d/newrelic-infra.list
    - keyid: 548C16BF
    - keyserver: keyserver.ubuntu.com
  {% endif %}
    - require_in:
        - pkg: newrelic-infra
