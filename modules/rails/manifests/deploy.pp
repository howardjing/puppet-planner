# set up the deployer user and group
# set up the deploy_path
# (keep user and deploy_path synced with capistrano)

# Use like:
# rails::deploy { 'planner':
#   user => 'me'
#   deploy_path => '/var/www' 
# }

define rails::deploy(
  $application = $title,
  $deploy_path = '/var/www',
  $user = 'deployer',
  $user_id = 444,
  $group = 'deployer',
  $group_id = 444
) {
  $application_deploy_path = "${deploy_path}/${application}"

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

  file { $deploy_path:
    ensure => directory,
    owner => $user,
    group => $group,
    mode => '1775',
    require => User[$user]
  }

  file { $application_deploy_path:
    ensure => directory,
    owner => $user,
    group => $group,
    mode => '1775',
    require => File[$deploy_path]
  }

  file { "${application_deploy_path}/releases":
    ensure => directory,
    owner => $user,
    group => $group,
    mode => '1775',
    require => File[$application_deploy_path]
  }
}