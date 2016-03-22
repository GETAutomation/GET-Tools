# = Class: skel-minimal
#
# This is the main skel-minimal class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behavior and customizations
#
# [*extend*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, skel-minimal class will automatically "include $extend"
#   Can be defined also by the (top scope) variable $skel-minimal_extend
#   Can be defined also by the (class scope) variable $skel-minimal::extend
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, skel-minimal main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $skel-minimal_source
#   Can be defined also by the (class scope) variable $skel-minimal::source
#
# [*source_dir*]
#   If defined, the whole skel-minimal configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $skel-minimal_source_dir
#   Can be defined also by the (class scope) variable $skel-minimal::source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $skel-minimal_source_dir_purge
#   Can be defined also by the (class scope) variable $skel-minimal::source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, skel-minimal main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $skel-minimal_template
#   Can be defined also by the (class scope) variable $skel-minimal::template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $skel-minimal_options
#   Can be defined also by the (class scope) variable $skel-minimal::options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#   Can be defined also by the (class scope) variable $skel-minimal::version
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $skel-minimal_absent
#   Can be defined also by the (class scope) variable $skel-minimal::absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $skel-minimal_audit_only
#   and $audit_only
#   Can be defined also by the (class scope) variable $skel-minimal::audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#   Can be defined also by the (class scope) variable $skel-minimal::noops
#
# Default class params - As defined in skel-minimal::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via *top* scope variables.
#
# [*package*]
#   The name of skel-minimal package
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top/class scope level in an ENC (Automaton, Foreman etc..)) and "include skel-minimal"
# - Call skel-minimal as a parametrized class
#
# See README for details.
#
#
class skel-minimal (
  $noops             = $skel-minimal::params::noops,
  $extend            = $skel-minimal::params::extend,
  $absent            = $skel-minimal::params::absent,
  $package           = $skel-minimal::params::package,
  $version           = $skel-minimal::params::version,
  $config_file       = $skel-minimal::params::config_file,
  $config_file_mode  = $skel-minimal::params::config_file_mode,
  $config_file_owner = $skel-minimal::params::config_file_owner,
  $config_file_group = $skel-minimal::params::config_file_group,
  $source            = $skel-minimal::params::source,
  $source_dir        = $skel-minimal::params::source_dir,
  $source_dir_purge  = $skel-minimal::params::source_dir_purge,
  $template          = $skel-minimal::params::template,
  $content           = $skel-minimal::parmas::content,
  $options           = $skel-minimal::params::options,
  ) inherits skel-minimal::params {

  ### Warn if Operating System is *NOT* supported by this module
  if $skel-minimal::params::supported_os == true {
    ### Validation of Parameters
    validate_absolute_path($config_dir)
    validate_absolute_path($config_file)
    validate_string($config_file_owner)
    validate_string($config_file_group)
    validate_string($config_file_mode)
    if $options { validate_hash($options) }

    # Sanitize Booleans
    $bool_source_dir_purge    = any2bool($skel-minimal::source_dir_purge)
    $bool_absent              = any2bool($skel-minimal::absent)
    $bool_audit_only          = any2bool($skel-minimal::audit_only)
    $bool_noops               = any2bool($skel-minimal::noops)

    ### Definition of Managed Resource Parameters ( These are set based off the class parameter input )
    $manage_package = $skel-minimal::bool_absent ? {
      true  => 'absent',
      false => $skel-minimal::version,
    }

    $manage_file = $skel-minimal::bool_absent ? {
      true    => 'absent',
      default => 'present',
    }

    $manage_config_file_content = default_content($skel-minimal::content, $skel-minimal::template)

    $manage_config_file_source  = $skel-minimal::source ? {
      ''      => undef,
      default => is_array($skel-minimal::source) ? {
        false   => split($skel-minimal::source, ','),
        default => $skel-minimal::source,
      }
    }

    $manage_file_replace = $skel-minimal::bool_audit_only ? {
       true  => false,
       false => true,
    }

    ### Definition of Metaparameters
    $manage_audit = $skel-minimal::bool_audit_only ? {
      true  => 'all',
      false => undef,
    }

    ### Managed resources
    package { 'skel-minimal.package':
      ensure  => $skel-minimal::manage_package,
      name    => $skel-minimal::package,
      noop    => $skel-minimal::bool_noops,
    }

    file { 'skel-minimal.conf':
      ensure  => $skel-minimal::manage_file,
      path    => $skel-minimal::config_file,
      mode    => $skel-minimal::config_file_mode,
      owner   => $skel-minimal::config_file_owner,
      group   => $skel-minimal::config_file_group,
      require => Package['skel-minimal.package'],
      source  => $skel-minimal::manage_config_file_source,
      content => $skel-minimal::manage_config_file_content,
      replace => $skel-minimal::manage_file_replace,
      audit   => $skel-minimal::manage_audit,
      noop    => $skel-minimal::bool_noops,
    }

  # The whole skel-minimal configuration directory can be recursively overriden by a source directory
    if $skel-minimal::source_dir {
      file { 'skel-minimal.dir':
        ensure  => directory,
        path    => $skel-minimal::config_dir,
        require => Package['skel-minimal.package'],
        source  => $skel-minimal::source_dir,
        recurse => true,
        purge   => $skel-minimal::bool_source_dir_purge,
        force   => $skel-minimal::bool_source_dir_purge,
        replace => $skel-minimal::manage_file_replace,
        audit   => $skel-minimal::manage_audit,
        noop    => $skel-minimal::bool_noops,
      }
    }


    ### Include custom class if $extend is set
    if $skel-minimal::extend {
      include $skel-minimal::extend
    }
  } else {
    notice("INFO: ${::operatingsystem} is _NOT_ supported. Contact module maintainer for support.")
    notify{"INFO: ${::operatingsystem} is _NOT_ supported. Contact module maintainer for support.":}
  }

}


# vim: ts=2 et sw=2 autoindent
