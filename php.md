# PHP

## One Liners
```bash
# Quick Web server
php -S 127.0.0.1:8000
```

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

## Links
- https://www.youtube.com/watch?v=vS0Nn_ncH-8
- https://medium.com/@rtheunissen/efficient-data-structures-for-php-7-9dda7af674cd
- https://slack.engineering/taking-php-seriously-cf7a60065329
- http://zalas.eu/phpqa-static-analysis-tools-for-php-docker-image/
- https://speakerdeck.com/tommymuehle/defensive-programming