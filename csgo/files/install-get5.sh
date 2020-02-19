#!/bin/bash


URL_METAMOD="https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz"
URL_SOURCEMOD="https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6460-linux.tar.gz";
URL_GET5="https://github.com/splewis/get5/releases/download/0.7.1/get5_0.7.1.zip"
URL_STEAMWORKS="http://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git131-linux.tar.gz"
URL_SMJANSSON="https://github.com/thraaawn/SMJansson/raw/master/bin/smjansson.ext.so"

FILE_METAMOD="metamod.tar.gz"
FILE_SOURCEMOD="sourcemod.tar.gz"
FILE_GET5="get5.zip"
FILE_STEAMWORKS="steamworks.tar.gz"
FILE_SMJANSSON="smjansson.ext.so"

PATH_CSGO=$1
CURL="curl -sSL"

if [ -z $PATH_CSGO ]; then
  echo "The path to the CS:GO installation must be provided"
  exit -1
fi

if [[ -d "$PATH_CSGO" ]]; then :; else
  echo "The path provided is not a valid path"
  exit -2
fi

if ! PATH_WORK=$(mktemp -d); then
  echo "Unable to create temporary directory"
  exit -3
fi

download_file()
{
  COMMAND="${CURL} -o ${PATH_WORK}/${2} ${3}"
  echo "Downloading ${1} ..."
  echo $COMMAND
  if ! $($COMMAND); then
    echo "Unable to download ${1}"
    cleanup
    exit -4
  else
    echo "${1} was downloaded successfully"
  fi
}

extract_tar_gz()
{
  echo "Extracting ${1}"
  if ! $(tar -xzf $1 -C $2); then
    echo "Unable to extract archive"
    cleanup
    exit -5
  fi
}

extract_zip()
{
  echo "Extracting ${1}"
  if ! $(unzip -q -o $1 -d $2); then
    echo "Unable to extract archive"
    cleanup
    exit -6
  fi
}

copy_file()
{
  echo "Copying ${1} to ${2}"
  if ! $(cp -f $1 $2); then
    echo "Unable to copy file"
    cleanup
    exit -7
  fi
}

cleanup()
{
  echo "Deleting working folder (${PATH_WORK})"
  $(rm -fr ${PATH_WORK}) || echo "Could not delete working folder"
}

echo "Downloading and installing get5"
echo "Working directory: ${PATH_WORK}"
echo "CS:GO directory: ${PATH_CSGO}"

download_file "MetaMod" ${FILE_METAMOD} ${URL_METAMOD}
download_file "SourceMod" ${FILE_SOURCEMOD} ${URL_SOURCEMOD}
download_file "get5" ${FILE_GET5} ${URL_GET5}
download_file "SteamWorks" ${FILE_STEAMWORKS} ${URL_STEAMWORKS}
download_file "smjansson" ${FILE_SMJANSSON} ${URL_SMJANSSON}

extract_tar_gz "${PATH_WORK}/${FILE_METAMOD}" ${PATH_CSGO}
extract_tar_gz "${PATH_WORK}/${FILE_SOURCEMOD}" ${PATH_CSGO}
extract_tar_gz "${PATH_WORK}/${FILE_STEAMWORKS}" ${PATH_CSGO}
copy_file "${PATH_WORK}/${FILE_SMJANSSON}" "${PATH_CSGO}/addons/sourcemod/extensions/smjansson.ext.so"
extract_zip "${PATH_WORK}/${FILE_GET5}" "${PATH_CSGO}"
mv ${PATH_CSGO}/addons/sourcemod/plugins/disabled/get5_apistats.smx ${PATH_CSGO}/addons/sourcemod/plugins/
cleanup

echo "Sucessfully installed get5"
