
node 'puppetmaster' {
	include git
}

node 'puppetclient' {

  # nodejs for a javascript runtime for rails
  include nodejs

  # install rbenv + set up capistrano
  rails::application { 'planner':
    user => 'deployer',
    ruby => '2.0.0-p247'
  }

  # nginx for serving web stuff
  class { 'nginx': }
  nginx::resource::vhost { 'staging.planner.dev':
    ensure      => present,
    try_files   => ['$uri', '@unicorn'],
    location    => '@unicorn',
    proxy       => 'http://staging.planner.dev:3000',
  }
}
