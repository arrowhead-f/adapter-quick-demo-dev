#!/bin/bash

cd "$(dirname "$0")" || exit
source "lib_certs.sh"

create_keystore() {
  SYSTEM_NAME=$1

  create_system_keystore \
    "../../certificates/master.p12" "arrowhead.eu" \
    "../../certificates/testcloud2.p12" "testcloud2.aitia.arrowhead.eu" \
    "../../certificates/${SYSTEM_NAME}.p12" "${SYSTEM_NAME}.testcloud2.aitia.arrowhead.eu" \
    "dns:localhost,ip:127.0.0.1"
}

create_keystore $1
create_keystore $2