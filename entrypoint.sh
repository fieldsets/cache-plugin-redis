#!/usr/bin/env bash

#===
# 00-init.sh: Wrapper script for your docker container
# See shell coding standards for details of formatting.
# https://github.com/Fieldsets/fieldsets-pipeline/blob/main/docs/developer/coding-standards/shell.md
#
# @envvar VERSION | String
# @envvar ENVIRONMENT | String
#
#===

set -eEa -o pipefail

#===
# Variables
#===

export DATA_PATH=/checkpoints/${ENVIRONMENT}/plugins/cache-plugin-redis/

#===
# Functions
#===
# Includes Methods traperr, wait_for_threads, log
source /fieldsets-lib/bash/utils.sh

##
# start: Wrapper start up function. Executes everything in mapped init directory.
##
start() {
	if [[ ! -d "${DATA_PATH}" ]]; then
        mkdir -p ${DATA_PATH}
    fi

	# Run the original entry point script
	# first arg is `-f` or `--some-option`
	# or first arg is `something.conf`
	if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
		set -- redis-server "$@"
	fi

	# allow the container to be started with `--user`
	if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
		find . \! -user redis -exec chown redis '{}' +
		exec gosu redis "$0" "$@"
	fi

	# set an appropriate umask (if one isn't set already)
	# - https://github.com/docker-library/redis/issues/305
	# - https://github.com/redis/redis/blob/bb875603fb7ff3f9d19aad906bd45d7db98d9a39/utils/systemd-redis_server.service#L37
	um="$(umask)"
	if [ "$um" = '0022' ]; then
		umask 0077
	fi

	#make sure our scripts are flagged at executable.
	chmod +x /docker-entrypoint-init.d/*.sh
	# After everything has booted, run any custom scripts.
	for f in /docker-entrypoint-init.d/*.sh; do
		echo $f;
		bash -c "exec ${f}";
	done

	log "Cache Startup Complete."
}

#===
# Main
#===
trap traperr ERR

start

env >> /etc/environment

exec "$@"
