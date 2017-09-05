{% from "elasticsearch/settings.sls" import elasticsearch with context %}

{%- if elasticsearch.major_version == 5 %}
  {%- set repo_url = 'https://artifacts.elastic.co/packages/5.x' %}
{%- elif elasticsearc.major_version == 6 %}
  {%- set repo_url = 'https://artifacts.elastic.co/packages/6.x-prerelease' %}
{%- endif %}

{%- if elasticsearch.major_version == ( 5 or 6 ) and grains['os_family'] == 'Debian' %}
apt-transport-https:
  pkg.installed
{%- endif %}

elasticsearch_repo:
  pkgrepo.managed:
    - humanname: Elasticsearch {{ elasticsearch.major_version }}
{%- if grains.get('os_family') == 'Debian' %}
  {%- if elasticsearch.major_version == ( 5 or 6 ) %}
    - name: deb {{ repo_url }}/apt stable main
  {%- endif %}
    - dist: stable
    - file: /etc/apt/sources.list.d/elasticsearch.list
    - keyid: D88E42B4
    - keyserver: keyserver.ubuntu.com
    - clean_file: true
{%- endif %}
