require 'spec_helper'

describe 'tuskar::db' do

  shared_examples 'tuskar::db' do

    context 'with default parameters' do

      it { is_expected.to contain_tuskar_config('database/connection').with_value('sqlite:////var/lib/tuskar/tuskar.sqlite').with_secret(true) }
      it { is_expected.to contain_tuskar_config('database/idle_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_tuskar_config('database/min_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_tuskar_config('database/max_retries').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_tuskar_config('database/retry_interval').with_value('<SERVICE DEFAULT>') }

    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://tuskar:tuskar@localhost/tuskar',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_retry_interval => '11', }
      end

      it { is_expected.to contain_tuskar_config('database/connection').with_value('mysql+pymysql://tuskar:tuskar@localhost/tuskar').with_secret(true) }
      it { is_expected.to contain_tuskar_config('database/idle_timeout').with_value('3601') }
      it { is_expected.to contain_tuskar_config('database/min_pool_size').with_value('2') }
      it { is_expected.to contain_tuskar_config('database/max_retries').with_value('11') }
      it { is_expected.to contain_tuskar_config('database/retry_interval').with_value('11') }
      it { is_expected.to contain_package('tuskar-backend-package').with({ :ensure => 'present', :name => platform_params[:pymysql_package_name] }) }

    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection     => 'mysql://tuskar:tuskar@localhost/tuskar', }
      end

      it { is_expected.to contain_package('python-mysqldb').with(:ensure => 'present') }
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection     => 'postgresql://tuskar:tuskar@localhost/tuskar', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'redis://tuskar:tuskar@localhost/tuskar', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection     => 'foo+pymysql://tuskar:tuskar@localhost/tuskar', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => 'jessie',
      })
    end

    let :platform_params do
      { :pymysql_package_name => 'python-pymysql' }
    end

    it_configures 'tuskar::db'

    context 'with sqlite backend' do
      let :params do
        { :database_connection     => 'sqlite:///var/lib/tuskar/tuskar.sqlite', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('tuskar-backend-package').with(
          :ensure => 'present',
          :name   => 'python-pysqlite2',
          :tag    => 'openstack'
        )
      end

    end
  end

  context 'on Redhat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat',
        :operatingsystemrelease => '7.1',
      })
    end

    let :platform_params do
      { :pymysql_package_name => 'python2-PyMySQL' }
    end

    it_configures 'tuskar::db'
  end

end
