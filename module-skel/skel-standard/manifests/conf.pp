#
# = Define: $skel-standard::conf
#
# With this define you can manage any skel-standard configuration file
#
# == Parameters
#
# [*template*]
#   String. Optional. Default: undef. Alternative to: source, content.
#   Sets the module path of a custom template to use as content of
#   the config file
#   When defined, config file has: content => content($template),
#   Example: template => 'site/skel-standard/my.conf.erb',
#
# [*content*]
#   String. Optional. Default: undef. Alternative to: template, source.
#   Sets directly the value of the file's content parameter
#   When defined, config file has: content => $content,
#   Example: content => "# File manage by Puppet \n",
#
# [*source*]
#   String. Optional. Default: undef. Alternative to: template, content.
#   Sets the value of the file's source parameter
#   When defined, config file has: source => $source,
#   Example: source => 'puppet:///site/skel-standard/my.conf',
#
# [*ensure*]
#   String. Default: present
#   Manages config file presence. Possible values:
#   * 'present' - Create and manages the file.
#   * 'absent' - Remove the file.
#
# [*path*]
#   String. Optional. Default: $config_dir/$title
#   The path of the created config file. If not defined a file
#   name like the  the name of the title a custom template to use as content of configfile
#   If defined, configfile file has: content => content("$template")
#
# [*mode*]
# [*owner*]
# [*group*]
# [*config_file_require*]
# [*replace*]
#   String. Optional. Default: undef
#   All these parameters map directly to the created file attributes.
#   If not defined the module's defaults are used.
#   If defined, config file file has, for example: mode => $mode
#
# [*config_file_notify*]
#   String. Optional. Default: 'class_default'
#   Defines the notify argument of the created file.
#   The default special value implies the same behavior of the main class
#   configuration file. Set to undef to remove any notify, or set
#   the name(s) of the resources to notify
#
# [*options_hash*]
#   Hash. Default undef. Needs: 'template'.
#   An hash of custom options to be used in templates to manage any key pairs of
#   arbitrary settings.
#
define skel-standard::conf (
  $source              = undef,
  $template            = undef,
  $content             = undef,
  $path                = undef,
  $mode                = undef,
  $owner               = undef,
  $group               = undef,
  $config_file_notify  = 'skel-standard_class_default',
  $config_file_require = Package['skel-standard.package'],
  $options_hash        = undef,
  $ensure              = present
) {

  include skel-standard

  ### Parameter Validation and Management
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent the conf file is removed.')
  if $options_hash { validate_hash($options_hash) }
  $manage_content = default_content($content, $template)
  $manage_path    = pickx($path, "${skel-standard::config_dir}/${name}")
  $manage_mode    = pickx($mode, $skel-standard::config_file_mode)
  $manage_owner   = pickx($owner, $skel-standard::config_file_owner)
  $manage_group   = pickx($group, $skel-standard::config_file_group)
  $manage_require = pickx($config_file_require, Package['skel-standard.package'])

  $manage_notify  = $config_file_notify ? {
    'skel-standard_class_default' => $skel-standard::manage_config_file_notify,
    default         => $config_file_notify,
  }


  ### Managed Resources
  file { $name:
    ensure  => $ensure,
    source  => $source,
    content => $manage_content,
    path    => $manage_path,
    mode    => $manage_mode,
    owner   => $manage_owner,
    group   => $manage_group,
    require => $manage_require,
    notify  => $manage_notify,
  }


}

