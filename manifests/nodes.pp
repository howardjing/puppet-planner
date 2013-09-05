
node 'puppetmaster' {
	include git
}

node 'puppetclient' {
  $application_name = 'planner'

  # nodejs for a javascript runtime for rails
  include nodejs

  # mongodb
  include mongodb

  # install rbenv + set up capistrano
  rails::application { $application_name:
    user => 'deployer',
    ruby => '2.0.0-p247'
  }

  # some variables for nginx
  $nginx_root = "/var/www/${application_name}/current/public"
  $server_name = 'staging.planner.dev'
  $rails_port = '3000'  
  
  # nginx for serving web stuff
  class { 'nginx': }
  nginx::resource::vhost { $server_name:
    ensure              => present,
    location_custom_cfg => {
      root       => $nginx_root,
      try_files  => '$uri/index.html $uri @unicorn'
    },
    vhost_cfg_append    => {
      error_page => '500 502 503 504 /500.html'
    }
  }
  
  nginx::resource::upstream { 'unicorn':
    ensure  => present,
    members => ["unix:/tmp/unicorn.${application_name}.sock fail_timeout=0"]
  }

  nginx::resource::location { "${server_name}-rails":
    vhost => $server_name,
    location => '@unicorn',
    location_custom_cfg => {
      proxy_set_header  => ['X-Forwarded-For $proxy_add_x_forwarded_for', 'Host $http_host'],
      proxy_redirect    => 'off',
      proxy_pass        => "http://unicorn"
    }
  }
  
  nginx::resource::location { "${server_name}-assets":
    vhost    => $server_name,
    location => '^~ /assets/',
    location_custom_cfg => {
      root        => $nginx_root,
      gzip_static => 'on',
      expires     => 'max',
      add_header  => 'Cache-Control public',
    }
  }
  

}
