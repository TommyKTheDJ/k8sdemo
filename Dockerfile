FROM httpd
MAINTAINER Tom Kivlin
RUN apt-get update
COPY index.html /usr/local/apache2/htdocs/
EXPOSE 80