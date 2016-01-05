#!/bin/bash
#
# provision.sh
#
# This file is specified in Vagrantfile and is loaded by Vagrant as the primary
# provisioning script whenever the commands `vagrant up`, `vagrant provision`,
# or `vagrant reload` are used. It provides all of the default packages and
# configurations included with Varying Vagrant Vagrants.

# By storing the date now, we can calculate the duration of provisioning at the
# end of this script.
start_seconds="$(date +%s)"

# Network Detection
#
# Make an HTTP request to google.com to determine if outside access is available
# to us. If 3 attempts with a timeout of 5 seconds are not successful, then we'll
# skip a few things further in provisioning rather than create a bunch of errors.
if [[ "$(wget --tries=3 --timeout=5 --spider http://google.com 2>&1 | grep 'connected')" ]]; then
	echo "Network connection detected..."
	ping_result="Connected"
else
	echo "Network connection not detected. Unable to reach google.com..."
	ping_result="Not Connected"
fi

# PACKAGE INSTALLATION
#
# Build a bash array to pass all of the packages we want to install to a single
# apt-get command. This avoids doing all the leg work each time a package is
# set to install. It also allows us to easily comment out or add single
# packages. We set the array as empty to begin with so that we can append
# individual packages to it as required.
apt_package_install_list=()

# Start with a bash array containing all packages we want to install in the
# virtual machine. We'll then loop through each of these and check individual
# status before adding them to the apt_package_install_list array.
apt_package_check_list=(

	imagemagick
	subversion
	git-core
	zip
	unzip
	ngrep
	curl
	make
	vim
	colordiff
	postfix
	# emacs
	# emacs-goodies-el

	# Req'd for building Swift from source
	git
	cmake
	ninja-build
	clang-3.4
	clang-3.6
	python
	uuid-dev
	libicu-dev
	icu-devtools
	libbsd-dev
	libedit-dev
	libxml2-dev
	libsqlite3-dev
	swig
	libpython-dev
	libncurses5-dev
	pkg-config

	# ntp service to keep clock current
	ntp

	# Req'd for i18n tools
	gettext

	# Req'd for Webgrind
	graphviz

	# dos2unix
	# Allows conversion of DOS style line endings to something we'll have less
	# trouble with in Linux.
	dos2unix

	# nodejs for use by grunt
	g++
	nodejs
)

