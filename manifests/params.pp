# Parameters for puppet-tuskar
#
class tuskar::params {

  case $::osfamily {
    'RedHat': {
      $client_package_name      = 'python-tuskarclient'
      $api_package_name         = 'openstack-tuskar'
      $api_service_name         = 'openstack-tuskar-api'
      $ui_package_name          = 'openstack-tuskar-ui'
      $ui_extras_package_name   = 'openstack-tuskar-ui-extras'
      $sqlite_package_name      = undef
      $pymysql_package_name     = undef
    }
    'Debian': {
      $client_package_name      = 'python-tuskarclient'
      $api_package_name         = 'tuskar-api'
      $api_service_name         = 'tuskar-api'
      $ui_package_name          = 'tuskar-ui'
      $ui_extras_package_name   = 'tuskar-ui-extras'
      $sqlite_package_name      = 'python-pysqlite2'
      $pymysql_package_name     = 'python-pymysql'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
