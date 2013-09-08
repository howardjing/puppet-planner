node 'puppetmaster' {
	include git
}

node 'puppetclient' {
  class { 'planner':
    server_name       => 'staging.planner.dev',
    rails_environment => 'staging'
  }  

  # temporarily have default site just return a 404
  nginx::resource::vhost { '_':
    location_custom_cfg => {
      return       => '404'
    }
  }
}

node 'hjing' {
  class { 'planner':
    server_name       => 'planner.hjing.me', 
    rails_environment => 'production'
  }  

  # temporarily have default site just return a 404
  nginx::resource::vhost { '_':
    location_custom_cfg => {
      return       => '404'
    }
  }
}