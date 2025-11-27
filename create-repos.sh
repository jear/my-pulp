    #!/bin/bash

    REPOID_L=(
      'bionic' 
      'bionic-updates' 
      'bionic-security' 
      'focal' 
      'focal-updates' 
      'focal-security' 
      'jammy' 
      'jammy-updates' 
      'jammy-security' 
        )

    PARAM_REMOTE_L=(
          '--distribution=bionic'
          '--distribution=bionic-updates'
          '--distribution=bionic-security' 
          '--distribution=focal'
          '--distribution=focal-updates'
          '--distribution=focal-security' 
          '--distribution=jammy'
          '--distribution=jammy-updates'
          '--distribution=jammy-security' 
        )

    DEFAULT_REMOTE_OPTIONS=(
        --url=http://ch.archive.ubuntu.com/ubuntu/
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
        for action in repository remote distribution;
        do 
            echo "# Destroying $action ${REPOID_L[${ind}]} #" 
            $POETRYRUN pulp deb $action destroy --name ${REPOID_L[${ind}]};
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
        $POETRYRUN pulp deb repository create --name=${REPOID_L[${ind}]}
        check

        echo "# Create remote with all the necessary params for ${REPOID_L[${ind}]} #"
        $POETRYRUN pulp deb remote create --name ${REPOID_L[${ind}]} ${PARAM_REMOTE_L[${ind}]} ${DEFAULT_REMOTE_OPTIONS[@]}
        check

        echo "# Sync the remote with the repo for ${REPOID_L[${ind}]} #"
        $POETRYRUN pulp deb repository sync --name ${REPOID_L[${ind}]} --remote ${REPOID_L[${ind}]}
        check

        echo "# Create metadatas for ${REPOID_L[${ind}]} #"
        $POETRYRUN pulp deb publication create --repository "${REPOID_L[${ind}]}"
        check

        echo "# Publish on the website for ${REPOID_L[${ind}]} #"
        $POETRYRUN pulp deb distribution create --name "${REPOID_L[${ind}]}" --base-path "${REPOID_L[${ind}]}" --repository "${REPOID_L[${ind}]}"
        check
    done
    }

    SyncRepo()
    { 
    for ind in $(seq -s ' ' 0 $((${#REPOID_L[*]}-1)) )
    do
        echo "# Sync the remote with the repo for ${REPOID_L[${ind}]} #"
        $POETRYRUN pulp deb repository sync --name ${REPOID_L[${ind}]} --remote ${REPOID_L[${ind}]}
        check

        echo "# Create metadatas for ${REPOID_L[${ind}]} #"
        $POETRYRUN pulp deb publication create --repository "${REPOID_L[${ind}]}"
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
