# cloudflare-dyndns-updater
Simple script to update A and AAAA records to the current public IP of your server via the Cloudflare API.

# What this script does
1. Automatically gests the current public IPv4 and IPv6 adress of your Server via https://cloudflare.com/cdn-cgi/trace
2. Sets the A and AAAA records for the domains that you specified in the script to the current public IPv4 and IPv6 Adress that we got in the first step.

# Prerequisites
- To configure this script, edit the variables in the "Config" section. Variables:
	- domain_names
		+ This is a newline separated list of subdomains that you want to update. They have to belong to the same zone, i.e. be either the domain name itself or a subdomain.
		+ All A and AAAA records you want to update via this script have to already exist.
			* To create them, go to “Websites" -> Select your Domain -> expand the "DNS" entry on the left side -> "Records" -> "Add record"
	- zone_id
		+ The Zone ID of your Domain
		+ You get it via “Websites" -> Select your Domain -> The ID is written on the right side under the "API" headline.
	- api_token
		+ This token gives the script the access to update the DNS records of the Domain.
		+ To get one, go here: Top right (whre you can also log out) -> "My Profile" -> "API Tokens" -> "Create Token" -> "Edit zone DNS" -> Under "Zone Resources" select your Domain in the last column. -> "Continue to summary" -> Create Token -> Now copy the token and add it to the script.

# Installing
You can run this script as a normal user by just executing it. If you want it to run automatically, I suggest this setup:
* Copy the `ddns.sh` script to the `/opt` folder
	- `sudo cp ddns.sh /opt`
* Set the owner to root and make it only readable for root (so that other users can't steal your API Token)
	- `sudo chown root:root /opt/ddns.sh`
	- `sudo chmod 700 /opt/ddns.sh`
* Copy the content of the "systemd" folder to `/etc/systemd/system`
    - `sudo cp systemd/* /etc/systemd/system`
* Now start the timer, so that your DNS records get updated every 15 minutes
	- `sudo systemctl enable --now ddns.timer`
