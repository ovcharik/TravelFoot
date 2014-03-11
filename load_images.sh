#!/bin/bash

for i in {1..47}
do
  echo "exec: coffee find_images.coffee $i"
  coffee find_images.coffee $i
  sleep 300
done
