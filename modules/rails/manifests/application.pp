# sets up capistrano
# installs rails dependencies

# Use like:
# rails::application { 'planner':
#   user => 'me'
#   deploy_path => '/var/www' 
# }

define rails::application(
  $application = $title,
  $deploy_path = '/var/www',
  $user = 'deployer',
  $group = $user,
  $user_id = 444,
  $group_id = 444,
  $ruby = '1.9.3-p448',
  $rails_environment = 'staging',
) {

  # === user and group setup start ===
  # the deployer user's group
  group { $group:
    ensure => present,
    gid => $group_id,
  }

  # the deployer user
  user { $user:
    ensure => present,
    uid => $user_id,
    gid => $group,
    system => true,
    managehome => true,
    home => "/home/${user}",
    shell => '/bin/bash',
    require => Group[$group]
  }

  # the deployer user's ssh keys
  file { "/home/${user}/.ssh":
    ensure => directory,
    owner => $user,
    mode => '0700',
    require => User[$user]
  }

  file { "/home/${user}/.ssh/authorized_keys":
    ensure => file,
    owner => $user,
    mode => '0700',
    require => File["/home/${user}/.ssh"]
  }
  # === user and group setup end ===


  # === rails dependencies start ===
  rbenv::install { $user: }
  rbenv::compile { $ruby:
    user => $user
  }
  # === rails dependencies end ===

  # for capistrano
  rails::deploy { $application:
    deploy_path => $deploy_path,
    user => $user,
    group => $group
  }

  # for unicorn
  rails::unicorn { $application:
    app_root          => "${deploy_path}/${application}/current",
    user              => $user,
    rails_environment => $rails_environment
  }

}
