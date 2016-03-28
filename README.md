# mesos_dns Puppet module

This module can install mesos_dns package, configure startup scripts,
install the config file and run the Mesos DNS service.

## Sample Usage

Without parameters:

```puppet
class { 'mesos_dns_' :}
```

With parameters:

```puppet
class { 'mesos_dns_' :
  zk_servers      => ['node1','node2'],
  mesos_masters   => ['node1','node2'],
  startup_manage  => false,
  domain          => 'my-cluster.local',
}
```

Using the Hiera YAML file:

```yaml
mesos_dns::zk_servers:
- node1
- node2
mesos_dns::mesos_masters:
- node1
- node2
mesos_dns::startup_manage: false
mesos_dns::domain: 'my-cluster.local'
```

## Parameters

### `package_manage`

Should the module try to install a mesos-dns package?
Default: true

### `package_name`

The real name of the mesos-dns package.
Default: mesos-dns

### `package_version`

The version of mesos-dns package to install.
Default: present

### `service_manage`

Should the module try to work with mesos-dns service?
Default: true

### `service_enable`

Should the the module enable and run or disable and stop the service?
Default: true

### `service_name`

The name of the service to manage.
Default: mesos-dns

### `service_provider`

Override the service provider if you have reasons to do so.
Default: undef

### `startup_manage`

Should the module try to install init/upstart scripts for the service?
Default: true

### `zk_servers`

The list of Zookeeper servers used by Mesos DNS.
An empty array will disable this option.
Default: ['localhost']

### `zk_mesos_path`

The Zookeeper path used by Mesos.
Default: mesos

### `zk_default_port`

The default Zookeeper port to use if the server is given without
a port like "ip:port"
Default: 2181

### `mesos_masters`

The list of Mesos master servers.
Optionally with ports like this: "host:port"
If no port is provided the default port will be used.
An empty array will disable this option.
Default: ['localhost']

### `mesos_port`

The default port to use with the list of Mesos master servers.
Default: 5050

### `config_dir_path`

The path to the Mesos DNS config directory.
Default: /etc/mesos-dns

### `config_file_path`

The path to the main Mesos DNS config file.
Default: ${config_dir_path}/config.json

### `config_file_path`

The path to the mesos-dns binary file installed by package or
using any other means. Will be used to make the startup scripts.
Default: /usr/bin/mesos-dns

## Options

These options will be placed to the Mesos DNS config file.
You can find their full list and description
[here](https://mesosphere.github.io/mesos-dns/docs/configuration-parameters.html).
The following options descriptions are taken from this site.

### `zk_detection_timeout`

Defines how long to wait (in seconds) for Zookeeper to report
a new leading Mesos master.
Defaults to 30 seconds.

### `refresh_seconds`

The frequency at which Mesos-DNS updates DNS records based on
information retrieved from the Mesos master.
The default value is 60 seconds.

### `ttl`

The time to live value for DNS records served by Mesos-DNS, in seconds.
It allows caching of the DNS record for a period of time in order to
reduce DNS request rate. ttl should be equal or
larger than refreshSeconds.
The default value is 60 seconds.

### `domain`

The domain name for the Mesos cluster.
The domain name can use characters [a-z, A-Z, 0-9], - if it is not
the first or last character of a domain portion, and . as a separator
of the textual portions of the domain name. We recommend you avoid
valid top-level domain names.
The default value is mesos.

### `port`

The port number that Mesos-DNS monitors for incoming DNS requests.
Requests can be sent over TCP or UDP. We recommend you use port 53 as
several applications assume that the DNS server listens to this port.
The default value is 53.

### `resolvers`

The list with the IP addresses of external DNS servers that
Mesos-DNS will contact to resolve any DNS requests outside the domain.
We recommend that you list the nameservers specified in the
/etc/resolv.conf on the server Mesos-DNS is running. Alternatively,
you can list 8.8.8.8, which is the Google public DNS address.
Default: ['8.8.8.8', '8.8.4.4']

### `timeout`

The timeout threshold, in seconds, for connections and requests to
external DNS requests.
The default value is 5 seconds.

### `http_on`

A boolean field that controls whether Mesos-DNS listens for
HTTP requests or not.
The default value is true.

### `dns_on`

A boolean field that controls whether Mesos-DNS listens for
DNS requests or not.
The default value is true.

### `http_port`

The port number that Mesos-DNS monitors for incoming HTTP requests.
The default value is 8123.

### `external_on`

A boolean field that controls whether Mesos-DNS serves requests
outside of the Mesos domain.
The default value is true.

### `listener`

The IP address of Mesos-DNS. In SOA replies, Mesos-DNS identifies
hostname mesos-dns.domain as the primary nameserver for the domain.
It uses this IP address in an A record for mesos-dns.domain.
The default value is "0.0.0.0", which instructs Mesos-DNS to create an
A record for every IP address associated with a network interface on
the server that runs the Mesos-DNS process.

### `soa_master_name`

Specifies the domain name of the name server that was the original or
primary source of data for the configured domain.
The configured name will always be converted to a FQDN by ensuring
it ends with a ..
The default value is ns1.mesos.

### `soa_mail_name`

Specifies the mailbox of the person responsible for the configured
domain. The format is mailbox.domain, using a . instead of @.
i.e. root@ns1.mesos becomes root.ns1.mesos. For details, see
the RFC-1035.
The default value is root.ns1.mesos.

### `soa_refresh`

The REFRESH field in the SOA record for the Mesos domain.
For details, see the RFC-1035.
The default value is 60.

### `soa_retry`

The RETRY field in the SOA record for the Mesos domain.
For details, see the RFC-1035.
The default value is 600.

### `soa_expire`

The EXPIRE field in the SOA record for the Mesos domain.
For details, see the RFC-1035.
The default value is 86400.

### `soa_min_ttl`

The minimum TTL field in the SOA record for the Mesos domain.
For details, see the RFC-2308.
The default value is 60.

### `recurse_on`

Controls if the DNS replies for names in the Mesos domain will
indicate that recursion is available.
The default value is true.

### `enforce_rfc952`

Will enforce an older, more strict set of rules for DNS labels.
For details, see the RFC-952.
The default value is false.

### `ip_sources`

Defines a fallback list of IP sources for task records,
sorted by priority. If you use Docker, and enable the netinfo IPSource,
it may cause tasks to become unreachable, because after Mesos 0.25,
the Docker executor publishes the container's internal IP in
NetworkInfo.
The default value is: ["netinfo", "mesos", "host"]

* *host*: Host IP of the Mesos slave where a task is running.
* *mesos*: Mesos containerizer IP. *DEPRECATED*
* *docker*: Docker containerizer IP. *DEPRECATED*
* *netinfo*: Mesos 0.25 NetworkInfo.
