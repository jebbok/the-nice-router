# the-nice-router

# Idea
The nice router intends to give the user a home or small business router with built in surf anonymization, ad-blocking and script-blocking, as well as firewall, bitcoin wallet, encrypted e-mail and personal backup.

The intention is to deploy on Raspberry Pi 3.

# Technologies in use
- Network adress translation (NAT) via iptables
- Re-routed network traffic for anonymization via Tor
- Oracle Java
- Lighttpd web server


# Technologies to be integrated
- Free Net Proxy
- Pi-hole for ad-free surfing

# Usage
1. Get a Raspberry Pi 3
2. Run pre-install (pre-install.sh) script to prepare a microSD with Raspbian.
3. Insert SDcard, boot up the Raspberry Pi 3, Connect using SSH, Run the installer (install.sh)
4. Connect to the Nice-Router Wifi and you are done.
