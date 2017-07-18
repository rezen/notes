# Quotas

Set user quotes for disk space usage!

- https://www.shellhacks.com/remount-etc-fstab-without-reboot-linux/
- https://www.digitalocean.com/community/tutorials/how-to-enable-user-and-group-quotas
- https://www.howtoforge.com/how-to-set-up-journaled-quota-on-debian-lenny
- http://www.thegeekstuff.com/2010/07/disk-quota/
- https://ubuntuforums.org/showthread.php?t=1540938
- https://www.nicovs.be/ubuntu_quota/
- http://souptonuts.sourceforge.net/quota_tutorial.html !! Good post
- http://www.linuxquestions.org/questions/linux-server-73/directory-quota-601140/
- http://www.golinuxhub.com/2012/09/quota-implementation.html
- https://www.howtoforge.com/community/threads/problems-installing-quota.38106/

```shell
sudo apt install -y linux-image-extra-virtual quota quotatool
echo 'quota_v2' >> /etc/modules
modprobe quota_v1
modprobe quota_v2


LABEL=/home    /home   ext2   defaults,usrquota,grpquota  1 2

sudo quotatool -u *username* -bq 30000Mb -l "35000 Mb" /home -v

touch /home/aquota.user /home/aquota.group
chmod 600 /home/aquota.*

quotacheck -avugm
quotaon -avug

sudo quotatool -u willy -bq 1Mb -l "1 Mb" /quota -v

repquota -a
```