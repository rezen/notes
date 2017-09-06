# Security - Recon

## nmap
```shell
sudo nmap -v -PN --max-scan-delay=500ms --max-rtt-timeout=650ms --max-retries=2 -sT -sU -p U:69,161,500,53,139,135,137,111,2049,1434,138,T:22,23,21,25,53,79,110,990,997,80,443,8080,8081,8443,8090,111,2049,9090,5061,8200,5800,5900,3389,3306,1477,1433,1234,2222,2121,2323,4443,135,137,139,445,143,5357,1720,3400,10000,9000,9443 --host-timeout=25m -iL IPlist.txt -oA result
```

- http://resources.infosecinstitute.com/nmap-cheat-sheet/#gref