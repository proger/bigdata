deploy:

```
mkdir -p roles/secor/files/secor
cp -R ~/secor/target/{*.jar,lib} roles/secor/files/secor/
ansible-galaxy install andrewrothstein.kafka -p roles
ansible-playbook -u root -i hostname, playbook.yml
```

on the server:

```
env KAFKA_HEAP_OPTS="-Xmx128M -Xms128M" zookeeper-server-start.sh -daemon /usr/local/kafka/config/zookeeper.properties

env KAFKA_HEAP_OPTS="-Xmx512G -Xms512M" kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties

kafka-topics.sh --create --topic json \
  --config retention.bytes=$((1024*1024*1024*10)) \
  --config retention.ms=$((5*60*60*1000)) \
  --partitions 1 \
  --replication-factor 1 \
  --zookeeper localhost:2181
```
