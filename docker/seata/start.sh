#!/bin/sh
set -eu
cd /seata-server
mkdir -p logs
exec java -server -Xms512m -Xmx512m -XX:MaxDirectMemorySize=1024m \
  -classpath "/seata-server/conf:/seata-server/lib/*" \
  io.seata.server.Server
