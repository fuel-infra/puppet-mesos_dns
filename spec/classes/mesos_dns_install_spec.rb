require 'spec_helper'

describe 'mesos_dns::install', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let(:facts) { facts }

      context 'with default parameters' do

        it { is_expected.to compile.with_all_deps }

        package_parameters = {
            :ensure => 'present',
            :name => 'mesos-dns',
        }

        it { is_expected.to contain_package('mesos-dns').with(package_parameters) }

      end

      context 'with custom parameters' do

        let(:params) do
          {
              :package_manage => true,
              :package_name => 'my-mesos-dns',
              :package_ensure => 'latest',
              :package_provider => 'pip',
          }
        end

        it { is_expected.to compile.with_all_deps }

        package_parameters = {
            :ensure => 'latest',
            :name => 'my-mesos-dns',
            :provider => 'pip',
        }

        it { is_expected.to contain_package('mesos-dns').with(package_parameters) }

      end

      context 'when package_manage is disables' do
        let(:params) do
          {
              :package_manage => false,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.not_to contain_package('mesos-dns') }
      end

    end
  end
end
