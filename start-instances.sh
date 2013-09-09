#!/bin/sh

for instance_script in $(find /home -maxdepth 2 -name 'start-digilys-instance.sh'); do
    instance_user=$(basename $(dirname $instance_script))
    su $instance_user -c $instance_script
done
