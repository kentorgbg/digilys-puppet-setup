define digilys::instance(
  $username = $title,
  $password,
  $url,
  $port
) {
  notice("Digilys instance: ${username} ${password} ${url} ${port}")

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

  digilys::ruby_environment { "${username}": }

}
