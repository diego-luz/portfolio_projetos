FROM scratch AS build
LABEL maintainer="diego.saberdl@gmail.com"
# Copie os arquivos do código-fonte para /app
COPY . /app/
WORKDIR /app
ENV APP_VERSION=2.1

FROM alpine:3.20.3
RUN apk update && \
    apk upgrade && \
    apk add apache2 && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /run/apache2   && \
    echo "ServerName localhost" >> /etc/apache2/conf.d/servername.conf
# Copiar os arquivos do código-fonte da etapa de build para o diretório do Apache
COPY --from=build /app /var/www/localhost/htdocs
EXPOSE 80
CMD ["httpd", "-D", "FOREGROUND"]