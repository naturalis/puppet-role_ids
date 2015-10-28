#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu 14.04 LTS and deploy this module
# Usage:
# wget https://github.com/naturalis/naturalis-suricata/raw/master/files/bootsrap.sh
# bash bootstrap.sh
#
set -e

# Load up the release information
. /etc/lsb-release

REPO_DEB_URL="http://apt.puppetlabs.com/puppetlabs-release-stable.deb"

#--------------------------------------------------------------------
# NO TUNABLES BELOW THIS POINT
#--------------------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if which puppet > /dev/null 2>&1 -a apt-cache policy | grep --quiet apt.puppetlabs.com; then
  echo "Puppet is already installed."
  exit 0
fi

# Do the initial apt-get update
echo "Initial apt-get update..."
apt-get update >/dev/null

# Install git bundler
echo "Installing git, bundler..."
apt-get install -y git bundler zlib1g-dev >/dev/null

# Install the PuppetLabs repo
echo "Configuring PuppetLabs repo..."
repo_deb_path=$(mktemp)
wget --output-document="${repo_deb_path}" "${REPO_DEB_URL}" 2>/dev/null
dpkg -i "${repo_deb_path}" >/dev/null
apt-get update >/dev/null

# Install Puppet
echo "Installing Puppet..."
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install puppet >/dev/null
echo "Puppet installed!"
echo "Cloning repo"
git clone https://github.com/naturalis/role_ids.git
cd role_ids
echo "Installing gems"
bundle install --path vendor/bundle
echo "Preparing modules"
bundle exec rake spec_prep
cp -a spec/fixtures/modules/* /etc/puppet/modules/
echo "Run puppet"
puppet apply -e "class {'role_ids': monitor_interface => "em2"}"
