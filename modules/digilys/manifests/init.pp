class digilys {

  # Dependencies

  # Global setup, postgres
  # Settings are picked up using hiera
  include postgresql
  include postgresql::server

  # Instances
  $digilys_instances = hiera("digilys_instances", [])

  create_resources(digilys::instance, $digilys_instances)
}
