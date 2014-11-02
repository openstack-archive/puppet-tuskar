#
# Unit tests for tuskar::api
#
require 'spec_helper'

describe 'tuskar::api' do

  let :params do
    { :keystone_password     => 'passw0rd',
      :keystone_user         => 'tuskar',
      :identity_uri          => 'https://identity.os.net:5000',
      :keystone_tenant       => '_services_',
    }
  end

  shared_examples 'tuskar-api' do

    context 'with default parameters' do

      it 'installs tuskar-api package and service' do
        should contain_service('tuskar-api').with(
          :name      => platform_params[:api_service_name],
          :ensure    => 'running',
          :hasstatus => true,
          :enable    => true
        )
        should contain_package('tuskar-api').with(
          :name   => platform_params[:api_package_name],
          :ensure => 'present',
          :notify => 'Service[tuskar-api]'
        )
      end

      it 'configures tuskar-api with default parameters' do
        should contain_tuskar_config('DEFAULT/verbose').with_value(false)
        should contain_tuskar_config('DEFAULT/debug').with_value(false)
        should contain_tuskar_config('DEFAULT/tuskar_api_bind_ip').with_value('0.0.0.0')
        should contain_tuskar_config('DEFAULT/tuskar_api_port').with_value('8585')
        should contain_tuskar_config('keystone_authtoken/identity_uri').with_value(params[:identity_uri])
        should contain_tuskar_config('keystone_authtoken/admin_tenant_name').with_value(params[:keystone_tenant])
        should contain_tuskar_config('keystone_authtoken/admin_user').with_value(params[:keystone_user])
        should contain_tuskar_config('keystone_authtoken/admin_password').with_value(params[:keystone_password])
        should contain_tuskar_config('keystone_authtoken/admin_password').with_value(params[:keystone_password]).with_secret(true)
      end

      context 'when using MySQL' do
        let :pre_condition do
          "class { 'tuskar':
             database_connection   => 'mysql://tuskar:pass@10.0.0.1/tuskar'}"
        end
        it 'configures tuskar-api with RabbitMQ' do
          should contain_tuskar_config('database/sql_connection').with_value('mysql://tuskar:pass@10.0.0.1/tuskar')
          should contain_tuskar_config('database/sql_connection').with_value('mysql://tuskar:pass@10.0.0.1/tuskar').with_secret(true)
        end
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      {
        :osfamily       => 'Debian'
      }
    end

    let :platform_params do
      { :api_package_name => 'tuskar-api',
        :api_service_name => 'tuskar-api' }
    end

    it_configures 'tuskar-api'
  end

  context 'on RedHat platforms' do
    let :facts do
      {
        :osfamily       => 'RedHat'
      }
    end

    let :platform_params do
      { :api_package_name => 'openstack-tuskar-api',
        :api_service_name => 'openstack-tuskar-api' }
    end

    it_configures 'tuskar-api'
  end

end
