class digilys {
  # Global setup, postgres
  # Settings are picked up using hiera
  include postgresql
  include postgresql::server

  # Dependencies
  if ! defined(Package["libxml2-devel"])      { package { "libxml2-devel":      ensure => installed } }
  if ! defined(Package["libxslt-devel"])      { package { "libxslt-devel":      ensure => installed } }
  if ! defined(Package["postgresql92-devel"]) { package { "postgresql92-devel": ensure => installed } }
  if ! defined(Package["libcurl-devel"])      { package { "libcurl-devel":      ensure => installed } }

  # Instances
  $digilys_instances = hiera("digilys_instances", [])

  create_resources(digilys::instance, $digilys_instances)

  # nginx, uses $digilys_instances in the template
  include nginx
  nginx::file { "digilys.conf":
    content => template("digilys/nginx.conf.erb")
  }
}
