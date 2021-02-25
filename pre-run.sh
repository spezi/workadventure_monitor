#!/bin/bash
#######################################
#
#   Create user and folder structure
#   to keep persistant data
#
#######################################

USERNAME="monitoring"

####

DIRECTORIES=()
DIRECTORIES+=(prometheus/data)
DIRECTORIES+=(prometheus/etc)
DIRECTORIES+=(grafana/data)
DIRECTORIES+=(caddy/data)
DIRECTORIES+=(caddy/config)

RUNNING_PATH=$(realpath $(dirname $0))

if ! id "${USERNAME}" >/dev/null 2>&1; then
    useradd -d "${RUNNING_PATH}" -M -s /sbin/nologin -r "${USERNAME}"
else
    usermod -d "${RUNNING_PATH}" -s /sbin/nologin "${USERNAME}" >/dev/null
fi

USERID=$(id -u ${USERNAME})
[[ -z "${USERID}" ]] && echo "ERROR: unable to create user \"${USERNAME}\"!" && exit 1


for DIR in ${DIRECTORIES[@]}; do

    mkdir -p "${RUNNING_PATH}/${DIR}"
    chown -R "${USERNAME}.root" "${RUNNING_PATH}/${DIR}"
    chmod 700 "${RUNNING_PATH}/${DIR}"
done

sed -i 's/user: .*/user: "'${USERID}'"/g' "${RUNNING_PATH}/docker-compose.yml"

# EOF
