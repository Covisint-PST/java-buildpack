#!/bin/bash

sudo apt-get update
sudo apt-get install -y curl realpath sysvbanner unzip vim

mkdir -p /app
chown vagrant:vagrant /app

cat >/home/vagrant/.bash_1st_time <<EOT
#!/bin/bash

set -e

cd /vagrant/vagrant/run
ln -fs detect compile
ln -fs detect release
chmod -R 755 /vagrant/vagrant/run
banner Installing rvm
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable

banner Installing ruby 2.1.6
source /home/vagrant/.rvm/scripts/rvm
rvm install 2.1.6
rvm use 2.1.6
rvm alias create default 2.1.6
EOT

cat >>/home/vagrant/.bash_profile <<EOT1

FIRST_RUN_SCRIPT=\${HOME}/.bash_1st_time
if [[ -f \${FIRST_RUN_SCRIPT} ]]; then
	bash \${FIRST_RUN_SCRIPT}
	if [[ \$? -eq 0 ]]; then
		banner "Done"
		source \${HOME}/.rvm/scripts/rvm
		if [ -f ~/.bashrc ]; then 
		  source ~/.bashrc 
		fi
	else
		echo -e "\n\nFAILED TO SET UP RUBY 2.1.6\n\n"
	fi		
			rm -f \${FIRST_RUN_SCRIPT}

fi
EOT1