echo "Check for apt packages to install..."
# Loop through each of our packages that should be installed on the system. If
# not yet installed, it should be added to the array of packages to install.
for pkg in "${apt_package_check_list[@]}"; do
	package_version="$(dpkg -s $pkg 2>&1 | grep 'Version:' | cut -d " " -f 2)"
	if [[ -n "${package_version}" ]]; then
		space_count="$(expr 20 - "${#pkg}")" #11
		pack_space_count="$(expr 30 - "${#package_version}")"
		real_space="$(expr ${space_count} + ${pack_space_count} + ${#package_version})"
		printf " * $pkg %${real_space}.${#package_version}s ${package_version}\n"
	else
		echo " *" $pkg [not installed]
		apt_package_install_list+=($pkg)
	fi
done

# Disable ipv6 as some ISPs/mail servers have problems with it
echo "inet_protocols = ipv4" >> /etc/postfix/main.cf

if [[ $ping_result == "Connected" ]]; then

	# If there are any packages to be installed in the apt_package_list array,
	# then we'll run `apt-get update` and then `apt-get install` to proceed.
	if [[ ${#apt_package_install_list[@]} = 0 ]]; then
		echo -e "No apt packages to install.\n"
	else
		# Before running `apt-get update`, we should add the public keys for
		# the packages that we are installing from non standard sources via
		# our appended apt source.list

		# Retrieve the Swift signing key from swift.org
		echo "Applying Swift signing key..."
		wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -

		# Apply the nodejs assigning key
		echo "Applying nodejs signing key..."
		apt-key adv --quiet --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C7917B12 2>&1 | grep "gpg:"
		apt-key export C7917B12 | apt-key add -

		# update all of the package references before installing anything
		echo "Running apt-get update..."
		apt-get update --assume-yes

		# install required packages
		echo "Installing apt-get packages..."
		apt-get install --assume-yes ${apt_package_install_list[@]}

		# Clean up apt caches
		apt-get clean
	fi

	# Make sure we have the latest npm version
	npm install -g npm

	# ack-grep
	#
	# Install ack-rep directory from the version hosted at beyondgrep.com as the
	# PPAs for Ubuntu Precise are not available yet.
	if [[ -f /usr/bin/ack ]]; then
		echo "ack-grep already installed"
	else
		echo "Installing ack-grep as ack"
		curl -s http://beyondgrep.com/ack-2.04-single-file > /usr/bin/ack && chmod +x /usr/bin/ack
	fi

	# COMPOSER
	#
	# Install Composer if it is not yet available.
	if [[ ! -n "$(composer --version --no-ansi | grep 'Composer version')" ]]; then
		echo "Installing Composer..."
		curl -sS https://getcomposer.org/installer | php
		chmod +x composer.phar
		mv composer.phar /usr/local/bin/composer
	fi

	# Update both Composer and any global packages. Updates to Composer are direct from
	# the master branch on its GitHub repository.
	if [[ -n "$(composer --version --no-ansi | grep 'Composer version')" ]]; then
		echo "Updating Composer..."
		COMPOSER_HOME=/usr/local/src/composer composer self-update
		COMPOSER_HOME=/usr/local/src/composer composer -q global require --no-update phpunit/phpunit:4.3.*
		COMPOSER_HOME=/usr/local/src/composer composer -q global require --no-update phpunit/php-invoker:1.1.*
		COMPOSER_HOME=/usr/local/src/composer composer -q global require --no-update mockery/mockery:0.9.*
		COMPOSER_HOME=/usr/local/src/composer composer -q global require --no-update d11wtq/boris:v1.0.8
		COMPOSER_HOME=/usr/local/src/composer composer -q global config bin-dir /usr/local/bin
		COMPOSER_HOME=/usr/local/src/composer composer global update
	fi

	# Grunt
	#
	# Install or Update Grunt based on current state.  Updates are direct
	# from NPM
	if [[ "$(grunt --version)" ]]; then
		echo "Updating Grunt CLI"
		npm update -g grunt-cli &>/dev/null
		npm update -g grunt-sass &>/dev/null
		npm update -g grunt-cssjanus &>/dev/null
	else
		echo "Installing Grunt CLI"
		npm install -g grunt-cli &>/dev/null
		npm install -g grunt-sass &>/dev/null
		npm install -g grunt-cssjanus &>/dev/null
	fi

	# Graphviz
	#
	# Set up a symlink between the Graphviz path defined in the default Webgrind
	# config and actual path.
	echo "Adding graphviz symlink for Webgrind..."
	ln -sf /usr/bin/dot /usr/local/bin/dot

	use_provisioner=false
	provisioner=false
	for i in "$@"
	do
		if [[ "$use_provisioner" = "true" ]] && [[ "$provisioner" = "false" ]]
		then
			provisioner=$i
		fi

		if [ "$i" = "--provision-with" ]
		then
			use_provisioner=true
		fi
	done

	if [ "$provisioner" = "source" ]
	then
		# ---------------------------------------------
		# Building Swift from source
		# ---------------------------------------------
		echo "Setting up build environment..."
		sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 100
		sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100

		cd ~
		mkdir swift-src
		cd ~/swift-src
		echo "Download Swift source..."
		git clone https://github.com/apple/swift.git
		cd swift
		echo "Download Swift dependencies..."
		./utils/update-checkout --clone
		echo "Building Swift from source..."
		./utils/build-script --preset=buildbot_linux_1404 install_destdir=~/swift-build installable_package=~/swift.tar.gz
		sudo rsync -rl .~/swift-build/usr/ /usr/
		# ---------------------------------------------
		# END - Building Swift from source
		# ---------------------------------------------
	else
		# ---------------------------------------------
		# Install Swift from Binaries
		# ---------------------------------------------
		echo "Downloading Swift..."
		cd ~
		curl 'https://swift.org/builds/ubuntu1404/swift-2.2-SNAPSHOT-2015-12-31-a/swift-2.2-SNAPSHOT-2015-12-31-a-ubuntu14.04.tar.gz' > swift.tar.gz
		echo "Extracting Swift..."
		mkdir swift-tools
		tar -zxvf swift.tar.gz -C ./swift-tools/ --strip-components=1
		echo "Installing Swift..."
		cd ~/swift-tools/usr/
		sudo rsync --remove-source-files -rl ./ /usr/
		cd ~
		rm -rf swift-tools
		# ---------------------------------------------
		# END - Install Swift from Binaries
		# ---------------------------------------------
	fi

else
	echo -e "\nNo network connection available, skipping package installation"
fi

end_seconds="$(date +%s)"
echo "-----------------------------"
echo "Provisioning complete in "$(expr $end_seconds - $start_seconds)" seconds"
if [[ $ping_result == "Connected" ]]; then
	echo "External network connection established, packages up to date."
else
	echo "No external network available. Package installation and maintenance skipped."
fi
