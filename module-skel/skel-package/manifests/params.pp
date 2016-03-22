# Class: skel-package::params
#
# This class defines default parameters used by the main module class skel-package
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to skel-package class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class skel-package::params {

  # Define what operating systems does this module support.
  # Anything not listed as true will prevent the module from being applied.
  $supported_os = $::operatingsystem ? {
    /(?i:RedHat|OracleLinux|CentOS)/  => true,
    /(?i:Debian|Ubuntu)/              => false,
    default                           => false
  }

  ### Application related parameters ###

  # Package Name 
  $package = $::operatingsystem ? {
    default => 'skel-package',
  }

  # Package Version or simple present
  $version = $::operatingsystem ? {
    default => 'present',
  }

  ### General Settings
  $noops   = false
  $absent  = false
  $extend  = ''

}

# vim: ts=2 et sw=2 autoindent
