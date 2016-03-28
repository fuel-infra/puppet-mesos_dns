module Puppet::Parser::Functions
  newfunction(
      :mesos_dns_masters,
      :type => :rvalue,
      :arity => -2,
      :doc => 'Combine a list of Mesos master servers and ports to an array'
  ) do |args|
    servers = args[0]
    port = args[1] || 5050

    raise Puppet::ParseError, 'mesos_dns_masters() You should provide arguments: server list!' unless servers
    servers = [servers] unless servers.is_a? Array
    break nil unless servers.any?
    servers.map do |server|
      next server if server.include? ':'
      "#{server}:#{port}"
    end
  end
end
