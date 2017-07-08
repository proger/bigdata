#!/usr/bin/env bash

SECOR=$HOME/secor/target



exec java -ea \
     -Dsecor_group=secor_backup \
     -Dlog4j.configuration=log4j.prod.properties \
     -Dconfig=secor.properties \
     -cp "$SECOR"/*:"$SECOR"/lib/* \
     com.pinterest.secor.main.ConsumerMain
