{%- set default_sources = {'module' : 'gc-ar-yumrepo', 'defaults' : True, 'pillar' : True} %}
{%- from "./defaults/load_config.jinja" import config as gc_ar_yumrepo with context %}

{% if gc_ar_yumrepo.use is defined %}

{%- if grains['osmajorrelease'] < 8 %}
{% set plugin_artifact_registry_format = 'yum' %}
{% else %}
{% set plugin_artifact_registry_format = 'dnf' %}
{% endif -%}

{% if gc_ar_yumrepo.use | to_bool %}

Google_Cloud_Packages_RPM_Signing_Key:
  rpm_.imported_gpg_key:
    - key_path: {{ gc_ar_yumrepo.gc_ar_packages_rpm_signing_key }}

google-cloud-artifact-registry-plugin:
  pkgrepo.managed:
    - humanname: Artifact Registry Plugin
    - baseurl: https://packages.cloud.google.com/yum/repos/{{ plugin_artifact_registry_format }}-plugin-artifact-registry-$releasever-stable
    - gpgkey: {{ gc_ar_yumrepo.ar_plugin_gpgkey }}
    - gpgcheck: 1

{{ plugin_artifact_registry_format }}-plugin-artifact-registry:
  pkg.installed:
    - refresh: true
    - require:
      - Google_Cloud_Packages_RPM_Signing_Key
      - pkgrepo: google-cloud-artifact-registry-plugin

{% else %}

{{ plugin_artifact_registry_format }}-plugin-artifact-registry:
  pkg.removed:
    - required_in:
      - removed_Google_Cloud_Packages_RPM_Signing_Key

google-cloud-artifact-registry-plugin:
  pkgrepo.absent:
    - require:
      - pkg: {{ plugin_artifact_registry_format }}-plugin-artifact-registry

removed_Google_Cloud_Packages_RPM_Signing_Key:
  rpm_.removed_gpg_key:
    - key_path: {{ gc_ar_yumrepo.gc_ar_packages_rpm_signing_key }}

{% endif %}

{% endif %}