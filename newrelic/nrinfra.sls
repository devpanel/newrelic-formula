add_infra_licence_key:
  file.append:
    - name: /etc/newrelic-infra.yml
    - text: "licence_key: {{ salt['pillar.get']('newrelic:apikey', '') }}"

download newrelic.gpg:
  file.managed:
    - name: /tmp/newrelic.gpg
    - source: https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg
    - source_hash: sha512=c38f57e18045b7f4acf373e8386d602b3fad77da862837c89c54b7c5599de3bb133b72d8a28dbe6e75191edae62432964d1f68382eeb9dbef2a115de65dff926
    - keep_source: False

get_newrelicinfra_gpg_key:
  module.run:
    - name: gpg.import_key
    - filename: /tmp/newrelic.gpg
    - user: root
    - require:
      - file: /tmp/newrelic.gpg

remove newrelic.gpg from /tmp:
  file.absent:
    - name: /tmp/newrelic.gpg
    - require:
      - module: get_newrelicinfra_gpg_key
      - file: /tmp/newrelic.gpg

newrelic-infra:
  pkg:
    - installed
    - require:
      - file: add_infra_licence_key
      - module: get_newrelicinfra_gpg_key
  service.running:
    - watch:
        - pkg: newrelic-infra
        - file: /etc/newrelic-infra.yml

