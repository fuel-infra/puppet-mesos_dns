source 'https://rubygems.org'

group :development, :test do
  gem 'puppetlabs_spec_helper', :require => 'false'
  gem 'rspec-puppet', :require => 'false'
  gem 'pry', :require => 'false'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', '~> 3.8', :require => false
end
