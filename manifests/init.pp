#
# freepuppet moduled used to install the basics of a masterless puppet configuration.
# @author jonty.bale@dwp.gsi.gov.uk
#
class freepuppet
{
    # ensure the run script is in place
    file { '/usr/local/bin/freepuppet-run':
        ensure => present,
        source => 'puppet:///modules/freepuppet/cron/run.sh'
    }
    # ensure the update script is in place
    file { '/usr/local/bin/freepuppet-update':
        ensure  => present,
        source  => 'puppet:///modules/freepuppet/cron/update.sh',
        require => File['/usr/local/bin/freepuppet-run']
    }

    # ensure we have a cron in place which runs every 15min
    cron { 'freepuppet-run':
        ensure  => absent,
        command => '/usr/local/bin/freepuppet-run',
        minute  => '*/15',
        require => File["/usr/local/bin/freepuppet-run"]
    }

    # ensure we have a cron in place which runs every 15min
    cron { 'freepuppet-update':
        ensure  => present,
        command => '/usr/local/bin/freepuppet-update',
        minute  => '*/15',
        require => File["/usr/local/bin/freepuppet-update"]
    }
    
    # install call to run freepuppet on startup.
    file { '/etc/init/freepuppet.conf':
        ensure  => present,
        source  => 'puppet:///modules/freepuppet/upstart.conf',
        require => File["/usr/local/bin/freepuppet-run"]
    }   
}