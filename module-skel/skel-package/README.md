# Puppet module: skel-package

This is a Puppet module for skel-package
It provides only package installation and management

Author:     GET-Automation <GET-SE-L2E-Get-Automation@cable.comcast.com>
Maintainer: GET-Automation <GET-SE-L2E-Get-Automation@cable.comcast.com>

Official site: https://github.comcast.com/GETAutomation/

Official git repository: https://github.comcast.com/GETAutomation/puppet-skel-package

Released under the terms of Apache 2 License.

This module requires the presence of getlib module in your modulepath.


## USAGE - Basic management

* Install skel-package with default settings

        class { 'skel-package': }

* Install a specific version of skel-package package

        class { 'skel-package':
          version => '1.0.1',
        }

* Remove skel-package resources

        class { 'skel-package':
          absent => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'skel-package':
          noops => true
        }

* Automatically include a custom subclass

        class { 'skel-package':
          extend => 'get-automation::extend_myskel-package',
        }


## TESTING
[![Build Status](https://travis-ci.org/get-automation/puppet-skel-package.png?branch=master)](https://travis-ci.org/get-automation/puppet-skel-package)
