#!/bin/bash

for i in {1..67}
do
  echo "exec: coffee find_images.coffee $i"
  coffee find_images.coffee $i
  sleep 60
done
