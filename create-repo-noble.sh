#!/bin/bash

REPOID_L=(
  'noble'
  'noble-updates'
  'noble-backports'
)

REPOID_L_S=(
  'noble-security'
)

PARAM_REMOTE_L=(
  '--distribution=noble'
  '--distribution=noble-updates'
  '--distribution=noble-backports'
)

PARAM_REMOTE_L_S=(
  '--distribution=noble-security'
)

DEFAULT_REMOTE_OPTIONS=(
    --url=http://lu.archive.ubuntu.com/ubuntu/
    --component=main --component=universe --component=multiverse --component=restricted
    --architecture=amd64
    --policy immediate
    --tls-validation False
)

DEFAULT_REMOTE_OPTIONS_S=(
    --url=http://security.ubuntu.com/ubuntu/
    --component=main --component=universe --component=multiverse --component=restricted
    --architecture=amd64
    --policy immediate
    --tls-validation False
)


POETRYRUN='poetry run'

check() { if [ $? -ne 0 ]; then echo "## Problem on check. Exit ##"; continue; fi }

CleanUp()
{
for ind in $(seq -s ' ' 0 $((${#REPOID_L[*]}-1)) )
do
    for action in publication distribution remote repository;
    do
        echo "# Destroying $action ${REPOID_L[${ind}]} #"
        $POETRYRUN pulp --no-verify-ssl  deb $action destroy --name ${REPOID_L[${ind}]};
    done
done
exit 0
}

# For testing. Function to clean quickly
[ "$1" == clean ] && CleanUp
usage()
{
    echo "Usage: $0 [-c | -s ]" 1>&2
    echo "-c : To create repositories"
    echo "-s : To sync repositories once created"
    exit 1
}

CreateRepo()
{
for ind in $(seq -s ' ' 0 $((${#REPOID_L[*]}-1)) )
do
    echo "# Create repository for ${REPOID_L[${ind}]} #"
    $POETRYRUN pulp --no-verify-ssl deb repository create --name=${REPOID_L[${ind}]} --retain-repo-versions 1
    check

    echo "# Create remote with all the necessary params for ${REPOID_L[${ind}]} #"
    $POETRYRUN pulp --no-verify-ssl deb remote create --name ${REPOID_L[${ind}]} ${PARAM_REMOTE_L[${ind}]} ${DEFAULT_REMOTE_OPTIONS[@]}
    check

    echo "# Sync the remote with the repo for ${REPOID_L[${ind}]} #"
    $POETRYRUN pulp --no-verify-ssl deb repository sync --name ${REPOID_L[${ind}]} --remote ${REPOID_L[${ind}]}
    check

    echo "# Create metadatas for ${REPOID_L[${ind}]} #"
    $POETRYRUN pulp --no-verify-ssl deb publication --type verbatim create --repository "${REPOID_L[${ind}]}"
    check

    echo "# Publish on the website for ${REPOID_L[${ind}]} #"
    $POETRYRUN pulp --no-verify-ssl deb distribution create --name "${REPOID_L[${ind}]}" --base-path "${REPOID_L[${ind}]}" --repository "${REPOID_L[${ind}]}"
    check
done
}

SyncRepo()
{
for ind in $(seq -s ' ' 0 $((${#REPOID_L[*]}-1)) )
do
    echo "# Sync the remote with the repo for ${REPOID_L[${ind}]} #"
    $POETRYRUN pulp --no-verify-ssl deb repository sync --name ${REPOID_L[${ind}]} --remote ${REPOID_L[${ind}]}
    check

    echo "# Create metadatas for ${REPOID_L[${ind}]} #"
    $POETRYRUN pulp --no-verify-ssl deb publication --type verbatim create --repository "${REPOID_L[${ind}]}"
    check
done
}

OPTSTRING="cs"
while getopts ${OPTSTRING} o; do
    case ${o} in
        c) c='create' ;;
        s) s='sync' ;;
        *) usage ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${c}" ] && [ -z "${s}" ]; then usage ; fi
if [ ! -z "${c}" ] && [ ! -z "${s}" ]; then usage ; fi

[ "${c}" == 'create' ] && CreateRepo
[ "${s}" == 'sync' ] && SyncRepo

exit 0
