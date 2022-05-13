# freight

A Puppet module for managing Freight - a tool for creating and maintaining apt 
repositories easily. This module can manage several freight repositories 
residing on the same host.

# Module usage

This module no longer includes automatic webserver configuration as of version 3.0.0. So you
need to ensure that you have a webserver hosting your apt repository. Here's an example based
on puppet/nginx:

    include ::nginx
    
    file { '/var/www':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    
    ::nginx::resource::server { 'apt.example.org':
      autoindex => 'on'
      www_root  => '/var/www',
    }
    
    class { '::freight':
      document_root => '/var/www/debian',
    }
    
    ::freight::config { 'foobar':
      varcache                => '/var/www/debian/foobar',
      gpg_key_id              => 'C42A86B2',
      gpg_key_email           => 'john@example.org',
      gpg_key_passphrase      => 'secret',
      gpg_private_key_content => 'private-key-content',
      gpg_public_key_content  => 'public-key-content',
    }

Multiple repositories can be created by adding more entries of ::freight::config.
