
node 'puppetmaster' {
	include git
}

node 'puppetclient' {
	include git
  rails::deploy { 'planner':
    
  }
}
