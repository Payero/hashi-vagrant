# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/tmp/server1"

# OEG Additions
bind_addr = "10.215.34.16"



ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

# End of OEG Additions


# Enable the server
server {
    enabled = true
    

    # Self-elect, should be 3 or 5 for production
    bootstrap_expect = 1
}

