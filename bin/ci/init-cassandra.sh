echo "deb http://debian.datastax.com/datastax-ddc 3.9 main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl -L https://debian.datastax.com/debian/repo_key | apt-key add -
apt-get update
apt-get install datastax-ddc
service cassandra stop
service cassandra start