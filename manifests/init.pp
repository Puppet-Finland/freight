#
# @summary manage freight (apt) repositories.
#
# @param manage
#   Whether to manage freight with Puppet or not. Valid values are true 
#   (default) and false.
# @param allow_address_ipv4
#   IPv4 addresses/networks from which to allow connections. This parameter can
#   be either a string or an array. Defaults to 'anyv4' which means that access
#   is allowed from any IPv4 address. Uses the webserver module to do the hard
#   lifting. This parameter has no effect if $manage_webserver is false.
# @param allow_address_ipv6
#   As above but for IPv6 addresses. Defaults to 'anyv6', thus allowing access 
#   from any IPv6 address. This parameter has no effect if $manage_webserver is 
#   false.
# @param document_root
#   The document root for the webserver. This parameter is ignored unless you've 
#   set $manage_webserver to true. Defaults to '/var/www'.
# @param configs
#   A hash of freight::config resources to realize. You need to define at least 
#   one.
#
class freight
(
  Boolean               $manage = true,
  Optional[String]      $allow_address_ipv4 = 'anyv4',
  Optional[String]      $allow_address_ipv6 = 'anyv6',
  Stdlib::AbsolutePath  $document_root = '/var/www',
  Hash                  $configs = {}
)
{

  if $manage {
    include ::freight::aptrepo
    include ::freight::install

    # Create one or more freight instances. While an overkill for a single 
    # repository, this is required when hosting several unrelated repositories 
    # on the same host.
    create_resources('freight::config', $configs)
  }
}
