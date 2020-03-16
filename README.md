# docker-gophish
Combined GoPhish and Nginx

TODO:
- Automate sh script to build nginx files from scrath (as opposed to needed to volume them)

Example docker run command:
```
docker run \
-v $(pwd)/gophish.db:/root/gophish/gophish.db \
-v $(pwd)/example.test.domain.conf:/root/nginx-temp/example.test.domain.conf \
-v $(pwd)/example2.test2.domain.conf:/root/nginx-temp/example2.test2.domain.conf \
--detach --restart unless-stopped -p 3333:3333 -p 80:80 -p 443:443 --name gophish jefftadashi/gophish-nginx \
example.test.domain example2.test2.domain
```
