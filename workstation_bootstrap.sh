#!/bin/bash
# vim: ts=2 et sw=2 autoindent
# Description: This script will install ruby, facter and puppet on the 
# target machine. The target should be your home directory, and will not
# effect system packages.
#             
#                
#-------------------------------------------------------------------
# Global Vars
#-------------------------------------------------------------------
scriptname=$(basename $0)
REQUIRED_RUBY_VERSION=2.1.6
REQUIRED_FACTER_VERSION=2.4.4
REQUIRED_PUPPET_VERSION=3.4.3
REQUIRED_RUBY_GEMS=(
"facter -v ${REQUIRED_FACTER_VERSION}"
"puppet -v ${REQUIRED_PUPPET_VERSION}"
"puppet-lint"
"librarian-puppet"
"puppetlabs_spec_helper"
"beaker"
"beaker-rspec"
)
#-------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------

bootstrap() {
  check_pre_requisites
  echo "[INFO]: Installing Docker"
  install_docker
}

check_pre_requisites() {
  echo "[INFO]: Checking for installed pre-requisites..."

  echo "[INFO]: Checking for curl"
  which curl > /dev/null 
  if [ ${?} -ne 0 ]; then
    echo "[INFO]: Curl is NOT installed. Install Curl"
    echo "[ERROR]: redhat: sudo yum install curl -y OR debian: sudo apt-get install curl -y"
    errexit "[ERROR]: Install Curl, and re-run this script."
  else 
    echo "[INFO]: Curl Found. Proceeding with Installation"
    echo "[INFO]: Checking for rvm ruby installation"
    check_ruby
  fi
}

check_ruby() {
  which ruby | grep rvm > /dev/null   
  if [ ${?} -ne 0 ]; then
    echo "[INFO]: rvm ruby installation not found. Proceeding with ruby installation via RVM" 
    install_ruby
  else
    ruby_version=$(ruby --version | awk '{ print $2 }' | cut -c 1-5)
    echo "[INFO]: ruby installation found: ${ruby_version}" 
    if [[ ${ruby_version} == ${REQUIRED_RUBY_VERSION} ]]; then
      echo "[INFO]: ruby version matches required version"
      echo "[INFO]: checking required gems"
      install_ruby_gems
    else
      echo "[INFO]: ruby version does not match required version."
      install_ruby
    fi
  fi
  echo "[INFO]: Installation and bootstrap completed."
}

determine_operating_system() {
  if [ -f /etc/redhat-release ] ; then
    OPERATINGSYSTEM='RedHat'
  elif [ -f /etc/debian_version ] ; then
    OPERATINGSYSTEM='Debian'
  fi
}

install_docker() {
  which docker > /dev/null
  if [ ${?} -ne 0 ]; then 
    echo '[INFO]: Docker not found in $PATH. Installing via get.docker.com'
    curl -sSL https://get.docker.com/ | sh
  else
    echo '[INFO]: Docker Already Installed.'
  fi
}

errexit() {
# Function for exit due to fatal program error
# Accepts 1 arg: string containing descriptive error message
  red='\033[0;31m'
  nocolor='\033[0m' # No Color
  printf "${scriptname}: ${red}${1:-"Unknown Error"}${nocolor}" >&2
  echo ''
  exit 1
}


install_ruby() {
  echo "[INFO]: Installing Ruby ${REQUIRED_RUBY_VERSION} via RVM (Ruby Version Manager http://rvm.io)" 
  curl -sSL https://rvm.io/mpapis.asc | gpg --import -
  echo "[INFO]: Executing installation via command >curl -sSL https://get.rvm.io | bash -s stable --ruby=2.1.6<"
  curl -sSL https://get.rvm.io | bash -s stable --ruby=2.1.6 --gems=bundler
  source $HOME/.rvm/scripts/rvm
  rvm use ${REQUIRED_RUBY_VERSION}
  install_ruby_gems
}

install_ruby_gems() {
  echo "[INFO]: Installating Ruby Gems for Facter, Puppet and Librarian-Puppet"
  for ((i = 0; i < ${#REQUIRED_RUBY_GEMS[@]}; i++))
  do
    gem list ${REQUIRED_RUBY_GEMS[$i]} -i > /dev/null
    if [ ${?} -ne 0 ]; then
      gem install ${REQUIRED_RUBY_GEMS[$i]} --no-ri --no-rdoc
    else
      echo "[INFO]: gem ${REQUIRED_RUBY_GEMS[$i]} found."
    fi
  done
}
 
 
signal_exit() {
  case ${1} in
    INT)
      echo "${scriptname}: Program aborted by user" >&2
      exit;;

    TERM)
      echo "${scriptname}: Program terminated" >&2
      exit;;

    *)
      errexit "${scriptname}: Terminating on unknown signal";;
  esac
}
 
 
usage() {
cat << EOF

  Usage: (shows short and long options for clarity)
  ------
  Bootstraps your workstation with the pre-requisites required to utilize
  the GET Automation team CI for puppet module testing.

  $0 -b
  $0 --bootstrap 

EOF
exit
}
 
 
root_check() {
  if [ "$(id | sed 's/uid=\([0-9]*\).*/\1/')" != "0" ]; then
    errexit "[ERROR]: You must be root to run this script!"
  fi
}
 

# -------------------------------------------------------------------
#  Start Script Execution
# -------------------------------------------------------------------
# Uncomment the below if this script must be ran as _root_ 
# root_check 
 
# Trap TERM, HUP, and INT signals and properly exit
trap "signal_exit TERM" TERM HUP
trap "signal_exit INT"  INT
 
if [ "${1}" = "" ]; then
  usage
  exit
fi
  
OPTIONS=$(getopt -n "$0"  -o hb --long "help,bootstrap"  -- "$@")
 
if [ ${?} -ne 0 ];
then
  exit 1
fi
 
eval set -- "$OPTIONS"
 
while true;
do
  case "${1}" in
 
    -h|--help)
      usage
      shift;;

    -b|--bootstrap)
      BOOTSTRAP=1
      shift;;

    --)
      shift
      break;;
  esac
done

[ ${BOOTSTRAP} -eq 1 ] && bootstrap

exit
