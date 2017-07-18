# Suricata

## Installation
```shell
apt-get -y install libnetfilter-queue-dev  libnetfilter-queue1 libnfnetlink-dev libnfnetlink0
sudo iptables -I INPUT -p tcp --sport 80  -j NFQUEUE
sudo iptables -I OUTPUT -p tcp --dport 80 -j NFQUEUE
iptables -A OUTPUT -p tcp --dport 80 -j NFQUEUE --queue-num 0 --queue-bypass
iptables -I INPUT -p tcp -j NFQUEUE

# LISTENMODE=nfqueue
# NFQUEUE=0

iptables -A OUTPUT -p tcp --dport 53 -j NFQUEUE --queue-num 1
iptables -A OUTPUT -p udp --dport 53 -j NFQUEUE --queue-num 1
```

## Resources
- https://danielmiessler.com/blog/building-ids-centos-using-suricata/
- https://hackertarget.com/install-suricata-ubuntu-5-minutes/
- https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Ubuntu_Installation_-_Personal_Package_Archives_%28PPA%29#Beta-releases
- https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Common_Errors
- https://www.aldeid.com/wiki/Suricata-vs-snort/Test-cases/Test-rules
- https://www.serializing.me/2015/05/12/protecting-wordpress-with-suricata/
- http://xmodulo.com/install-suricata-intrusion-detection-system-linux.html
- https://web.nsrc.org/workshops/2015/pacnog17-ws/raw-attachment/wiki/Track2Agenda/ex-suricata-config-test.htm
- https://nullsecure.org/malware-traffic-analysis-using-splunk/
- https://www.howtoforge.com/how-to-set-up-an-ips-intrusion-prevention-system-on-fedora-17
- https://home.regit.org/2011/01/building-a-suricata-compliant-ruleset/
- https://home.regit.org/2014/02/suricata-and-nftables/
- http://tekyhost.com/deploy-iptables-with-nat-and-suricata-ids-on-centos-7/
- https://home.regit.org/netfilter-en/using-nfqueue-and-libnetfilter_queue/
- https://home.regit.org/wp-content/uploads/2015/02/suricata-netfilter-prc.pdf
- https://blog.inliniac.net/2014/07/28/suricata-flow-logging/
- http://samiux.blogspot.com/2013/01/howto-suricata-on-ubuntu-1204-lts-server.html
- https://scadasecurity636.wordpress.com/2014/07/10/the-suricata-ips-mode-and-iptables/
- http://www.linux-magazine.com/Issues/2014/167/Suricata/(offset)/6
- https://www.upguard.com/articles/top-free-network-based-intrusion-detection-systems-ids-for-the-enterprise
- http://code.hootsuite.com/bots-bots-bots-which-are-good-which-are-bad/
- http://www.netresec.com/?page=Blog&month=2011-07&post=How-to-detect-reverse_https-backdoors
- https://www.mitre.org/sites/default/files/publications/pr-13-1028-mitre-10-strategies-cyber-ops-center.pdf
- http://taosecurity.blogspot.com/2014/01/suricata-20beta2-as-ips-on-ubuntu-1204.html
- https://github.com/centeropenmiddleware/solowan/wiki/Traffic-forwarding
- http://blog.talosintel.com/2010/04/using-snort-fast-patterns-wisely-for.html

Make sure to setup the iptables rules for port 80, lest use lose your connections.

