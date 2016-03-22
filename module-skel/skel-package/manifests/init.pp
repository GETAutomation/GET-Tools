# = Class: skel-package
#
# This is the main skel-package class: Providing only package installation and management
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behavior and customizations
#
# [*extend*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, skel-package class will automatically "include $extend"
#
#   Note: Can be defined also by the (top scope) variable $skel-package_extend
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $skel-package_absent
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#
# Default class params - As defined in skel-package::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
#
# *Note* also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of skel-package package
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top / class scope level in an ENC (Automaton, Foreman etc..))
#   and "include skel-package".
# - Call skel-package as a parametrized class
#
# See README for details.
#
#
class skel-package (
  $noops               = $skel-package::params::noops,
  $extend              = $skel-package::params::extend,
  $absent              = $skel-package::params::absent,
  $package             = $skel-package::params::package
  $version             = $skel-package::params::version,
) inherits skel-package::params {

  # Notify if Operating System is NOT supported by this module.
  if $skel-package::params::supported_os == true {

    ### Validation of Input Parameters
    $bool_absent = any2bool($skel-package::absent)
    $bool_noops  = any2bool($skel-package::noops)

    ### Definition of Variables used in this Module
    $managed_package = $skel-package::bool_absent ? {
      true  => 'absent',
      false => $skel-package::version,
    }

    ### Resources Managed by this Module
    # - Package Resource
    if ! defined(Package[$skel-package::package]) {
      package { 'skel-package.package':
        ensure  => $skel-package::managed_package,
        name    => $skel-package::package,
        noop    => $skel-package::bool_noops,
      }
    }

    ### Extra Classes to Include
    # - Include custom class if $extend is set
    if $skel-package::extend {
      include $skel-package::extend
    }
  } else {
    notice("INFO: ${::operatingsystem} is _NOT_ supported. Contact module maintainer for support.")
    notify{"INFO: ${::operatingsystem} is _NOT_ supported. Contact module maintainer for support.":}
  }


}

# vim: ts=2 et sw=2 autoindent
