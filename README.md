# About
 Пример сборки из source code deb пакета nginx c дополнительными модулями:
 - [nginx-vod-module](https://github.com/kaltura/nginx-vod-module)
 - [nginx-akamai-token-validate-module](https://github.com/kaltura/nginx-akamai-token-validate-module)
 - [nginx-secure-token-module](https://github.com/kaltura/nginx-secure-token-module) 
 
В качестве базовой системы используется images debian 10.7, репозиторий используется nginx.com. Моменты по сборке  можно уточнить тут
[man-build](https://www.debian.org/doc/manuals/maint-guide/build.ru.html)

# Build
```bash
docker build  -t nginx:v1 .
docker run -it  nginx:v1 /bin/sh
```
```bash
docker build --build-arg NGINX_VERSION=1.18.0 -t nginx:v2 .
docker run -it  nginx:v2 /bin/sh
```

Собранные deb пакеты будут доступны в папке /root/ нашего контейнера.
