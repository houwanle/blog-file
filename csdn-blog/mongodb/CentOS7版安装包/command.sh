#!/bin/bash

mongod=/usr/local/mongodb-linux-x86_64-rhel70-3.6.3/bin/mongod

exec_mkdir() {
  mkdir -p mgset/mongod1/log
  mkdir -p mgset/mongod1/data
  mkdir -p mgset/mongod2/log
  mkdir -p mgset/mongod2/data
  mkdir -p mgset/mongod3/log
  mkdir -p mgset/mongod3/data
}

exec_clean() {
  rm -rf mgset/mongod1/log/*
  rm -rf mgset/mongod1/data/*
  rm -rf mgset/mongod2/log/*
  rm -rf mgset/mongod2/data/*
  rm -rf mgset/mongod3/log/*
  rm -rf mgset/mongod3/data/*
}

init_keyfile() {
  mkdir -p mgset
  openssl rand -base64 745 > mgset/keyFile
  chmod 600 mgset/keyFile
}

function init_replcaset_file() {
  IP=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`
  echo "
  config = {
    _id : \"mongodbSet\",
    members : [
    {_id : 0, host : \"${IP}:27001\" , priority : 2},
    {_id : 1, host : \"${IP}:27002\" },
    {_id : 2, host : \"${IP}:27003\" , arbiterOnly: true }
    ]  
  }
  rs.initiate(config)
" > initiate.txt
}

function init_config() {
echo "
systemLog:
  destination: file
  path: $(pwd)/mgset/$1/log/$1.log
  logAppend: true
  quiet: true
storage:
  journal:
    enabled: true
  dbPath: $(pwd)/mgset/$1/data
processManagement:
  fork: true
  pidFilePath: $(pwd)/mgset/$1/log/$1.pid
net:
  bindIp: 0.0.0.0
  port: $2
replication:
  replSetName: mongodbSet
  oplogSizeMB: 1024	
" > mgset/$1/config.conf
}


exec_noauth() {
  ${mongod} -f mgset/mongod1/config.conf
  ${mongod} -f mgset/mongod2/config.conf
  ${mongod} -f mgset/mongod3/config.conf
}

exec_start() {
  ${mongod} -f mgset/mongod1/config.conf --keyFile=mgset/keyFile
  ${mongod} -f mgset/mongod2/config.conf --keyFile=mgset/keyFile
  ${mongod} -f mgset/mongod3/config.conf --keyFile=mgset/keyFile
}

exec_stop() {
  ${mongod} -f mgset/mongod3/config.conf --shutdown
  ${mongod} -f mgset/mongod2/config.conf --shutdown
  ${mongod} -f mgset/mongod1/config.conf --shutdown
}


case "$1" in
  init)
  exec_mkdir
  exec_clean
  init_config mongod1 27001
  init_config mongod2 27002
  init_config mongod3 27003
  init_keyfile
  init_replcaset_file
  ;;

  noauth)
  exec_stop
  exec_noauth
  ;;

  start)
  exec_stop
  exec_start
  ;;

  stop)
  exec_stop
  ;;

  *)
  echo "Usage:$0{init|noauth|start|stop}"
esac
exit 0
