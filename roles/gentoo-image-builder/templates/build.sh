_packages="{{ image_info.build.packages | default('') }}"
image="{{ image_info.name }}"
set -x; set -e; set -o pipefail # any error aborts the build except if explictly allowed by adding "|| true"
build(){
  {{ image_info.build.configure_builder | default('true') }}
  export ROOT={{ builder.image_root }}
  mkdir -p {{ builder.image_root }}/etc/portage/profile/ {{ builder.image_root }}/var/db/pkg/
  for f in /package.provided-*; do [ -f "${f}" ] && cat "${f}" >> {{ builder.image_root }}/etc/portage/profile/package.provided; done
  cp -rdp /pkg-*/* {{ builder.image_root }}/var/db/pkg/ || true
  {{ image_info.build.configure_rootfs_build | default('true') }}
  [ ! -z "${_packages}" ] && emerge --binpkg-respect-use=y -v ${_packages}
  {{ image_info.build.finish_rootfs_build | default('true') }}
  {% if image_info.name != 'scratch' %}{{ builder.finish_build | default('true') }}{% endif %}
}
