define digilys_environment($username = $title,$password,$url,$port) {
   include postgresql
   include Postgresql::Server

   notice("$username $password $url $port")
   
   user { "$username" : 
      ensure => present,
      managehome => true,
   }
   ->
   exec { "set password $username":
	command=>"/bin/echo $password|passwd --stdin $username > /home/$username/.puppet_password",
	creates=>"/home/$username/.puppet_password"
   }
   ->
  postgresql::db{ $username:
        user          => $username,
        password      => $password,
        grant         => 'all',
        }
}

$dig_envs = hiera('digilysenvironments')
create_resources(digilys_environment, $dig_envs)
