FROM php:8.1.29-fpm

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
RUN sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources

RUN apt-get update && apt-get -y install cron procps
RUN pecl install redis-5.3.7

RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev libwebp-dev
RUN docker-php-ext-enable redis opcache \
    && docker-php-ext-install -j$(nproc) exif mysqli \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd

RUN apt-get install -y imagemagick --no-install-recommends

RUN apt-get install -y python3 python3-pip python3-venv
RUN python3 -m venv /env/py3 \
    && /env/py3/bin/pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip \
    && /env/py3/bin/pip install -i https://pypi.tuna.tsinghua.edu.cn/simple argparse Pillow

RUN rm -rf /var/lib/apt/lists/*

COPY Image-ExifTool-12.97.tar.gz /software/
RUN cd /software ; \
    tar zxf Image-ExifTool-12.97.tar.gz ; \
    cd /software/Image-ExifTool-12.97 ; \
    perl Makefile.PL ; \
    make install ; \
    ln -sf /usr/local/bin/exiftool /bin/exiftool ; \
    rm -rf /software/Image-ExifTool*
