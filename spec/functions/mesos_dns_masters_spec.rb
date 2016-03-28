require 'spec_helper'

describe 'mesos_dns_masters' do
  context 'interface' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params().and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params(nil).and_raise_error(Puppet::ParseError) }
  end

  context 'values' do
    it { is_expected.to run.with_params(['one']).and_return(['one:5050']) }
    it { is_expected.to run.with_params('one').and_return(['one:5050']) }
    it { is_expected.to run.with_params(%w(one two)).and_return(%w(one:5050 two:5050)) }
    it { is_expected.to run.with_params(%w(one two:100), '50').and_return(%w(one:50 two:100)) }
    it { is_expected.to run.with_params([], '50').and_return(nil) }
  end
end
