#!/bin/sh

#Start nginx without monitoring
nginx

#Using user input, make a comma separate list of all arguments 
# ($@ grabs all args, tr changes spaces to commas)
domain_comma_list=`echo "$@" | tr " " , `
echo $domain_comma_list

#Run certbot against all domains defined above
certbot --non-interactive --nginx --redirect --register-unsafely-without-email --agree-tos \
-d $domain_comma_list

#finally, run GoPhish in monitoring state
/root/gophish/gophish
