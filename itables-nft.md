# Iptables & nftables

## Tables
Below are the names of the tables that rules are associated with. On web services you
will typically only interact with the filter table.

**List tables**  
`ls /lib/modules/$(uname -r)/kernel/net/ipv4/netfilter | grep -Po '(?<=iptable_)[a-z]+'`

- filter
- nat
- mangle
- raw 
- security (SeLinux)

## Rules

**List all the rules**  
`sudo iptables -L -v --line-numbers`

**Show rules**  
` sudo iptables -S`

**Really show everything**  
`sudo iptables-save`


## Modules & Extensions
http://ipset.netfilter.org/iptables-extensions.man.html

**List Extensions etc**   
`sudo ls /lib/modules/$(uname -r)/kernel/net/netfilter/`  

**List modules**   
`sudo ls /lib/modules/$(uname -r)/kernel/net/netfilter/xt_* | grep -oP '(?<=xt_)([a-z]+)'`  

**Find directory of modules**  
`ls $(iptables -m xyz -h 2>&1 | grep -oP '(?<=:)([a-z0-9\/_\-\.]+)' | xargs dirname)`

**Get Help on module**  
`iptables -m conntrack -h`
`iptables -m hashlimit -h 2>&1 | awk '/match options:$/,0'`

### Accounting & Quotas
- https://home.regit.org/2012/07/flow-accounting-with-netfilter-and-ulogd2/
- https://www.linux-noob.com/forums/index.php?/topic/3036-bandwidth-quotas-using-iptables/
- https://varinderjhand.wordpress.com/2012/05/21/iptables-rules-to-limit-time-quota-based-acces/
- https://unix.stackexchange.com/questions/240286/using-tc-for-traffic-quotas

## Throttling, Rate Limiting
- https://www.rackaid.com/blog/how-to-block-ssh-brute-force-attacks/
- https://thelowedown.wordpress.com/2008/07/03/iptables-how-to-use-the-limits-module/
- https://debian-administration.org/article/187/Using_iptables_to_rate-limit_incoming_connections
- http://blog.programster.org/rate-limit-requests-with-iptables/
- https://wiki.archlinux.org/index.php/Advanced_traffic_control#Using_tc_.2B_iptables

## NFQUEUE
Many IPS depeond on NFQUEUE to pass packet handling to themselves!
- http://sublimerobots.com/2017/06/snort-ips-with-nfq-routing-on-ubuntu/
- https://wiki.nftables.org/wiki-nftables/index.php/Queueing_to_userspace
- https://5d4a.wordpress.com/2011/08/25/having-fun-with-nfqueue-and-scapy/
- https://byt3bl33d3r.github.io/using-nfqueue-with-python-the-right-way.html
- http://www.cs.dartmouth.edu/~sergey/netreads/S2016/task4.txt
- http://blog.yancomm.net/2011/05/nfqueue-packet-mangling-with-python.html
- https://www.wzdftpd.net/blog/nfqueue-bindings.html

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
- https://strongarm.io/blog/linux-firewall-performance-testing/
- https://www.tummy.com/blogs/2005/07/17/some-iptables-modules-you-probably-dont-know-about/
- http://linuxgazette.net/108/odonovan.html
- https://www.linode.com/docs/security/firewalls/control-network-traffic-with-iptables