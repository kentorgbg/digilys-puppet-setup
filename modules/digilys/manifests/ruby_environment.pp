define digilys::ruby_environment (
  $user         = $title,
  $ruby_version = "1.9.3-p392",
  $rc           = ".bashrc"
) {

  rbenv::install { "${user}":
    rc => $rc
  } ->

  rbenv::compile { "${user}/${ruby_version}":
    ruby   => $ruby_version,
    user   => $user,
    global => true
  } ->

  exec { "install bundler for ${user}":
    user    => $user,
    cwd     => "/home/${user}",
    path    => [ "/home/${user}/.rbenv/shims", "/home/${user}/.rbenv/bin", "/usr/bin", "/bin" ],
    command => "gem install bundler"
  }

}
