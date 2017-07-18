# Aide

- https://mailman.cs.tut.fi/pipermail/aide/2008-February/000903.html
- https://www.digitalocean.com/community/tutorials/how-to-install-aide-on-a-digitalocean-vps
- https://help.ubuntu.com/community/FileIntegrityAIDE#Installing_AIDE
- http://aide.sourceforge.net/stable/manual.html
- http://www.debianhelp.co.uk/aide.htm
- https://stelfox.net/knowledge_base/linux/aide/
- http://xmodulo.com/host-intrusion-detection-system-centos.html
- https://ushamim.wordpress.com/2016/03/23/hardening-linux-server-with-aide/
- https://www.rfxn.com/data-integrity-aide-for-host-based-intrusion-detection/
- http://www.eric.gruver.net/man_aide.config.html

After modifying any config files you need to reinitialise the database. I suggest
`update-aide.conf && aideinit -y -f`

## Install
```shell
apt-get update
apt-get install -y aide
sudo aideinit
aide.wrapper
sudo update-aide.conf
sudo aide-attributes
aide -v
cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
```