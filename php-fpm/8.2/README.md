## Custom php-fpm build to reduce size

### Source
* https://github.com/docker-library/php

## Modification
* Many modules added
* Removed $PHPIZE packages, 50% reduction
* Removed php source gnupg check
* Reorder build steps