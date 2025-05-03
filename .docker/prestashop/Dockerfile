FROM php:8.1-fpm-bullseye AS base

WORKDIR /var/www/html

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libicu67 \
      libzip4 \
      curl \
 && rm -rf /var/lib/apt/lists/*


RUN { \
      echo 'opcache.memory_consumption=128'; \
      echo 'opcache.interned_strings_buffer=8'; \
      echo 'opcache.max_accelerated_files=4000'; \
      echo 'opcache.revalidate_freq=60'; \
      echo 'opcache.fast_shutdown=1'; \
      echo 'opcache.enable_cli=1'; \
      echo 'date.timezone=Europe/Warsaw'; \
    } > /usr/local/etc/php/conf.d/opcache.ini

FROM base AS builder

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ${PHPIZE_DEPS} \
      libicu-dev \
      libzip-dev \
      zlib1g-dev \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      python3 \
      build-essential \
      git \
      unzip \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install \
      pdo_mysql \
      intl \
      zip \
      opcache \
      gd \
 && apt-get purge -y --auto-remove ${PHPIZE_DEPS} \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
 && apt-get install -y --no-install-recommends nodejs

RUN curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/bin --filename=composer

COPY . .

# RUN composer install --no-dev --optimize-autoloader --no-scripts 

FROM builder AS dev

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ${PHPIZE_DEPS} \
      bash \
      git \
      procps \
 && rm -rf /var/lib/apt/lists/*

RUN pecl install xdebug \
 && docker-php-ext-enable xdebug \
 && echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Wyłącz Xdebug dla CLI
ENV XDEBUG_MODE=off

RUN groupadd -g 1000 app \
 && useradd -u 1000 -g app -m -s /bin/bash app \
 && chown -R app:app /var/www/html
USER app

FROM base AS production

RUN groupadd -g 1000 app \
 && useradd -u 1000 -g app -m -s /bin/bash app

USER app
WORKDIR /var/www/html

COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/       /usr/local/etc/php/conf.d/
COPY --from=builder /var/www/html                    /var/www/html

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:9000/status || exit 1

EXPOSE 9000
CMD ["php-fpm"] 