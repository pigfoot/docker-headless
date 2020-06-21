#!/usr/bin/env sh

#mkdir -p ./src ./userData
#chgrp -R 1000 ./src ./userData

docker container run -it --rm \
    --security-opt seccomp=$(pwd)/chrome.json \
    -v $(pwd)/src:/usr/src/app/src \
    -v $(pwd)/userData:/usr/src/app/userData \
    pigfoot/headless:latest \
    node src/google.js
