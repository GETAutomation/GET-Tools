# Puppet module: skel-minimal

This is a Puppet module for skel-minimal
It provides only package installation and file configuration.

Author:     GET-Automation <GET-SE-L2E-Get-Automation@cable.comcast.com>
Maintainer: GET-Automation <GET-SE-L2E-Get-Automation@cable.comcast.com>

Official site: https://github.comcast.com/GETAutomation/

Official git repository: https://github.comcast.com/GETAutomation/puppet-skel-minimal

Released under the terms of Apache 2 License.

This module requires the presence of getlib module in your modulepath.


## USAGE - Basic management

* Install skel-minimal with default settings

        class { 'skel-minimal': }

* Install a specific version of skel-minimal package

        class { 'skel-minimal':
          version => '1.0.1',
        }

* Remove skel-minimal resources

        class { 'skel-minimal':
          absent => true
        }

* Enable auditing without without making changes on existing skel-minimal configuration *files*

        class { 'skel-minimal':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'skel-minimal':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'skel-minimal':
          source => [ "puppet:///modules/get-automation/skel-minimal/skel-minimal.conf-${hostname}" , "puppet:///modules/get-automation/skel-minimal/skel-minimal.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'skel-minimal':
          source_dir       => 'puppet:///modules/get-automation/skel-minimal/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'skel-minimal':
          template => 'get-automation/skel-minimal/skel-minimal.conf.erb',
        }

* Automatically include a custom subclass

        class { 'skel-minimal':
          extend => 'get-automation::my_skel-minimal',
        }



## TESTING
[![Build Status](https://travis-ci.org/get-automation/puppet-skel-minimal.png?branch=master)](https://travis-ci.org/get-automation/puppet-skel-minimal)
