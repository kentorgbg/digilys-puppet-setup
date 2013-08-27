
augeas { "exclude postgresql":
  context => "/files/etc/yum.repos.d/CentOS-Base.repo",
  changes => [
    "set base/exclude postgresql*",
    "set updates/exclude postgresql*",
  ],
}

class { 'postgresql':
  charset => 'UTF8',
  locale  => 'sv_se',
  client_package_name => 'postgresql92',
  server_package_name => 'postgresql92-server',
  contrib_package_name => 'postgresql92-contrib',
  devel_package_name => 'postgresql92-devel',
  service_name  => 'postgresql-9.2',
  bindir  => '/usr/pgsql-9.2/bin',
  datadir  => '/var/lib/pgsql/9.2/data',
}->
class { 'postgresql::server':
}

