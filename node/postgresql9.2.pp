
augeas { "exclude postgresql":
  context => "/files/etc/yum.repos.d/CentOS-Base.repo",
  changes => [
    "set base/exclude postgresql*",
    "set updates/exclude postgresql*",
  ],
}

package { 'postgresql92': ensure => installed, }
package { 'postgresql92-server': ensure => installed, }

exec { "/sbin/service postgresql-9.2 initdb": creates => "/var/lib/pgsql/9.2/data/PG_VERSION" }
service { "postgresql-9.2": ensure => "running", }
