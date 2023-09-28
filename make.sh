#!/bin/bash

#
# variables
#
# AWS variables
export AWS_PROFILE=aws_rd_off
export AWS_REGION=ap-southeast-1
# project variables
export PROJECT_NAME=testworld-2
# the directory containing the script file
export PROJECT_DIR="$(cd "$(dirname "$0")"; pwd)"

#
# overwrite TF variables
#
export TF_VAR_project_name=$PROJECT_NAME
export TF_VAR_region=$AWS_REGION

log() { echo -e "\e[30;47m ${1^^} \e[0m ${@:2}"; }          # $1 uppercase background white
info() { echo -e "\e[48;5;28m ${1^^} \e[0m ${@:2}"; }       # $1 uppercase background green
warn() { echo -e "\e[48;5;202m ${1^^} \e[0m ${@:2}" >&2; }  # $1 uppercase background orange
error() { echo -e "\e[48;5;196m ${1^^} \e[0m ${@:2}" >&2; } # $1 uppercase background red

# export functions : https://unix.stackexchange.com/a/22867
export -f log info warn error

# log $1 in underline then $@ then a newline
under() {
    local arg=$1
    shift
    echo -e "\033[0;4m${arg}\033[0m ${@}"
    echo
}

usage() {
    under usage 'call the Makefile directly: make dev
      or invoke this file directly: ./make.sh dev'
}

. ./terraform/vpc/vpc.sh
. ./terraform/mina-sandbox/mina-sandbox.sh

# if `$1` is a function, execute it. Otherwise, print usage
# compgen -A 'function' list all declared functions
# https://stackoverflow.com/a/2627461
FUNC=$(compgen -A 'function' | grep $1)
[[ -n $FUNC ]] && {
    info execute $1
    eval $1
} || usage
exit 0