FROM httpd:2.4

RUN sed -i \
    -e 's/^#\(LoadModule .*mod_proxy.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_proxy_fcgi.so\)/\1/' \
    /usr/local/apache2/conf/httpd.conf

COPY 000-default.conf /usr/local/apache2/conf/sites-available/000-default.conf

RUN mkdir -p /usr/local/apache2/conf/sites-enabled
RUN ln -s /usr/local/apache2/conf/sites-available/000-default.conf /usr/local/apache2/conf/sites-enabled/000-default.conf \
    && echo "Include /usr/local/apache2/conf/sites-enabled/" >> /usr/local/apache2/conf/httpd.conf

RUN rm /usr/local/apache2/htdocs/index.html

EXPOSE 80
CMD ["httpd-foreground"]