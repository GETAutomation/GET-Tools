#!/bin/bash
# vim: ts=2 et sw=2 autoindent
# Description: Module.sh is a set of functions to aid in the development
#              and usage of any get-automation modules. 
#
# Author: Daniel 'ShellFu' Kendrick
# Official Site: http://www.shellfu.com
# E-Mail Address: dk@shellfu.com
#
# LICENSE:
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
#-------------------------------------------------------------------
# Global Vars
#-------------------------------------------------------------------
scriptname=$(basename $0)
TOOLS_DIRECTORY=GET-Tools
CLONE_MODULE=0
VALIDATE_MODULE=0
CLONE_FROM_MODULE=0
#-------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------
check_if_module_exists() {
  [ -f ${NEW_MODULE_NAME}/manifests/init.pp ]
}

check_if_module_type_exists() {
  [ -f ${TOOLS_DIRECTORY}/module-skel/${TYPE_OF_MODULE_TO_CLONE}/manifests/init.pp ]
}

clone_module() {
  validate_module_name
  check_if_module_exists
  if [ $? -eq 0 ]; then 
    errexit "[WARNING]: The module >${NEW_MODULE_NAME}< already exists."
  fi

  DESTINATION=${NEW_MODULE_NAME}

  if [ ${CLONE_FROM_MODULE} -eq 1 ]; then
    SOURCE=${OLD_MODULE_NAME}
    SOURCE_STRING=${OLD_MODULE_NAME}
    clone_module_from_existing_module
  else
    SOURCE=${TOOLS_DIRECTORY}/module-skel/${TYPE_OF_MODULE_TO_CLONE}
    SOURCE_STRING=${TYPE_OF_MODULE_TO_CLONE}
    clone_module_from_type
  fi      

}

clone_module_from_existing_module() {
  check_if_module_exists
  if [ $? -eq 0 ]; then
    echo "[INFO]: The module >${OLD_MODULE_NAME}< exists. Proceeding..."
  else
    errexit "[ERROR]: >${OLD_MODULE_NAME}< doesn't exist or you're running module.sh from an incorrect directory"
  fi
  copy_and_rename_module
}

clone_module_from_type() {
  check_if_module_type_exists
  if [ $? -eq 0 ]; then
    echo "[INFO]: Module skeleton >${TYPE_OF_MODULE_TO_CLONE}< exists. Proceeding..."
  else
    errexit "[ERROR]: >${TYPE_OF_MODULE_TO_CLONE}< doesn't exist or you're running module.sh from an incorrect directory"
  fi
  copy_and_rename_module
}

copy_and_rename_module() {
  echo "[INFO]: Cloning into module >${DESTINATION}<"
  mkdir ${DESTINATION}
  rsync -av --exclude=".git" --exclude "spec/fixtures" ${SOURCE}/ ${DESTINATION} &> /dev/null


  for file in $( find . -name ${DESTINATION} | grep ${SOURCE_STRING} ) ; do
    newfile=`echo $file | sed "s/${SOURCE_STRING}/${DESTINATION}/g"`
    echo "$file => $newfile" ;  mv $file $newfile 
  done

  for file in $( grep -R ${SOURCE_STRING} ${DESTINATION} | cut -d ":" -f 1 | uniq ) ; do
    sed -i "s/${SOURCE_STRING}/${DESTINATION}/g" $file
  done

  cd ${DESTINATION}
  git init
  cd ../

  cp -a ${TOOLS_DIRECTORY}/git-hooks/* ${DESTINATION}/.git/hooks/

  echo "[INFO]: Module >${DESTINATION}< has been cloned from >${SOURCE}<"
  echo "To begin customizing, you may edit >${DESTINATION}/manifests/params.pp<"
  echo "" 
  echo "[ALTERING OR ADDING TESTS]:" 
  echo "[INFO]: Edit tests to reflect params.pp if needed, >${DESTINATION}/spec/acceptance/class_spec.rb<" 
  echo "[INFO]: Also you may need to edit, >${DESTINATION}/spec/classes/*spec.rb<" 
  echo "[INFO]: If you create any defines. Writes tests in, >${DESTINATION}/spec/defines/spec_<define_name>.rb<" 
}

list_module_types() {
  ls ${TOOLS_DIRECTORY}/module-skel
}

validate_module() {
  validate_module_name
  check_if_module_exists

  cd $NEW_MODULE_NAME

  echo "[INFO]: Checking puppet syntax"
  for file in $( find . | grep "\.pp$" ) ; do
      echo "--> $file"
      puppet parser --color false --render-as s validate "$file"
  done

  echo "[INFO]: Checking YAML syntax"
  for file in $( find . | grep "\.yaml$" ) ; do
      echo "--> $file"
      ruby -e "require 'yaml';puts YAML.load_file('${file}')"
  done

  echo "[INFO]: Checking ERB syntax"
  for file in $( find . | grep "\.erb$" ) ; do
      echo "--> $file"
      erb -x -T '-' -P $file
  done

  echo "[INFO]: Executing puppet doc"
  for file in $( find . | grep "\.pp$" ) ; do
      echo "--> $file"
      puppet doc $file
  done

  echo "[INFO]: Executing puppetlint"
  for file in $( find . | grep "\.pp$" ) ; do
      echo "--> $file"
      puppet-lint --no-class_inherits_from_params_class-check --no-80chars-check $file
  done

  echo "[INFO]: Executing rake tasks"
  rake test

}

validate_module_name() {
  if [ "x${NEW_MODULE_NAME}" == "x" ]; then
    echo -n '[INPUT]: Please enter the name of the module to create or validate:'
    read NEW_MODULE_NAME
    validate_module_name
  fi
}

errexit() {
# Function for exit due to fatal program error
# Accepts 1 arg: string containing descriptive error message
  echo "${scriptname}: ${1:-"Unknown Error"}" >&2
  exit 1
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

  This script provides various functions for interacting with module skeletons.
  The provided skeletons aim to conform to the StdMod naming convention, however this is not enforced.

  Run it from puppet modules base dir.

  Usage: (shows short and long options for clarity)
  ------
  Creates a new module named mymodule cloned from provided skeleton standard
  $0 -c -n mymodule -s standard
  $0 --clone --name mymodule --skel skel-standard

  Creates a new module named mymodule cloned from the existing module snmpd
  $0 -c -n mymodule -m snmpd
  $0 --clone --name mymodule --module snmpd

  Validates the module snmpd against lint and performing any tests that exist.
  $0 -v -n snmpd
  $0 --validate --name snmpd

EOF
echo "Available Module Types:"
list_module_types
echo ""
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
  
OPTIONS=$(getopt -n "$0"  -o hcvn:s:m: --long "help,clone,validate,name:,skel:,module:"  -- "$@")
 
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

    -v|--validate)
      VALIDATE_MODULE=1
      shift;;

    -c|--clone)
      CLONE_MODULE=1
      shift;;

    -n|--name)
      NEW_MODULE_NAME=${2}
      shift 2;;
 
    -s|--skel)
      TYPE_OF_MODULE_TO_CLONE=${2}
      shift 2;;

    -m|--module)
      CLONE_FROM_MODULE=1
      OLD_MODULE_NAME=${2}
      shift 2;;

    --)
      shift
      break;;
  esac
done

[ ${VALIDATE_MODULE} -eq 1 ] && validate_module
[ ${CLONE_MODULE} -eq 1 ] && clone_module

exit
