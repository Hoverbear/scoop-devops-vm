# Install MongoDB
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
apt-get update -qq
apt-get install -qq mongodb-org-tools mongodb-org-shell

# Restore the databases
mongorestore --port $(docker port queryenginedb 27017 | awk -F':' '{print $2}') /vagrant/db-data/queryengine
