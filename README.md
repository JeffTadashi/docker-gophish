# docker-gophish
Combined GoPhish and Nginx

Example docker run command:
```
docker run \
-v $(pwd)/gophish.db:/root/gophish/gophish.db \
-v $(pwd)/example.test.domain.conf:/etc/nginx/conf.d/example.test.domain.conf \
-v $(pwd)/example2.test2.domain.conf:/etc/nginx/conf.d/example2.test2.domain.conf \
--detach --restart unless-stopped -p 3333:3333 -p 80:80 -p 443:443 --name gophish jefftadashi/gophish-nginx \
example.test.domain example2.test2.domain
```
