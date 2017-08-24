# Security - Bruteforce

## Wordlist Generating
- https://charlesreid1.com/wiki/John_the_Ripper/Password_Generation
- https://www.lanmaster53.com/2011/02/creating-complex-password-lists-with-john-the-ripper/
- https://github.com/crunchsec/crunch
- https://github.com/hashcat/maskprocessor/
- https://github.com/crunchsec/cewl
- https://qntm.org/l33t

```shell
# Generate a dictionary from username `elly`
python pydictor.py -extend elly --level 1 --len 4 16 -o elly-wordlist.lst

# Using `john` generate a dictionary
echo elly > user.txt; john --wordlist='user.txt' --rules --stdout


# Hashcat sometimes comes bundled with maskprocessor ... or you may have to download it
cd /opt
wget https://github.com/hashcat/maskprocessor/releases/download/v0.73/maskprocessor-0.73.7z
7za x maskprocessor-0.73.7z
# From a set of strings generate a dictionary 4-12 chars in length using the chars specified
./mp64.bin -i 4:12 -1 'elyj1!123' ?1?1?1?1?1?1
```


## Protection
https://jerrygamblin.com/2017/08/24/disallow-million-most-common-passwords/