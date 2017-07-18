# VirtualBox & Vagrant

## Vagrant
**Get guest ip**  
`vagrant ssh -c "hostname -I | cut -d' ' -f2" 2>/dev/null`  
https://coderwall.com/p/etzdmq/get-vagrant-box-guest-ip-from-host


## VirtualBox
UUID Already exists  
http://www.groovypost.com/howto/virtualbox-error-uuid-hard-disk/  
 
`vboxmanage.exe internalcommands sethduuid "D:\vdocs\vdisc\jenkins-0.001\box-disk1_2.vmdk"`  