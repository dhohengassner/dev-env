ansible-galaxy -r /vagrant/ansiblePlaybooks/requirements.yml install
ansible-playbook -i "localhost," -c local /vagrant/ansiblePlaybooks/devMachine.yml