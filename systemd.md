# Notes - SystemD

Important note, the `Environment=PATH=...` does not interopolate other environment variables
- https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files
- http://hokstadconsulting.com/devops/writing-systemd-units
- http://sysadvent.blogspot.com/2015/12/day-17-grokking-systemd-for-fun-and.html
- https://asylum.madhouse-project.org/blog/2015/09/09/systemd-job-monitoring/
- https://fedoramagazine.org/systemd-template-unit-files/
- http://www.tecmint.com/manage-services-using-systemd-and-systemctl-in-linux/
- https://www.dynacont.net/documentation/linux/Useful_SystemD_commands/
- `/usr/lib/systemd/system`

```shell
# After installing config
sudo systemctl daemon-reload

# Show available units
sudo systemctl

sudo systemctl status tsdb-recorder.service
sudo systemctl restart tsdb-recorder.service
sudo systemctl show tsdb-recorder.service

# Logging
journalctl -u  tsdb-recorder.service

# To test systemd restarting
# sudo kill -KILL $(ps aux | grep record | head -n1 | tr -s ' ' | cut -d ' ' -f 2)


# Utilizations
systemd-cgtop -m

# Running services
systemctl -t service | grep -v systemd

# CSV format of unit,load,active,sub
systemctl -t service | tr -s ' ' | tr -d 'â—' | awk '$1 ~ /^[a-z]/ {out=""; for(i=1;i<5;i++){out=out" "$i", "}; print out}'

# If you have a failed service you removed, it will stay until you run this
systemctl reset-failed

# Remove stopped 1 off jobs
sudo systemctl stop tsdb-alert@fail-cat.service.service

# Show the config for the service
sudo systemctl cat tsdb-recorder.service
```
