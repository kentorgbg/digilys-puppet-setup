include nginx

# $digilys_instances = [ "instance01", "instance02" ]
$digilys_instances = []

nginx::file { "digilys.conf":
  content => template("digilys/digilys.conf.erb")
}
