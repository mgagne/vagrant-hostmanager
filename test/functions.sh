#!/bin/sh
# cleanup
cleanup_file="$(mktemp ${TMPDIR-"/tmp"}/trap_cleanup.XXXXXXXX)"

cleanup_trap() {
  set +e
  . ${cleanup_file}
  rm -f ${cleanup_file}
}
trap cleanup_trap INT EXIT TERM

register_cleanup_function() {
  echo "${@}" >> ${cleanup_file}
}
# /cleanup

vagrant_ssh() {
    local vm=$1; shift
    local cfg=$(mktemp ${TMPDIR-"/tmp"}/vagrant_ssh.XXXXXXXX)
    register_cleanup_function rm $cfg

    vagrant ssh-config $vm | grep -A 100 ^Host > $cfg
    ssh -F $cfg vagrant@$vm "${@}"
}

fail() {
  local message=$1
  echo "Failure: $message" 1>&2
  exit 1
}