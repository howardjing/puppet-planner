
node 'puppetmaster' {
	include git
}

node 'puppetclient' {
  rails::application { 'planner':
    user => 'deployer',
    ruby => '2.0.0-p247'
  }
}
