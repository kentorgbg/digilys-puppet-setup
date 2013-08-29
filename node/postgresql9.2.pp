
augeas { "exclude postgresql":
  context => "/files/etc/yum.repos.d/CentOS-Base.repo",
  changes => [
    "set base/exclude postgresql*",
    "set updates/exclude postgresql*",
  ],
}

class { 'postgresql': }->
class { 'postgresql::server': }

