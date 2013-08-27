# Main puppet file
import 'setup/*.pp'
import 'node/augeas.pp'
import 'node/postgresql9.2.pp'
import 'node/nginx.pp'
import 'node/ruby_environment.pp'
