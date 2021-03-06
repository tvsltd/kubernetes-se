#!/bin/bash
#
# Restore InfluxDB from local dumpfile.
# Author: Just van den Broecke
# Usage: restore.sh <dump file .tar.gz>
# Example: restore.sh influxdb-dc1_airsenseur_181123.tar.gz
#
# NB: the .tar.gz file should have a topdir of database name
# as created via backup.sh

SCRIPT_DIR=${0%/*}

pushd ${SCRIPT_DIR}
	if [ ! -f influxdb.env ]
	then
	    echo "Bestand influxdb.env niet gevonden."
	    exit 1
	fi
    source influxdb.env
popd

# Need dump file tar.gz as arg
DUMP_FILE="$1"
if [ "${DUMP_FILE}x" = "x" ];
then
    echo "Error: no dump file specified"
    exit -1
fi

# Copy and execute script on RUNNING Pod/Container
CMD="restore-cmd.sh"

# Copy and enable command in container
kubectl cp ${CMD} ${NS}/${CONTAINER_NAME}:/${CMD}
kubectl -n ${NS} exec ${CONTAINER_NAME} -- chmod +x /${CMD}

# Copy dumpfile to fixed name container
kubectl cp ${DUMP_FILE} ${NS}/${CONTAINER_NAME}:${CONTAINER_DUMP_FILE}

# Execute restore in container
kubectl -n ${NS} exec ${CONTAINER_NAME} -- /${CMD}

# Cleanup
kubectl -n ${NS} exec ${CONTAINER_NAME} -- rm /${CMD} ${CONTAINER_DUMP_FILE}
