#
# Cookbook Name:: nhm-windshaft
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "apt"

package "postgresql-contrib-9.1"
package "postgresql-9.1-postgis"

apt_repository "mapnik" do
  uri "http://ppa.launchpad.net/mapnik/v2.2.0/ubuntu"
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          '5D50B6BA'
end

%w{libmapnik libmapnik-dev mapnik-utils python-mapnik}.each do |p|
  package p
end

include_recipe "redisio::install"
include_recipe "redisio::enable"

application "nhm-windshaft" do
  path "/var/www/nhm-windshaft"
  owner "www-data"
  group "www-data"
  packages ["git"]

  repository "git@bitbucket.org:gravitystorm/nhm-windshaft-app.git"
  deploy_key node[:nhm_windshaft][:deploy_key]

  nodejs do
    environment "HOME" => "/var/www/nhm-windshaft"
    entry_point "server.js"
  end
end

db_name = "nhm_botany"
db_user = "www-data"
cluster = "9.1/main"

# TODO split into an admin user, for loading data + postgis, and a read-only
# user for www-data access

postgresql_user db_user do
  cluster cluster
  superuser true
  action :create
end

postgresql_database db_name do
  cluster cluster
  owner db_user
  action :create
end
