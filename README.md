# docker-gophish
Combined GoPhish and Nginx

TODO:
- Automate sh script to build nginx files from scrath (as opposed to needed to volume them)

Example docker run command:
```
docker run \
-v $(pwd)/gophish.db:/root/gophish/gophish.db \
--detach --restart unless-stopped -p 3333:3333 -p 80:80 -p 443:443 --name gophish jefftadashi/gophish-nginx \
example.test.domain example2.test2.domain
```


Self-notes:
```
To build:
docker buildx build --platform linux/amd64,linux/386 -t jefftadashi/gophish-nginx:latest -t jefftadashi/gophish-nginx:multi-arch --push .
```
