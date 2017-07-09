## [kafka](https://kafka.apache.org/quickstart)

kafka acts like `tail -n $(wc -l stuff.log) -f stuff.log` for subscribers and like `some-crap | tee stuff.log` for publishers, while it rotates `stuff.log` (called a *topic*) automatically.

[kafkacat](https://cwiki.apache.org/confluence/display/KAFKA/Clients#Clients-stdin/stdout) looks like a good cli client

```bash
brew install kafka kafkacat
brew install https://ludocode.github.io/msgpack-tools.rb

zookeeper-server-start /usr/local/etc/kafka/zookeeper.properties & kafka-server-start /usr/local/etc/kafka/server.properties

kafka-topics --create --topic json \
  --config retention.bytes=$((1024*1024)) \
  --config segment.bytes=$((1024*1024)) \
  --partitions 1 \
  --replication-factor 1 \
  --zookeeper localhost:2181

# try also:  retention.ms

kafkacat -P -b localhost -t json < ~/dmd-interesting.json

# if not using -o beginning, it seems that kafka/zk is storing your last read offset
# that id that kafka/zk remembers is called a "consumer group"
kafkacat -C -b localhost -t json -o beginning
```

demo:

```console
% kafkacat -L -b localhost -t json
Metadata for json (from broker -1: localhost:9092/bootstrap):
 1 brokers:
  broker 0 at 192.168.1.60:9092
 1 topics:
  topic "json" with 1 partitions:
    partition 0, leader 0, replicas: 0, isrs: 0
```

## s3 simulator

- [minio](https://www.minio.io/)

```bash
mkdir -p storage/localhost

env MINIO_ACCESS_KEY=minio MINIO_SECRET_KEY=miniostorage minio server ./storage --address :5000
jq -r .credential ~/.minio/config.json 
```

- or fakes3

```bash
gem install --user fakes3
fakes3 --root ./storage --port 5000
```


in any case you also should create a bucket manually:

```bash
s3cmd --config s3cfg-minio mb s3://localhost
```


## [secor](https://github.com/pinterest/secor)

secor reads kafka and stores gzipped files in s3.

compile and install (use [my fork](https://github.com/proger/secor) if [secor#351](https://github.com/pinterest/secor/pull/351) is not merged by then)

```bash
(git clone https://github.com/pinterest/secor.git ~/secor; cd ~/secor; mvn package)
```

run:

```bash
mkdir ./backup
./secor.sh
```

wait and try:

```bash
s3cmd --config s3cfg-minio ls -r s3://localhost/secor
```

## query

- just use, say, python+s3fs: see query.ipynb
- [prestodb](https://prestodb.io/faq.html) (needs hive) gives you SQL


## other formats to look at

- https://orc.apache.org/ (binary, need schema)
- [parquet](https://parquet.apache.org/) (binary, need schema) with [fastparquet](https://www.continuum.io/blog/developer-blog/introducing-fastparquet)
- https://github.com/wesm/feather
- https://arrow.apache.org/ (in-memory format for libs)
- msgpack with [msgpack-tools](https://github.com/ludocode/msgpack-tools) (no schema, doesn't have bignums)
