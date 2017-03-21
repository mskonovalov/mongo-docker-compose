#!/bin/bash

mongo_container_name='mongod'

for (( rs = 1; rs < 3; rs++ )); do
  echo "Initialising replica ${rs} set"

  ip1="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${mongo_container_name}${rs}1)"
  echo "${ip1}"
  ip2="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${mongo_container_name}${rs}2)"
  echo "${ip1}"
  ip3="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${mongo_container_name}${rs}3)"
  echo "${ip1}"
  replicate="rs.initiate(); sleep(1000); cfg = rs.conf(); cfg.members[0].host = \"${ip1}\"; rs.reconfig(cfg); rs.add(\"${ip2}\"); rs.add(\"${ip3}\"); rs.status();"
  docker exec -it ${mongo_container_name}${rs}1 bash -c "echo '${replicate}' | mongo"
done

sleep 2
# Add better mechanism to wait for mongos connectivity to be
# established by tailing docker log for connection readiness


ip1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mongod11)
ip2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mongod22)
docker exec -it mongos1 bash -c "echo \"sh.addShard('mongors1/${ip1}:27017'); sh.addShard('mongors2/${ip2}:27017');\" | mongo "
