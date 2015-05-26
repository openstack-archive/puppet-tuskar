#
# Copyright (C) 2014 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == class: tuskar::db::sync
#
# DB sync tuskar class
#
# === parameters:
#
#  [*command*]
#    (Optional) Command to run for database synchronization
#    Defaults to 'tuskar-manage db_sync'
#
#  [*path*]
#    (Optional) Default path for the db_sync command
#    Defaults to /usr/bin.
#
#  [*user*]
#    (Optional) User to run the db_sync command with
#    Defaults to 'tuskar'.
#
#  [*refreshonly*]
#    (Optional) Run this command on refresh only
#    Defaults to true.
#
#  [*logoutput*]
#    (Optional) When to log the output
#    Defaults to on_failure.
#
class tuskar::db::sync (
  $command     = 'tuskar-dbsync',
  $path        = '/usr/bin',
  $user        = 'tuskar',
  $refreshonly = true,
  $logoutput   = 'on_failure',
) {

  Package['tuskar-api'] ~> Openstacklib::Db::Sync['tuskar']
  Tuskar_config['database/connection'] ~> Openstacklib::Db::Sync['tuskar']

  openstacklib::db::sync { 'tuskar':
    command     => $command,
    path        => $path,
    user        => $user,
    refreshonly => $refreshonly,
    logoutput   => $logoutput,
  }

}
