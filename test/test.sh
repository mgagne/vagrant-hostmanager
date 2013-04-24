#!/bin/sh
. $(dirname $0)/functions.sh
cd $(dirname $0)
set -e

register_cleanup_function vagrant destroy -f
vagrant up

servers="server1 server2"

for server in ${servers}; do
  echo "[${server}] assert original output is what we expected"
  actual=$(vagrant_ssh ${server} 'cat /etc/hosts')
  expected=$(cat ${server}.prestine.hosts.file.txt)
  [ "${actual}" == "${expected}" ] || fail "Original hosts file does not match what we expected for server ${server}"
done

vagrant hostmanager

for server in ${servers}; do
  echo "[${server}] assert output is what we expect after hostmanager"
  actual=$(vagrant_ssh ${server} 'cat /etc/hosts')
  expected=$(cat ${server}.expected.hosts.file.txt)
  [ "${actual}" == "${expected}" ] || fail "Hosts file after hostmanager modifications do not match for server ${server}"
done

# Assert running twice should replace custom entries

vagrant hostmanager

for server in ${servers}; do
  echo "[${server}] assert output is what we expect after hostmanager was applied twice"
  actual=$(vagrant_ssh ${server} 'cat /etc/hosts')
  expected=$(cat ${server}.expected.hosts.file.txt)
  [ "${actual}" == "${expected}" ] || fail "Hosts file after hostmanager modifications (take 2) do not match for server ${server}"
done

echo "All tests passed."