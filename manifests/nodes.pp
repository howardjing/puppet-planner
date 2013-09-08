
node 'puppetmaster' {
	include git
}

node 'hjing' {
  class { 'planner':
    server_name       => 'planner.hjing.me', 
    rails_environment => 'production'
  }  
}

node 'puppetclient' {
  class { 'planner':
    server_name       => 'staging.planner.dev',
    rails_environment => 'staging'
  }  
}
