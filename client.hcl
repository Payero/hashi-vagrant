# Increase log verbosity
log_level = "DEBUG"

#bind_addr = "10.215.34.53"


# Setup data dir
data_dir = "/tmp/client1"

# Give the agent a unique name. Defaults to hostname
#name = "client1"

# Enable the client
client {
    enabled = true
    network_interface = "eth1"

    # For demo assume we are talking to server1. For production,
    # this should be like "nomad.service.consul:4647" and a system
    # like Consul used for service discovery.
    servers = ["server"]
}

advertise {
        http = "{{ GetInterfaceIP `eth1` }}"
        rpc = "{{ GetInterfaceIP `eth1` }}"
        serf = "{{ GetInterfaceIP `eth1` }}"
}

ports {
  http = 4646
  rpc  = 4647
}


