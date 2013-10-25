define digilys::instance(
  $username = $title,
  $password,
  $url,
  $port
) {
  notice("Digilys instance: ${username} ${password} ${url} ${port}")

  $readonly_tables = hiera("digilys_readonly_tables", false)

  user { "${username}":
    ensure => present,
    managehome => true,
  } ->

  exec { "set password ${username}":
    command => "/bin/echo ${password} | passwd --stdin ${username} > /home/${username}/.puppet_password",
    creates => "/home/${username}/.puppet_password"
  } ->

  postgresql::db { "${username}":
    user     => $username,
    password => $password,
    grant    => 'all',
  } ->
  postgresql::database_grant { "digilys_readonly privileges on ${username}":
    privilege => "CONNECT",
    db        => $username,
    role      => "digilys_readonly"
  }

  if ($readonly_tables) {
    postgresql_psql { "${username}: GRANT SELECT ON ${readonly_tables} TO digilys_readonly":
      command => "GRANT SELECT ON ${readonly_tables} TO digilys_readonly",
      db      => $username,
      unless  => "SELECT 1 FROM (SELECT count(*) AS c FROM pg_tables WHERE schemaname = 'public' AND tablename = 'schema_migrations') AS t WHERE t.c != 1"
    }
  }

  digilys::ruby_environment { "${username}": } ->

  file { [
    "/home/${username}/app",
    "/home/${username}/app/shared",
    "/home/${username}/app/shared/config"
  ]:
    ensure => directory,
    owner  => $username,
    group  => $username
  } ->
  file { "/home/${username}/app/shared/config/database.yml":
    ensure  => present,
    content => template("digilys/database.yml.erb"),
    owner   => $username,
    group   => $username,
    mode    => 600
  } ->
  file { "/home/${username}/app/shared/config/passenger_port.txt":
    ensure  => present,
    content => "${port}",
    owner   => $username,
    group   => $username,
    mode    => 644
  } ->
  file { "/home/${username}/app/shared/config/app_config.private.yml":
    ensure  => present,
    replace => "no",
    content => template("digilys/app_config.private.yml.erb"),
    owner   => $username,
    group   => $username,
    mode    => 600
  } ->
  file { "/home/${username}/start-digilys-instance.sh":
    ensure  => present,
    content => template("digilys/start-instance.sh.erb"),
    owner   => $username,
    group   => $username,
    mode    => 700
  } ->

  exec { "digilys::rails_relative_url_root ${username}":
    command => "echo 'export RAILS_RELATIVE_URL_ROOT=\"${url}\"' >> /home/${username}/.bashrc",
    user    => $user,
    group   => $group,
    unless  => "test '${url}' = '/' || grep -q RAILS_RELATIVE_URL_ROOT /home/${username}/.bashrc",
    path    => ['/bin', '/usr/bin', '/usr/sbin']
  }

}
