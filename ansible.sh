######## INSTALL ANSIBLE ########

apt-get update 
apt-get install -y python python-dev python-pip libffi6 libffi-dev ruby
pip install setuptools cryptography ansible markupsafe && gem install pry && mkdir -p /etc/ansible