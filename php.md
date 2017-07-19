# PHP

## Composer

### Optmizing Autoloader
https://getcomposer.org/doc/articles/autoloader-optimization.md

## Code Standards
```shell
composer global require phpmd/phpmd
composer global require "squizlabs/php_codesniffer=*"
phpcs --config-set default_standard PSR

filename=test.php

# Use mess detector!
phpmd ${filename} text codesize,unusedcode,naming,design

# Use Code style checker
phpcs ${filename}`
# To fix fails phpcbf is your friend!
phpcbf ${filename}
```
