# todo: use map.jinja here

# {% if grains['os_family'] == 'Debian' -%}
# download newrelic.gpg:
#   file.managed:
#     - name: /tmp/newrelic.gpg
#     - source: https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg
#     - source_hash: sha512=c38f57e18045b7f4acf373e8386d602b3fad77da862837c89c54b7c5599de3bb133b72d8a28dbe6e75191edae62432964d1f68382eeb9dbef2a115de65dff926
#     - keep_source: False

# get_newrelicinfra_gpg_key:
#   cmd.run:
#     - name: apt-key add
#     - filename: /tmp/newrelic.gpg
#     - user: root
#     - require:
#       - file: download newrelic.gpg

# remove newrelic.gpg from /tmp:
#   file.absent:
#     - name: /tmp/newrelic.gpg
#     - require:
#       - module: get_newrelicinfra_gpg_key
# # {% endif %}

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
    - gpg_check: 1
    - key_url: https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg
  {% endif %}
    - require_in:
        - pkg: newrelic-infra
