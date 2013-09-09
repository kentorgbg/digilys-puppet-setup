class digilys {
  # Global setup, postgres
  # Settings are picked up using hiera
  include postgresql
  include postgresql::server

  # Readonly role and users
  postgresql::role { "digilys_readonly": }
  create_resources(digilys::readonly_user, hiera("digilys_readonly_users", []))

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

  $digilys_ssl = hiera("digilys_ssl", false)

  nginx::file { "digilys.conf":
    content => template("digilys/nginx.conf.erb")
  } ->
  file { "/usr/share/nginx/html/robots.txt":
    ensure  => present,
    replace => "no",
    content => "User-Agent: *\nDisallow: /\n"
  }

  # Postgres path
  file { "/etc/profile.d/postgres92.sh":
    ensure  => present,
    content => 'export PATH=$PATH:/usr/pgsql-9.2/bin'
  }

  # Instance startup script
  exec { "digilys::instance startup script":
    command => "echo '/bin/sh /opt/digilys/start-instances.sh' >> /etc/rc.local",
    unless  => "grep -q /opt/digilys/start-instances.sh /etc/rc.local",
    path    => ['/bin', '/usr/bin', '/usr/sbin']
  }
}
