#!/bin/bash

dirs=( mongoc1  mongoc2  mongoc3  mongod11  mongod12  mongod13  mongod21  mongod22  mongod23 )
for d in ${dirs[@]}; do
  echo "Resetting data/$d"
  sudo rm -rf ${DATA_DIR}/$d
  mkdir ${DATA_DIR}/$d
done
