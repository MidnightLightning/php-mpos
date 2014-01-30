# == Class: baseconfig
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class baseconfig {
  exec { 'apt-get update': # Ensure repository metadata is up-to-date. Can be commented out after first run to make re-provisioning faster
    command => '/usr/bin/apt-get update';
  }

  host { 'hostmachine':
    ip => '192.168.0.1';
  }
  
  file { '/usr/local/bin/litecoind':
    ensure => link,
    target => "/vagrant/litecoind";
  }
  
  file { '/home/vagrant/litecoin':
    recurse => "true",
    source => "puppet:///modules/baseconfig/litecoin-testnet-box";
  }
}
