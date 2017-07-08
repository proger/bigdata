#!/usr/bin/env bash

set -x

SECOR=$HOME/secor/target

# ProgressMonitorMain
# LogFilePrinterMain
CLASS_NAME=com.pinterest.secor.main.${1:-ConsumerMain}
shift

exec java -ea \
     -Dsecor_group=secor0 \
     -Dlog4j.configuration=file://"$PWD"/log4j.prod.properties \
     -Dconfig=file://"$PWD"/secor.properties \
     -Ds3service.s3-endpoint-http-port=80 \
     -cp .:"$SECOR"/*:"$SECOR"/lib/* \
     "$CLASS_NAME" "$@"
