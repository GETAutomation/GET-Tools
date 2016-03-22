# Puppet module: skel-standard

This is a Puppet module for skel-standard.

Author:     GET-Automation <GET-SE-L2E-Get-Automation@cable.comcast.com>
Maintainer: GET-Automation <GET-SE-L2E-Get-Automation@cable.comcast.com>

Official site: https://github.comcast.com/GETAutomation/

Official git repository: https://github.comcast.com/GETAutomation/puppet-skel-standard

Released under the terms of Apache 2 License.

This module requires functions provided by the getlib module, as it provides functions used in the skel-standard module.

## USAGE - Basic management

* Install skel-standard with default settings

        class { 'skel-standard': }

* Install a specific version of skel-standard package

        class { 'skel-standard':
          version => '1.0.1',
        }

* Disable skel-standard service.

        class { 'skel-standard':
          disable => true
        }

* Remove skel-standard package

        class { 'skel-standard':
          absent => true
        }

* Enable auditing without without making changes on existing skel-standard configuration *files*

        class { 'skel-standard':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'skel-standard':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'skel-standard':
          source => [ "puppet:///modules/get-automation/skel-standard/skel-standard.conf-${hostname}" , "puppet:///modules/get-automation/skel-standard/skel-standard.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'skel-standard':
          source_dir       => 'puppet:///modules/get-automation/skel-standard/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'skel-standard':
          template => 'get-automation/skel-standard/skel-standard.conf.erb',
        }

* Automatically include a custom subclass

        class { 'skel-standard':
          extend => 'get-automation::my_skel-standard_extension',
        }


## CONTINUOUS TESTING

Travis {<img src="https://travis-ci.org/get-automation/puppet-skel-standard.png?branch=master" alt="Build Status" />}[https://travis-ci.org/get-automation/puppet-skel-standard]
