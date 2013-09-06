define digilys::readonly_user(
  $username = $title,
  $password
) {
  postgresql::database_user { $username:
    password_hash => postgresql_password($username, $password)
  } ->
  postgresql_psql { "GRANT digilys_readonly TO ${username}":
    db     => $postgresql::params::user,
    unless => "SELECT 1 FROM pg_user LEFT JOIN pg_auth_members ON member = usesysid LEFT JOIN pg_roles ON roleid = pg_roles.oid WHERE usename = '${username}' AND rolname = 'digilys_readonly'"
  }
}
