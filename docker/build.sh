# #!/bin/bash

docker build --force-rm=true --no-cache=true -t="feather:1.0" ..
docker tag feather:1.0 feather:latest
