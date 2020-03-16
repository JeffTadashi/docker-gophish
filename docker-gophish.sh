#!/bin/sh

#Copy original custom config files into correct place
cp /root/nginx-temp/*.conf /etc/nginx/conf.d/
echo "/etc/nginx/conf.d/ contents are:"
ls -la /etc/nginx/conf.d/

#Start nginx without monitoring
nginx

#Using user input, make a comma separate list of all arguments 
# ($@ grabs all args, tr changes spaces to commas)
domain_comma_list=`echo "$@" | tr " " , `
echo "Domain Arguments Specified: "$domain_comma_list

#Run certbot against all domains defined above
certbot --non-interactive --nginx --redirect --register-unsafely-without-email --agree-tos \
-d $domain_comma_list

#finally, run GoPhish in monitoring state
/root/gophish/gophish
