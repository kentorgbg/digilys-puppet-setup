$settings::modulepath='/root/digilys'

notice("The module path is: $settings::modulepath")

import 'setup/*.pp'
import 'node/augeas.pp'
import 'node/postgresql9.2.pp'
