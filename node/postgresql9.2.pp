
augeas { "exclude postgresql":
  context => "/files/etc/yum.repos.d/CentOS-Base.repo",
  changes => [
    "set base/exclude postgresql*",
    "set updates/exclude postgresql*",
  ],
}

package { 'postgresql92':
  ensure => installed,
}

