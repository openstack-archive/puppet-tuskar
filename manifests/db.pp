# == Class: tuskar::db
#
#  Configure the Neutron database
#
# === Parameters
#
# [*database_connection*]
#   Url used to connect to database.
#   (Optional) Defaults to 'sqlite:////var/lib/tuskar/tuskar.sqlite'.
#
# [*database_idle_timeout*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to $::os_service_default.
#
# [*database_min_pool_size*]
#   Minimum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $::os_service_default.
#
# [*database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $::os_service_default.
#
# [*database_max_retries*]
#   Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to $::os_service_default.
#
# [*database_retry_interval*]
#   Interval between retries of opening a sql connection.
#   (Optional) Defaults to $::os_service_default.
#
# [*database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to $::os_service_default.
#
class tuskar::db (
  $database_connection     = 'sqlite:////var/lib/tuskar/tuskar.sqlite',
  $database_idle_timeout   = $::os_service_default,
  $database_min_pool_size  = $::os_service_default,
  $database_max_pool_size  = $::os_service_default,
  $database_max_retries    = $::os_service_default,
  $database_retry_interval = $::os_service_default,
  $database_max_overflow   = $::os_service_default,
) {

  include ::tuskar::params

  # NOTE(spredzy): In order to keep backward compatibility we rely on the pick function
  # to use tuskar::<myparam> if tuskar::db::<myparam> isn't specified.
  $database_connection_real = pick($::tuskar::database_connection, $database_connection)
  $database_idle_timeout_real = pick($::tuskar::database_idle_timeout, $database_idle_timeout)
  $database_min_pool_size_real = pick($::tuskar::database_min_pool_size, $database_min_pool_size)
  $database_max_pool_size_real = pick($::tuskar::database_max_pool_size, $database_max_pool_size)
  $database_max_retries_real = pick($::tuskar::database_max_retries, $database_max_retries)
  $database_retry_interval_real = pick($::tuskar::database_retry_interval, $database_retry_interval)
  $database_max_overflow_real = pick($::tuskar::database_max_overflow, $database_max_overflow)

  validate_re($database_connection_real,
    '^(sqlite|mysql(\+pymysql)?|postgresql):\/\/(\S+:\S+@\S+\/\S+)?')

  if $database_connection_real {
    case $database_connection_real {
      /^mysql(\+pymysql)?:\/\//: {
        require 'mysql::bindings'
        require 'mysql::bindings::python'
        if $database_connection_real =~ /^mysql\+pymysql/ {
          $backend_package = $::tuskar::params::pymysql_package_name
        } else {
          $backend_package = false
        }
      }
      /^postgresql:\/\//: {
        $backend_package = false
        require 'postgresql::lib::python'
      }
      /^sqlite:\/\//: {
        $backend_package = $::tuskar::params::sqlite_package_name
      }
      default: {
        fail('Unsupported backend configured')
      }
    }

    if $backend_package and !defined(Package[$backend_package]) {
      package {'tuskar-backend-package':
        ensure => present,
        name   => $backend_package,
        tag    => 'openstack',
      }
    }

    tuskar_config {
      'database/connection':     value => $database_connection_real, secret => true;
      'database/idle_timeout':   value => $database_idle_timeout_real;
      'database/min_pool_size':  value => $database_min_pool_size_real;
      'database/max_retries':    value => $database_max_retries_real;
      'database/retry_interval': value => $database_retry_interval_real;
      'database/max_pool_size':  value => $database_max_pool_size_real;
      'database/max_overflow':   value => $database_max_overflow_real;
    }

  }

}
