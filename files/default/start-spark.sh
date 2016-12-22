#!/bin/bash
## Starts localhost spark services (generated by Chef).
#

if [ -z "${SPARK_HOME}" ]; then
  export SPARK_HOME="$(cd "`dirname "$0"`"/..; pwd)"
fi

# Basic configs sourcing
. "${SPARK_HOME}/sbin/spark-config.sh"
. "${SPARK_HOME}/bin/load-spark-env.sh"


instance=$1
shift
CLASS="org.apache.spark.deploy.$instance.${instance^}"

SPARK_MASTER_IP=${SPARK_MASTER_IP:-0.0.0.0}
SPARK_MASTER_PORT=${SPARK_MASTER_PORT:-7077}

# default master
if ( ! echo "$*" | grep -q 'spark://' ); then
    default_master='spark://127.0.0.1:7077'
fi

case $instance in
master)
    ${SPARK_HOME}/bin/spark-class $CLASS --host $SPARK_MASTER_IP --port $SPARK_MASTER_PORT \
        $@
    ;;
worker)
    ${SPARK_HOME}/bin/spark-class $CLASS $default_master \
        $@
    ;;
*)
    >&2 echo "Can't start spark anything but master or worker!"
    exit 1
    ;;
esac
