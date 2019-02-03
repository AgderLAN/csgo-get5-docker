#!/bin/bash

CSGO_UPDATE_SCRIPT_FILE="update-csgo.txt"
TMP_DIR=$(mktemp -d) || exit -1

curl -L https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -o ${TMP_DIR}/steamcmd_linux.tar.gz || exit -1
tar xf ${TMP_DIR}/steamcmd_linux.tar.gz -C ${TMP_DIR} || exit -1

IFS='' read -r -d '' CSGO_UPDATE_SCRIPT << "EOF"
@ShutdownOnFailedCommand 1
@NoPromptForPassword 1
login anonymous
force_install_dir /app/
app_update 740 validate
quit
EOF

echo "${CSGO_UPDATE_SCRIPT}" > ${TMP_DIR}/${CSGO_UPDATE_SCRIPT_FILE}
${TMP_DIR}/steamcmd.sh +runscript ${CSGO_UPDATE_SCRIPT_FILE}
rm -f "${TMP_DIR}/${CSGO_UPDATE_SCRIPT_FILE}"