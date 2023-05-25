{%- set default_sources = {'module' : 'gc-ar-yumrepo', 'defaults' : True, 'pillar' : True} %}
{%- from "./defaults/load_config.jinja" import config as gc_ar_yumrepo with context %}

{% if gc_ar_yumrepo.use is defined %}

{% if gc_ar_yumrepo.use | to_bool %}

Google_Cloud_Packages_RPM_Signing_Key:
  rpm_.imported_gpg_key:
    - key_path: {{ gc_ar_yumrepo.gc_ar_packages_rpm_signing_key }}

{% else %}

Google_Cloud_Packages_RPM_Signing_Key:
  rpm_.removed_gpg_key:
    - key_path: {{ gc_ar_yumrepo.gc_ar_packages_rpm_signing_key }}

google-cloud-artifact-registry-plugin:
  pkgrepo.managed:
    - humanname: Artifact Registry Plugin
    - baseurl: https://packages.cloud.google.com/yum/repos/{% if grains['osmajorrelease'] < 8 %}yum{% else %}dnf{% endif %}-plugin-artifact-registry-$releasever-stable
    - gpgkey: {{ gc_ar_yumrepo.ar_plugin_gpgkey }}
    - gpgcheck: 1

{% endif %}

{% endif %}