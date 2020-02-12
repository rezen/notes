# Security - Zap

- https://github.com/zaproxy/zaproxy/wiki/FAQapikey
- https://zaproxy.blogspot.com/
- https://github.com/zaproxy/zap-api-python/tree/master/src/examples
- https://digi.ninja/blog/zap_fuzzing.php
- https://www.slideshare.net/psiinon/owasp-2014-appseceu
- https://www.youtube.com/watch?v=eH0RBI0nmww&list=PLEBitBW-Hlsv8cEIUntAO8st2UGhmrjUB
- https://cyberarms.wordpress.com/2015/05/03/automatic-web-app-security-testing-with-owasp-zap/
- https://digi.ninja/blog/zap_fuzzing.php
- http://engineering-you.blogspot.com/2014/03/active-scan-scripts-for-zap-porxy.html
- https://medium.com/@PrakhashS/dynamic-scanning-with-owasp-zap-for-identifying-security-threats-complete-guide-52b3643eee04
- https://www.slideshare.net/psiinon/automating-owasp-zap-devcseccon-talk


Default username:password is zap:zap
```shell
zap-cli quick-scan --help
zap-cli -v --api-key puqllhj6gueggpe5coi6gsm832 quick-scan -sc -s all -r  https://192.168.99.101

# Increase cache size
sed -iE 's|CACHE SIZE 1|CACHE SIZE 10|;s|FILES SCALE 64|FILES SCALE 128|;s|LOB SCALE 32| LOB SCALE 64|' $(find / -type f -name zapdb.script -print -quit)
```
