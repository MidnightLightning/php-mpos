# == Class: mysql
#
# Installs MySQL server, sets config file, and loads database for dynamic site.
#
class mysql {
  package { ['mysql-server']:
    ensure => present;
  }

  service { 'mysql':
    ensure  => running,
    require => Package['mysql-server'];
  }

  exec { 'set-mysql-password':
    unless  => 'mysqladmin -uroot -proot status', # If we can already log in as root:root, ignore
    command => "mysqladmin -uroot password root", # Otherwise, set the root user's password to "root"
    path    => ['/bin', '/usr/bin'],
    require => Service['mysql'];
  }
  
  # Init database

  define mysql::loadfile($file, $db = 'mysql') {
    file { "/tmp/${title}":
      source => "${file}";
    }
    
    exec { "load-sql ${title}":
      command => "mysql -u root -proot ${db} < /tmp/${title}",
      path    => ['/bin', '/usr/bin'],
      require => [ File["/tmp/${title}"], Exec['set-mysql-password'] ];
    }
  }
  mysql::loadfile { 'mpos_db-init':
    file => 'puppet:///modules/mysql/mpos_db.sql';
  } ->
  mysql::loadfile { 'base_structure':
    file => '/var/www/sql/000_base_structure.sql',
    db => 'mpos';
  }
}
