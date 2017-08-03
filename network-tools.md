# Network Tools

- https://image.slidesharecdn.com/devoxxbelgium2016-debuggingdistributedsystems-161110141549/95/debugging-distributed-systems-devoxx-belgium-2016-extended-64-1024.jpg?cb=1478787475
- https://www.slideshare.net/DonnyNadolny/debugging-distributed-systems-devoxx-belgium-2016-extended
- http://mark.koli.ch/slowdown-throttle-bandwidth-linux-network-interface

**Add latency**  
`tc qdisc add dev eth0 root netem delay 500ms 100ms loss 25%`  

**Remove latency**  
`tc qdisc add del dev eth0 root netem`  

**Restrict bandwith**  
```shell
tc qdisc add dev eth0 handle 1: root htb default 11
tc qdisc add dev eth0 parent 1: classid 1:1 htb rate 100kbps
tc qdisc add dev eth0 parent 1:1 classid 1:11 htb rate 100kbps
```

**Remove bandwith restriction**  
`tc qdisc del dev eth0 root`  
  
**Tip** - when doing latency/loss/bandwitch restriction run 
`sleep 60 && <tc delete command> && disown` in case you lose ssh access

Configure database/app local data directory to be /mnt then use tools above against 123.45.67.89  
`sshfs me@123.45.67.89:/tmp/data /mnt`  

alternative: nbd (network block device)

- `netstat -peanut` Network connections, regular kerl view
- `conntrack -L`  Network connections iptables view

### VXLAN
- https://vincent.bernat.im/en/blog/2017-vxlan-bgp-evpn
- https://vincent.bernat.im/en/blog/2017-vxlan-linux


## Tools
- https://coderwall.com/p/zqulaw/introduction-to-ngrep

## Links
- https://www.michaelwlucas.com/networking/n4sa
- https://jvns.ca/zines/#networking-ack