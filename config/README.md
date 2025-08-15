# Docker Compose Overrides
The top level `docker-compose.yml` file allows plugins to run standalone. Override config files found in this directory are use for integrations into the fieldsets frame work.

Add to `plugins/docker-compose.yml`
```
include:
  - path: ${FIELDSETS_PLUGINS_PATH:-./plugins/}cache-plugin-redis/docker-compose.yml
    project_directory: ${FIELDSETS_PLUGINS_PATH:-./plugins/}cache-plugin-redis/
```

Add to `plugins/docker-comose.volumes.yml`
```
include:
  - path: ${FIELDSETS_PLUGINS_PATH:-./plugins/}cache-plugin-redis/config/docker/docker-compose.volumes.yml
    project_directory: ${FIELDSETS_PLUGINS_PATH:-./plugins/}cache-plugin-redis/
```
Add to `plugins/docker-comose.networks.yml`
```
include:
  - path: ${FIELDSETS_PLUGIN_PATH:-./plugins/}cache-plugin-redis/config/docker/networks/docker-compose-${DOCKER_NETWORK_TYPE:-bridge}-network.yml
    project_directory: ${FIELDSETS_PLUGIN_PATH:-./plugins/}cache-plugin-redis/
```

Add to `plugins/docker-comose.envars.yml`
```
include:
  - path: ${FIELDSETS_PLUGIN_PATH:-./plugins/}cache-plugin-redis/config/docker/docker-compose.envvars.yml
    project_directory: ${FIELDSETS_PLUGIN_PATH:-./plugins/}cache-plugin-redis/
```