FROM {{ req_section }}/{{ builder.default_builder }}-{{ requires }}:{{ req_tag }} as builder
ADD build.sh /
RUN source /build.sh && build
FROM {% if requires == 'scratch' %}scratch{% else %}{{ registry }}/{{ req_section }}/{{ requires }}:{{ req_tag }}{% endif %}

{% if env is defined -%}
{% for e in env %}
ENV {{ e }}="{{ env[e] }}"
{% endfor %}
{% endif %}
{% if image_info.name != 'scratch' %}

COPY --from=builder /image-root/ /
{% if workdir is defined -%}
WORKDIR "{{ workdir }}"
{% endif %}
{% if user is defined -%}
USER "{{ user }}"
{% endif %}
{% if entrypoint is defined -%}
ENTRYPOINT ["{{ entrypoint | join('","') }}"]
{% endif %}
{% endif %}
