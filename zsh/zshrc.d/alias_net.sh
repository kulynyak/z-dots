#!/bin/zsh

# Example:
# $ oport
# Shows all opened TCP ports and their associated programs
# netstat: provides network-related information
# -n: shows numerical addresses instead of resolving hosts
# -t: shows TCP ports
# -l: shows listening ports
# -p: shows the process ID and name of the program to which each socket belongs
alias oport='netstat -ntlp tcp'

# Example:
# $ port 80
# Shows a specific port's listening service/process
# lsof: lists open files
# -i -P: selects only network files (IPv4/IPv6) and suppresses port name conversion
# grep LISTEN: filters for listening ports
# grep :$1.: finds the port number specified by the argument
alias port='(){ sudo lsof -i -P | grep LISTEN | grep :$1. ;}'

# Example:
# $ ip
# Displays IPv4 addresses of the system, excluding loopback address (127.0.0.1)
# ifconfig: displays network configuration
# grep "inet ": filters IPv4 addresses
# grep -Fv 127.0.0.1: excludes the loopback address
# awk '{print $2}': prints the second column, which is the IP address
alias ip='ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk "{print \$2}"'

# Example:
# $ ip6
# Displays IPv6 addresses of the system, excluding link-local address (fe80::)
# ifconfig: displays network configuration
# grep "inet6": filters IPv6 addresses
# grep -v "fe80::": excludes the link-local address
# awk '{print $2}': prints the second column, which is the IP address
alias ip6='ifconfig | grep "inet6" | grep -v "fe80::" | awk "{print \$2}"'

# Example:
# $ ipe
# Retrieves the external IP address of the system using ipecho.net
# wget -qO -: silently retrieves data and outputs to standard output
# http://ipecho.net/plain: the URL that returns the external IP address
# echo: adds a newline after the IP address
alias ipe='wget -qO - http://ipecho.net/plain; echo'

# Example:
# $ ipa
# Shows all IP addresses of the system, marking the external one with a star
alias ipa='(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk "{print \$2}"; ifconfig | grep "inet6" | grep -v "fe80::" | awk "{print \$2}"; echo "* $(wget -qO - http://ipecho.net/plain; echo)")'

# Example:
# $ flushdns
case "$__OS" in
Darwin)
    # Flushes the DNS cache and restarts mDNSResponder for macOS
    # sudo dscacheutil -flushcache: clears DNS cache
    # sudo killall -HUP mDNSResponder: restarts the mDNSResponder service
    alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
    ;;
Fedora)
    # Flushes the DNS cache for Fedora
    # sudo systemd-resolve --flush-caches: clears DNS cache
    # sudo systemctl restart NetworkManager: restarts the NetworkManager service
    alias flushdns='sudo systemd-resolve --flush-caches; sudo systemctl restart NetworkManager'
    ;;
esac
