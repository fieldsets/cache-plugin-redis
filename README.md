



## Installation

`git clone --recurse-submodules https://github.com/fieldsets/cache-plugin-redis`

Add to `/plugins/docker-compose.yml``
```
version: '3.7'

include:
  - path: ./cache-plugin-redis/docker-compose.yml
    project_directory: ${FIELDSETS_PLUGIN_PATH:-./plugins/}cache-plugin-redis/
```


Add to `/plugins/docker-compose.networks.yml``
```
version: '3.7'

include:
  - path: ${FIELDSETS_PLUGIN_PATH:-./plugins/}cache-plugin-redis/config/docker/networks/docker-compose-${DOCKER_NETWORK_TYPE:-bridge}-network.yml
    project_directory: ${FIELDSETS_PLUGIN_PATH:-./plugins/}cache-plugin-redis/
```


## Tools
https://s3.amazonaws.com/redisinsight.download/public/latest/Redis-Insight-win-installer.exe