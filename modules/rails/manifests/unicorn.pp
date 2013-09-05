# rails::unicorn{ "unicorn_${application}":
#   app_root          => "${deploy_path}/${application}/current",
#   rails_environment => 'staging'
# }

# required options: 
#   app_root - the path to the rails app
#   user     - who is starting the unicorn service
# assumes that unicorn pid file is in "${app_root}/tmp/pids/unicorn.pid"
# assumes that unicorn config file is in "${app_root}/config/unicorn.rb"
define rails::unicorn(
  $app_root,
  $user,
  $rails_environment = 'staging',
) {
  $script_name = "unicorn_${name}"

  service { $script_name:
    ensure    => running,
    enable    => true,
    hasstatus => false,
    start     => "/etc/init.d/${script_name} start",
    stop      => "/etc/init.d/${script_name} stop",
    restart   => "/etc/init.d/${script_name} restart",
    require   => [
      File["/etc/init.d/${script_name}"]
    ]
  }

  # the unicorn start up script
  file { "/etc/init.d/${script_name}": 
    owner   => root,
    group   => root,
    mode    => 755,
    content => template("rails/unicorn_init.sh.erb"),
    notify  => Service[$script_name]
  }
}