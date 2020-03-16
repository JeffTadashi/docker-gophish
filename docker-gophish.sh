#!/bin/bash
#Needs bash installed, as ash/sh don't seem to work with arrays

#Build nginx per-site config files from arguments and test.example.com template
domain_array=("$@") 
for i in "${domain_array[@]}"
do
    cp /root/nginx-temp/test.example.com.conf /etc/nginx/conf.d/$1.conf
    sed -i "s/test.example.com/$1/g" /etc/nginx/conf.d/$1.conf
done
echo "/etc/nginx/conf.d/ contents now are:"
ls -la /etc/nginx/conf.d/

#Start nginx without monitoring
nginx

#Using user input, make a comma separate list of all arguments 
# ($@ grabs all args, tr changes spaces to commas)
domain_comma_list=`echo "$@" | tr " " , `
echo "Domain Arguments Specified: "$domain_comma_list

#Run certbot against all domains defined above
#(Note that Let's Encrypt will block if doing +5 attempts for same domain, per week)
certbot --non-interactive --nginx --redirect --register-unsafely-without-email --agree-tos \
-d $domain_comma_list

#finally, run GoPhish in monitoring state
/root/gophish/gophish
