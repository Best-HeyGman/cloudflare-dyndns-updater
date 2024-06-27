#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright 2024 Stephan Hegemann

set -e

# For debugging. Do not set this in production use, because this would print your api token to the journal / terminal
#set -x


# Config
domain_names="dns_name.com
subdomain1.dns_name.com
subdomain2.dns_name.com"
zone_id=''
api_token=''


ipv4=$(curl --no-progress-meter -4 https://cloudflare.com/cdn-cgi/trace | grep ip | cut -d = -f 2)
ipv6=$(curl --no-progress-meter -6 https://cloudflare.com/cdn-cgi/trace | grep ip | cut -d = -f 2)
records=$(curl --no-progress-meter --request GET --url https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records --header 'Content-Type: application/json' --header "Authorization: Bearer $api_token")

for domain in $domain_names
do
	# A
	record_id=$(echo $records | jq -r '.result[] | select(.name=="'"$domain"'" and .type=="A") | .id')
	
	# If you don't explicitly set the proxied field, it would be set to "Not Proxied"
	# So we set it explicitly on every update to what it should be
	proxied=$(echo $records | jq -r '.result[] | select(.name=="'"$domain"'" and .type=="A") | .proxied')
	
	curl --no-progress-meter \
	--request PUT \
	--url https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id \
	--header 'Content-Type: application/json' \
	--header "Authorization: Bearer $api_token" \
	--data "{
	\"content\": \"$ipv4\",
	\"name\": \"$domain\",
	\"proxied\": $proxied,
	\"type\": \"A\"
	}"


	# AAAA
	record_id=$(echo $records | jq -r '.result[] | select(.name=="'"$domain"'" and .type=="AAAA") | .id')
	
	# If you don't explicitly set the proxied field, it would be set to "Not Proxied"
	# So we set it explicitly on every update to what it should be
	proxied=$(echo $records | jq -r '.result[] | select(.name=="'"$domain"'" and .type=="AAAA") | .proxied')

	curl --no-progress-meter \
	--request PUT \
	--url https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id \
	--header 'Content-Type: application/json' \
	--header "Authorization: Bearer $api_token" \
	--data "{
	\"content\": \"$ipv6\",
	\"name\": \"$domain\",
	\"proxied\": $proxied,
	\"type\": \"AAAA\"
	}"
done
