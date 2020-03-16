#!/bin/bash

#Try to build nginx files from arguments alone and test.example.com template
domain_array=("$@") 
for i in "${domain_array[@]}"
do
    cp /root/nginx-temp/test.example.com.conf /etc/nginx/conf.d/$1.conf
    sed -i "s/test.example.com/$1/g" /etc/nginx/conf.d/$1.conf
done
echo "/etc/nginx/conf.d/ contents now are:"
ls -la /etc/nginx/conf.d/

# Copy original custom config files into correct place
# NO LONGER USING THIS METHOD! TO BE REMOVED
# cp /root/nginx-temp/*.conf /etc/nginx/conf.d/
# echo "/etc/nginx/conf.d/ contents are:"
# ls -la /etc/nginx/conf.d/

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
