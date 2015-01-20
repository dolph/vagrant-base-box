#!/bin/bash
set -e
if [ $# -ne 2 ]; then
    echo "Usage: ./bootstrap_base_box.sh <hostname> <boxname>"
    exit 1
fi
command -v ansible-playbook >/dev/null 2>&1 || { echo "Switch to a Python virtualenv with ansible installed (pip install ansible)."; exit 1; }

# this makes using ansible trivial, and we can cleanup later
echo "Installing authorized key..."
ssh-copy-id root@$1 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

# stomp on the remote system's existing identity
echo "Uploading well-known private key..."
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no roles/bootstrap/files/vagrant root@$1:~/ssh_host_rsa_key
echo "Uploading well-known public key..."
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no roles/bootstrap/files/vagrant.pub root@$1:~/ssh_host_rsa_key.pub
echo "Deploying well-known SSH identity..."
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$1 "chmod 0600 ~/ssh_host_rsa_key && chmod 0644 ssh_host_rsa_key.pub && mv ~/ssh_host_rsa_key* /etc/ssh"
echo "Please verify the server's new identity..."
ssh root@$1 "echo Success."

ansible-playbook -i "$1," --user="root" bootstrap.yaml

# cleanup our mess and halt the vm
ssh root@$1 "rm -rf ~/.ssh ~/.bash_history ~/.ansible; shutdown -h 0 now"

echo
echo "When the machine is shutdown, package the box using your provider-specific method. For example, with VirtualBox:"
echo
echo "  vagrant package --base \"$2\"; mv \"package.box\" \"$2.box\""
echo
echo "Read more: http://docs.vagrantup.com/v2/virtualbox/boxes.html"
