# Vagrant

**Get guest ip**  
`vagrant ssh -c "hostname -I | cut -d' ' -f2" 2>/dev/null`  
https://coderwall.com/p/etzdmq/get-vagrant-box-guest-ip-from-host