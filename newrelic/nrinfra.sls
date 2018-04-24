add_infra_licence_key:
  file.append:
    - name: /etc/newrelic-infra.yml
    - text: "licence_key: {{ salt['pillar.get']('newrelic:apikey', '') }}"

newrelic-infra:
  pkg:
    - installed
  service.running:
    - watch:
        - pkg: newrelic-infra
        - file: /etc/newrelic-infra.yml

