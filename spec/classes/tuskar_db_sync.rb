require 'spec_helper'

describe 'tuskar::db::sync' do
  describe 'with default params' do
    it { is_expected.to contain_openstacklib__db__sync('tuskar').with(
      :command     => 'tuskar-dbsync',
      :path        => '/usr/bin/',
      :user        => 'tuskar',
      :refreshonly => 'true',
      :logoutput   => 'on_failure',
    )}
  end

  describe "overriding default params" do
    let :params do
      {
        :command     => 'foo db_sync',
        :path        => '/usr/local/bin/tuskar',
        :user        => 'tuskar_new',
        :refreshonly => 'false',
        :logoutput   => 'true',
      }
    end

    it { is_expected.to contain_openstacklib__db__sync('tuskar').with(
      :command     => 'foo db_sync',
      :path        => '/usr/local/bin/tuskar',
      :user        => 'tuskar_new',
      :refreshonly => 'false',
      :logoutput   => 'true',
    )}

  end

end
