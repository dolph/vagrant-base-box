#!/bin/bash
set -e
if [ $# -ne 2 ]; then
    echo "Usage: ./bootstrap_base_box.sh <hostname> <package_name>"
    exit 1
fi
command -v ansible-playbook >/dev/null 2>&1 || { echo "Switch to a Python virtualenv with ansible installed (pip install ansible)."; exit 1; }

# this makes using ansible trivial, and we can cleanup later
ssh-copy-id root@$1

ansible-playbook -i "$1," --user="root" bootstrap.yaml

# cleanup: remove root authorized ssh key
ssh root@$1 "rm ~/.ssh/authorized_keys; shutdown -h 0 now"

echo
echo "When the machine is shutdown, package the box using your provider specific method. For example, with virtualbox:"
echo
echo "  vagrant package --base $2; mv \"package.box\" \"$2.box\""
echo
echo "Read more: http://docs.vagrantup.com/v2/virtualbox/boxes.html"
