#!/bin/bash
  
cd /app/

CS_PORT=${CS_PORT:-27015}
CS_TV_PORT=${CS_TV_PORT:-27020}
CS_TICKRATE=${CS_TICKRATE:-128}
CS_NAME=${CS_NAME:-"CS:GO Server (${CS_PORT})"}


LAUNCH_PARAM="-console -usercon +port ${CS_PORT} +hostname \"${CS_NAME}\" +tv_port ${CS_TV_PORT} -tickrate ${CS_TICKRATE}"

if [ -z ${CS_ACCOUNT+x} ]; then :; else
  LAUNCH_PARAM="${LAUNCH_PARAM} +sv_setsteamaccount ${CS_ACCOUNT} -net_port_try 1 +sv_lan 0"
fi

if [ -z ${CS_RCON_PASS+x} ]; then :; else
  LAUNCH_PARAM="${LAUNCH_PARAM} +rcon_password ${CS_RCON_PASS}"
fi

if [ -z ${CS_TV_PASS+x} ]; then :; else
  LAUNCH_PARAM="${LAUNCH_PARAM} +tv_enable 1 +tv_delay 120 +tv_password ${CS_TV_PASS} +tv_relaypassword ${CS_TV_PASS}"
fi

if [ -z ${CS_ARGS+x} ]; then
  LAUNCH_PARAM="${LAUNCH_PARAM} +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust"
else
  LAUNCH_PARAM="${LAUNCH_PARAM} ${CS_ARGS}"
fi

if [ -z ${CS_PASS+x} ]; then :; else
  LAUNCH_PARAM="${LAUNCH_PARAM} +sv_password ${CS_PASS}"
fi

echo "Launching with command line: ${LAUNCH_PARAM}"
/app/srcds_run -game csgo ${LAUNCH_PARAM} 
