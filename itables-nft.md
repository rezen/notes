# Iptables & nftables

## Tables
Below are the names of the tables that rules are associated with. On web services you
will typically only interact with the filter table.

- filter
- nat
- mangle
- raw 
- security (SeLinux)

**List all the rules**  
`sudo iptables -L -v --line-numbers`

**Show rules**  
` sudo iptables -S`

**Really show everything**  
`sudo iptables-save`


## Throttling, Rate Limiting
- https://www.rackaid.com/blog/how-to-block-ssh-brute-force-attacks/
- https://thelowedown.wordpress.com/2008/07/03/iptables-how-to-use-the-limits-module/
- https://debian-administration.org/article/187/Using_iptables_to_rate-limit_incoming_connections
- http://blog.programster.org/rate-limit-requests-with-iptables/

## Links
- http://shop.oreilly.com/product/9780596005696.do
- https://www.garron.me/en/linux/iptables-manual.html
- https://linux.die.net/man/8/iptables
- https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands
- http://developer-should-know.com/post/128018906292/minimal-iptables-configuration
- http://www.tricksofthetrades.net/2015/05/18/iptables-ipv4/
- http://newartisans.com/2007/09/neat-tricks-with-iptables/
- https://idolstarastronomer.com/iptables.html
- https://www.tecmint.com/linux-iptables-firewall-rules-examples-commands/
- https://wiki.archlinux.org/index.php/simple_stateful_firewall#Tricking_port_scanners
- https://wiki.archlinux.org/index.php/Sysctl#TCP.2FIP_stack_hardening
- https://danielmiessler.com/study/iptables/