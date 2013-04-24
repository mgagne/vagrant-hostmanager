#!/bin/sh
. $(dirname $0)/functions.sh
set -e

vagrant_box_dir="$(mktemp -d ${TMPDIR-"/tmp"}/box_dir.XXXXXXXX)"

register_cleanup_function "cd ${vagrant_box_dir} && vagrant destroy -f && cd -"
register_cleanup_function "rm -rf ${vagrant_box_dir}"

cd ${vagrant_box_dir}
vagrant init precise32 http://files.vagrantup.com/precise32.box
echo "Vagrant.require_plugin('vagrant-hostmanager')" >> Vagrantfile
vagrant up
vagrant ssh -c 'true'
cd -

echo "$(basename $0) passed."