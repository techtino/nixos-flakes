{ inputs, config, pkgs, ... }:
{
  # always allow traffic from your Tailscale network
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # allow the Tailscale UDP port through the firewall
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  # Tailscale keys
  # Create a secrets location for your tailscale auth keys.  Create a reusable key at
  # https://login.tailscale.com/admin/settings/authkeys, save it in a file, and put that file in your secrets location
  # If you're running an "Erase Your Darlings" setup, don't forget to persist your tailscale secrets location  
  environment.etc."tailscale".source = "/etc/tailscale/";
  
  # Tailscale autu-auth config, based on:
  # https://tailscale.com/blog/nixos-minecraft/
  services.tailscale.enable = true;

  # create a systemd oneshot job to authenticate to Tailscale on startup
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''

      # wait for tailscaled to settle
      echo "Waiting for tailscale.service start completion ..." 
      sleep 5
      # (as of tailscale 1.4 this should no longer be necessary, but I find it still is)

      # check if already authenticated
      echo "Checking if already authenticated to Tailscale ..."
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then  # do nothing
      	echo "Already authenticated to Tailscale, exiting."
        exit 0
      fi

      # otherwise authenticate with tailscale
      echo "Authenticating with Tailscale ..."
      ${tailscale}/bin/tailscale up --auth-key file:/etc/tailscale/tskey-reusable
    '';
  };
}
