#
# @summary configure an instance of freight
#
# @param varcache
#   The directory from which freight-managed packages are served.
# @param gpg_private_key_content
#   Content of the private GPG key used for signing
# @param gpg_public_key_content
#   Content of the public GPG key used for signing
# @param gpg_key_id
#   The ID of the key GPG to install. For example 'D50582E6'.
# @param gpg_key_email
#   Email address of the package signing key - check with "gpg --list-keys".
# @param gpg_key_passphrase
#   The passphrase of the GPG keypair's private key.
#
define freight::config
(
  Stdlib::AbsolutePath $varcache,
  String               $gpg_private_key_content,
  String               $gpg_public_key_content,
  String               $gpg_key_id,
  String               $gpg_key_email,
  String               $gpg_key_passphrase,
)
{
  include ::freight::params

  ### GPG configuration
  ensure_resource('gnupg_key', "freight-${gpg_key_id}-public-key",  { 'ensure'      => 'present',
                                                                      'user'        => 'root',
                                                                      'key_id'      => $gpg_key_id,
                                                                      'key_content' => $gpg_public_key_content,
                                                                      'key_type'    => 'public' })
  ensure_resource('gnupg_key', "freight-${gpg_key_id}-private-key", { 'ensure'      => 'present',
                                                                      'user'        => 'root',
                                                                      'key_id'      => $gpg_key_id,
                                                                      'key_content' => $gpg_private_key_content,
                                                                      'key_type'    => 'private', })

  $gpg_key_passphrase_line = "GPG_PASSPHRASE_FILE=\"/etc/freight-${title}.pass\""

  # The freight lib directory used for staging the packages
  $varlib = "/var/lib/freight-${title}"

  file {
    default:
      owner => root,
      group => root,
    ;
    ["freight-${title}-varcache-dir"]:
      ensure => directory,
      name   => $varcache,
      mode   => '0755',
    ;
    ["freight-${title}-varlib-dir"]:
      ensure => directory,
      name   => $varlib,
      mode   => '0755',
    ;
    ["freight-${title}.conf"]:
      ensure  => present,
      name    => "/etc/freight-${title}.conf",
      content => template('freight/freight.conf.erb'),
      mode    => '0644',
      require => Class['freight::install'],
    ;
    ["freight-${title}.pass"]:
      ensure  => present,
      name    => "/etc/freight-${title}.pass",
      content => template('freight/freight.pass.erb'),
      mode    => '0600',
      require => Class['freight::install'],
    ;
  }
}
