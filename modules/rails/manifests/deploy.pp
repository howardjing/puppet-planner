# set up the deployer user and group
# set up the deploy_path
# (keep user and deploy_path synced with capistrano)

# Use like:
# rails::deploy { 'planner':
#   user => 'deployer',
# }

define rails::deploy(
  $application = $title,
  $deploy_path = '/var/www',
  $user,
  $group,
) {
  $application_deploy_path = "${deploy_path}/${application}"

  file { $deploy_path:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => 775,
    require => User[$user]
  }

  file { $application_deploy_path:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => 775,
    require => File[$deploy_path]
  }

  file { ["${application_deploy_path}/releases", 
          "${application_deploy_path}/shared", 
          "${application_deploy_path}/shared/pids"]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => 775,
    require => File[$application_deploy_path]
  }

  file { "${application_deploy_path}/shared/log":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => 666,
    require => File["${application_deploy_path}/shared"]
  }

}