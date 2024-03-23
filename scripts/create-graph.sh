#!/bin/bash

sleep 5

until cypher-shell -f create-nodes.cypher
do
  echo "create nodes failed, sleeping 5 seconds"
  sleep 5
done

echo "create nodes done"