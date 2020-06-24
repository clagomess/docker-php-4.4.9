FROM debian:10

RUN apt update
RUN apt install build-essential -y
RUN apt install vim wget -y

# sources
RUN wget http://archive.apache.org/dist/httpd/httpd-2.0.65.tar.gz -P /srv \
&& wget http://museum.php.net/php4/php-4.4.9.tar.gz -P /srv
RUN cd /srv \
&& tar -xzf httpd-2.0.65.tar.gz \
&& tar -xzf php-4.4.9.tar.gz

# httpd
RUN cd /srv/httpd-2.0.65 \
&& ./configure --enable-so \
&& make \
&& make install

# php
# ./configure --help
RUN apt install flex -y
RUN cd /srv/php-4.4.9 \
&& ./configure --with-apxs2=/usr/local/apache2/bin/apxs --with-mysql \
&& make \
&& make install \
&& cp php.ini-dist /usr/local/lib/php.ini

# config httpd
RUN echo "AddType application/x-httpd-php .php .phtml" >> /usr/local/apache2/conf/httpd.conf \
&& echo "User www-data" >> /usr/local/apache2/conf/httpd.conf \
&& echo "Group www-data" >> /usr/local/apache2/conf/httpd.conf

RUN ln -sf /dev/stdout /usr/local/apache2/logs/access_log \
&& ln -sf /dev/stderr /usr/local/apache2/logs/error_log