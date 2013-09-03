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