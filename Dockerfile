FROM alpine:edge
MAINTAINER Johann Zelger <j.zelger@techdivision.com>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --update \
        bash wget ca-certificates openssl \
        apache-ant \
        curl git nodejs \
        supervisor \
        mysql mysql-client \
        nginx \
        redis \
        php5-fpm php5-curl php5-dom php5-gd php5-iconv php5-mcrypt php5-pdo php5-pdo_mysql php5-soap php5-ctype php5-json php5-openssl php5-zlib php5-intl php5-xsl php5-zip php5 \
        php7-fpm php7-curl php7-dom php7-gd php7-iconv php7-mcrypt php7-pdo php7-pdo_mysql php7-soap php7-ctype php7-json php7-openssl php7-zlib php7-intl php7-xsl php7-zip php7-phar php7-session php7-mongodb php7 \
        apache2 php5-apache2 && \

    # this is not executed by mariadb package
    mysql_install_db --user=mysql && \

    # install gitlab ci runner
    wget -O /usr/bin/gitlab-ci-multi-runner https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64 && \
    chmod +x /usr/bin/gitlab-ci-multi-runner && \

    # clear apk cache to optimize image filesize
    rm -rf /var/cache/apk/* && \

    # install composer
    curl -sS https://getcomposer.org/installer | php7 -- --install-dir=/usr/local/bin --filename=composer && \

    # install latest gulp-cli tools globally
    npm install gulpjs/gulp-cli -g && \

    # prepare filesystem and permissions
    mkdir /run/mysqld /run/apache2 && \
    chown mysql /run/mysqld

# copy all configurations
COPY etc /etc

CMD ["/usr/bin/supervisord"]
