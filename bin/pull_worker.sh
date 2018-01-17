#!/bin/bash

TAG=$(grep -e 'mumuki/mumuki-gobstones-worker:[0-9]*\.[0-9]*' ./lib/gobstones_runner.rb -o | tail -n 1)

echo "Pulling $TAG..."
docker pull $TAG
