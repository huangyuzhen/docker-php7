FROM php:7.0.33-fpm
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libpng-dev \
	&& pecl install redis-3.1.4 \
	&& docker-php-ext-enable redis opcache \
	&& docker-php-ext-install -j$(nproc) mcrypt exif mysqli \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
  && apt-get install -y imagemagick --no-install-recommends \
  && apt-get install -y python3 python3-pip \
  && rm -rf /var/lib/apt/lists/* \
  && pip3 install argparse Pillow \
