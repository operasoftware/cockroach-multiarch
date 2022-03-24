docker service create --replicas 1 --name cockroachdb-1 --hostname cockroachdb-1 --network proxy \
                --mount type=bind,source=/var/lib/cockroach/data,target=/cockroach/cockroach-data \
                --mount type=bind,source=/var/lib/cockroach/backup,target=/cockroach/backup --stop-grace-period 60s \
                --publish 8090:8080 --publish 26257:26257 asgavar/cockroachdb-multiarch start-single-node \
                --storage-engine=pebble --external-io-dir=/cockroach/backup --cache=.66 --max-sql-memory=.66 --logtostderr \
                --insecure
