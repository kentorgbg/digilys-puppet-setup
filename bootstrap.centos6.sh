#!/bin/sh

# Setup additional repositories
rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm
rpm -ivh http://yum.postgresql.org/9.2/redhat/rhel-6-i386/pgdg-centos92-9.2-6.noarch.rpm
rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm

# Install required packages
yum install -y puppet-3.2.4

# Install required puppet modules
puppet module install puppetlabs/postgresql --version 2.5.0
puppet module install alup/rbenv
puppet module install thias/nginx
puppet module install saz/memcached --version 2.2.4
