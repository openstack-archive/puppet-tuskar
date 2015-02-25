# == Class: tuskar::db::postgresql
#
# Manage the tuskar postgresql database
#
# === Parameters:
#
# [*password*]
#   (required) Password that will be used for the tuskar db user.
#
# [*dbname*]
#   (optionnal) Name of tuskar database.
#   Defaults to tuskar
#
# [*user*]
#   (optionnal) Name of tuskar user.
#   Defaults to tuskar
#
class tuskar::db::postgresql(
  $password,
  $dbname    = 'tuskar',
  $user      = 'tuskar'
) {

  require postgresql::python

  Class['tuskar::db::postgresql'] -> Service<| title == 'tuskar' |>
  Postgresql::Db[$dbname] ~> Exec<| title == 'tuskar-dbsync' |>
  Package['python-psycopg2'] -> Exec<| title == 'tuskar-dbsync' |>


  postgresql::db { $dbname:
    user     => $user,
    password => $password,
  }

}
