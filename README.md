

## Installation
Edit Fieldsets `./plugins/docker-compose.yml` to include our plugin.

```
version: '3.7'

include:
  - path: ./cache-plugins-redis/docker-compose.yml
    project_directory: ./cache-plugins-redis/
```