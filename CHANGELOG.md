##2015-11-25 - 7.0.0
###Summary

This is a backwards-compatible major release for OpenStack Liberty.

####Features
- keystone/auth: make service description configurable
- add tag to package and service resources
- add tuskar::config class
- reflect provider change in puppet-openstacklib
- put all the logging related parameters to the logging class
- introduce tuskar::db class
- switch Tuskar to $::os_service_default
- db: use postgresql lib class for psycopg package

####Bugfixes
- rely on autorequire for config resource ordering

####Maintenance
- initial msync run for all Puppet OpenStack modules
- try to use zuul-cloner to prepare fixtures
- remove class_parameter_defaults puppet-lint check
- fix rspec 3.x syntax

##2015-07-08 - 6.0.0
###Summary

- Initial release of the puppet-tuskar module
