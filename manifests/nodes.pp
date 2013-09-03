
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
}
