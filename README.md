Создаём dockerfile и записываем основные данные, как требуется в задании
Далее собираем docker image

<details>
  <summary>ТЫК</summary>

```
~/Linux2022-12/otus-docker$ docker build -t otus-docker .
Sending build context to Docker daemon  45.57kB
Step 1/4 : FROM nginx:latest
 ---> 904b8cb13b93
Step 2/4 : RUN apt update && apt install nano -y
 ---> Using cache
 ---> 5cb9dc513f1d
Step 3/4 : VOLUME /usr/share/nginx/html
 ---> Using cache
 ---> e564f53e0e99
Step 4/4 : VOLUME /var/log/nginx
 ---> Using cache
 ---> 2863539aec3c
Successfully built 2863539aec3c
Successfully tagged otus-docker:latest
```
</details>

После сборки образа первый раз стартуем контейнер, с указанием 2х вольюмов и пробрасываемых портов до веб-сервера:

```
~/Linux2022-12/otus-docker$ docker run -p 99:80 -dt --name otus otus-docker
8b06ecb67464d0c9b3124b65394949cc4e3d41c10abc8f47ce839d7d8a0e51bb
~/Linux2022-12/otus-docker$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                               NAMES
8b06ecb67464   otus-docker   "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds   0.0.0.0:99->80/tcp, :::99->80/tcp   otus
```
Страницы доступны на localhost:99 и localhost:80

Доп задание:

Из файла docker-compose.yml создаем image и запускаем 2 контейнера, один с базой постгри, второй с редмайном

```
~/Linux2022-12/otus-docker$ docker-compose up -d
Starting otus-docker_redmine_1 ... 
Starting otus-docker_redmine_1 ... done
```
У меня возникли проблемы с 80м портом при старте контейнера redmine т.к. на рабочем ноуте был запущен сервис apache, я его стопнул и всё запустилось.

```
Starting otus-docker_redmine_1 ... 
otus-docker_postgres_1 is up-to-date
Starting otus-docker_redmine_1 ... error

ERROR: for otus-docker_redmine_1  Cannot start service redmine: driver failed programming external connectivity on endpoint otus-docker_redmine_1 (21a56e900309fbe17531b3057878e996600d67a78ef06fa259d9b9b0dc4e8a6e): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use

ERROR: for redmine  Cannot start service redmine: driver failed programming external connectivity on endpoint otus-docker_redmine_1 (21a56e900309fbe17531b3057878e996600d67a78ef06fa259d9b9b0dc4e8a6e): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use
```
Далее находим подходящую тему и скачиваем её при помощи wget
Копируем в директорию /storage
```
~/Linux2022-12/otus-docker/storage/docker_redmine-themes$ ll
итого 160
drwxr-xr-x 2 root root   4096 мар 14 13:56 ./
drwxr-xr-x 6 root root   4096 мар 14 12:27 ../
-rw-r--r-- 1 root root 153700 мар 14 13:56 application.css
```
Она появляется в указанной директории в контейнере
```
root@5df7f788bf93:/usr/src/redmine/public/themes# ls -la
total 160
drwxr-xr-x 2 root root   4096 Mar 14 12:56 .
drwxr-xr-x 3 root root   4096 Mar 14 11:27 ..
-rw-r--r-- 1 root root 153700 Mar 14 12:56 application.css
```
Дальше 
```
~/Linux2022-12/otus-docker$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED       STATUS       PORTS                                           NAMES
9e86a101cf4c   postgres:10      "docker-entrypoint.s…"   2 hours ago   Up 2 hours   5432/tcp                                        otus-docker_postgres_1
5df7f788bf93   redmine:custom   "/docker-entrypoint.…"   2 hours ago   Up 2 hours   80/tcp, 0.0.0.0:80->3000/tcp, :::80->3000/tcp   otus-docker_redmine_1

~/Linux2022-12/otus-docker$ docker restart 5df7f788bf93
5df7f788bf93
```
Идём в Administration -> Settings -> Display и выбираем новую тему.
