# docker-gophish
Combined GoPhish and Nginx, with Certbot! More details to come.

Example docker run command:
```
docker run \
-v $(pwd)/gophish.db:/root/gophish/gophish.db \
--detach --restart unless-stopped -p 3333:3333 -p 80:80 -p 443:443 --name gophish jefftadashi/gophish-nginx \
a.test.domain b.test.domain
```


Self-notes:
```
To build:
docker buildx build --platform linux/amd64,linux/386 -t jefftadashi/gophish-nginx:latest -t jefftadashi/gophish-nginx:multi-arch --push .

Also note that there is a Lets Encrypt duplicate certificate limit of 5 per week. 
Problematic during my docker run testing, but it did fail correctly (use http only) when limit is hit
```
