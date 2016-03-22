# = Class: skel-standard
#
# This is the main skel-standard class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behavior and customizations
#
# [*extend*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, skel-standard class will automatically "include $extend"
#   Can be defined also by the (top scope) variable $skel-standard_extend
#   Can be defined also by the (class scope) variable $skel-standard::extend
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, skel-standard main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $skel-standard_source
#   Can be defined also by the (class scope) variable  $skel-standard::source
#
# [*source_dir*]
#   If defined, the whole skel-standard configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $skel-standard_source_dir
#   Can be defined also by the (class scope) variable $skel-standard::source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $skel-standard_source_dir_purge
#   Can be defined also by the (class scope) variable $skel-standard::source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, skel-standard main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $skel-standard_template
#   Can be defined also by the (class scope) variable  $skel-standard::template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $skel-standard_options
#   Can be defined also by the (class scope) variable  $skel-standard::options
#
# [*service_autorestart*]
#   Automatically restarts the skel-standard service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#   Can be defined also by the (class scope) variable $skel-standard::service_autorestart
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#   Can be defined also by the (class scope) variable $skel-standard::version
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $skel-standard_absent
#   Can be defined also by the (class scope) variable $skel-standard::absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $skel-standard_disable
#   Can be defined also by the (class scope) variable $skel-standard::disablw
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $skel-standard_disableboot
#   Can be defined also by the (class scope) variable $skel-standard::disableboot
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $skel-standard_audit_only
#   and $audit_only
#   Can be defined also by the (class scope) variable $skel-standard::audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#   Can be defined also by the (class scope) variable $skel-standard::noops
#
# Default class parameters - As defined in class skel-standard::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via *top* scope variables.
#
# [*package*]
#   The name of skel-standard package
#   Can be defined also by the (class scope) variable $skel-standard::package
#
# [*service*]
#   The name of skel-standard service
#   Can be defined also by the (class scope) variable $skel-standard::service
#
# [*service_status*]
#   If the skel-standard service init script supports status argument
#   Can be defined also by the (class scope) variable $skel-standard::service_status
#
# [*config_file*]
#   Main configuration file path
#   Can be defined also by the (class scope) variable $skel-standard::config_file
#
# [*config_file_mode*]
#   Main configuration file path mode
#   Can be defined also by the (class scope) variable $skel-standard::config_file_mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#   Can be defined also by the (class scope) variable $skel-standard::config_file_owner
#
# [*config_file_group*]
#   Main configuration file path group
#   Can be defined also by the (class scope) variable $skel-standard::config_file_group
#
# See README for usage patterns.
#
class skel-standard (
  $noops                     = $skel-standard::params::noops,
  $extend                    = $skel-standard::params::extend,
  $absent                    = $skel-standard::params::absent,
  $audit_only                = $skel-standard::params::audit_only,
  $package                   = $skel-standard::params::package,
  $version                   = $skel-standard::params::version,
  $config_file               = $skel-standard::params::config_file,
  $config_file_mode          = $skel-standard::params::config_file_mode,
  $config_file_owner         = $skel-standard::params::config_file_owner,
  $config_file_group         = $skel-standard::params::config_file_group,
  $source                    = $skel-standard::params::source,
  $source_dir                = $skel-standard::params::source_dir,
  $source_dir_purge          = $skel-standard::params::source_dir_purge,
  $template                  = $skel-standard::params::template,
  $content                   = $skel-standard::params::content,
  $options                   = $skel-standard::params::options,
  $service                   = $skel-standard::params::service,
  $service_status            = $skel-standard::params::service_status,
  $service_autorestart       = $skel-standard::params::service_autorestart,
  $disable                   = $skel-standard::params::disable,
  $disableboot               = $skel-standard::params::disableboot,
  ) inherits skel-standard::params {

  ### Warn if Operating System is *NOT* supported by this module.
  if $skel-standard::params::supported_os == true {

    ### Validation of Parameters
    validate_absolute_path($skel-standard::config_dir)
    validate_absolute_path($skel-standard::config_file)
    validate_string($skel-standard::config_file_owner)
    validate_string($skel-standard::config_file_group)
    validate_string($skel-standard::config_file_mode)
    if $options { validate_hash($skel-standard::options) }

    # Sanitize Booleans
    $bool_source_dir_purge    = any2bool($skel-standard::source_dir_purge)
    $bool_service_autorestart = any2bool($skel-standard::service_autorestart)
    $bool_absent              = any2bool($skel-standard::absent)
    $bool_disable             = any2bool($skel-standard::disable)
    $bool_disableboot         = any2bool($skel-standard::disableboot)
    $bool_audit_only          = any2bool($skel-standard::audit_only)
    $bool_noops               = any2bool($skel-standard::noops)

    ### Definition of Managed Resource Parameters ( These are set based off the class parameter input )
    $manage_package = $skel-standard::bool_absent ? {
      true  => 'absent',
      false => $skel-standard::version,
    }

    $manage_config_file_content = default_content($skel-standard::content, $skel-standard::template)

    $manage_config_file_source  = $skel-standard::source ? {
      ''      => undef,
      default => is_array($skel-standard::source) ? {
        false   => split($skel-standard::source, ','),
        default => $skel-standard::source,
      }
    }

    $manage_service_enable = $skel-standard::bool_disableboot ? {
      true    => false,
      default => $skel-standard::bool_disable ? {
        true    => false,
        default => $skel-standard::bool_absent ? {
          true  => false,
          false => true,
        },
      },
    }

    $manage_service_ensure = $skel-standard::bool_disable ? {
      true    => 'stopped',
      default =>  $skel-standard::bool_absent ? {
        true    => 'stopped',
        default => 'running',
      },
    }

    $manage_service_autorestart = $skel-standard::bool_service_autorestart ? {
      true    => Service[skel-standard],
      false   => undef,
    }

    $manage_file = $skel-standard::bool_absent ? {
      true    => 'absent',
      default => 'present',
    }

    $manage_audit = $skel-standard::bool_audit_only ? {
      true  => 'all',
      false => undef,
    }

    $manage_file_replace = $skel-standard::bool_audit_only ? {
      true  => false,
      false => true,
    }


    ### Managed Resources
    package { 'skel-standard.package':
      ensure => $skel-standard::manage_package,
      name   => $skel-standard::package,
      noop   => $skel-standard::bool_noops,
    }

    file { 'skel-standard.conf':
      ensure  => $skel-standard::manage_file,
      path    => $skel-standard::config_file,
      mode    => $skel-standard::config_file_mode,
      owner   => $skel-standard::config_file_owner,
      group   => $skel-standard::config_file_group,
      require => Package['skel-standard.package'],
      notify  => $skel-standard::manage_service_autorestart,
      source  => $skel-standard::manage_config_file_source,
      content => $skel-standard::manage_config_file_content,
      replace => $skel-standard::manage_file_replace,
      audit   => $skel-standard::manage_audit,
      noop    => $skel-standard::bool_noops,
    }

    service { 'skel-standard':
      ensure    => $skel-standard::manage_service_ensure,
      name      => $skel-standard::service,
      enable    => $skel-standard::manage_service_enable,
      hasstatus => $skel-standard::service_status,
      require   => File['skel-standard.conf'],
      noop      => $skel-standard::bool_noops,
    }

    # The whole skel-standard configuration directory can be recursively overriden by a source directory
    if $skel-standard::source_dir {
      file { 'skel-standard.dir':
        ensure  => directory,
        path    => $skel-standard::config_dir,
        require => Package['skel-standard.package'],
        notify  => $skel-standard::manage_service_autorestart,
        source  => $skel-standard::source_dir,
        recurse => true,
        purge   => $skel-standard::bool_source_dir_purge,
        force   => $skel-standard::bool_source_dir_purge,
        replace => $skel-standard::manage_file_replace,
        audit   => $skel-standard::manage_audit,
        noop    => $skel-standard::bool_noops,
      }
    }

    ### Include custom class if $extend is set
    if $skel-standard::extend {
      include $skel-standard::extend
    }

  } else {
    notice("INFO: ${::operatingsystem} is _NOT_ supported. Contact module maintainer for support.")
    notify{"INFO: ${::operatingsystem} is _NOT_ supported. Contact module maintainer for support.":}
  }



}

# vim: ts=2 et sw=2 autoindent
