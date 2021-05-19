#!/usr/bin/bash

host=$1
ports=$2
paths=$3

# TODO adjust to multiport and fit it for paths by porst

printf "HOST: ${host}\n PORTS: ${ports}\n PATHS: ${paths}"

http_methods=('GET POST PUT DELETE TRACE CETRIS STI')

# Testing using nmap scan 

for path in ${paths}; do
   printf "[COMMAND] nmap -p ${ports} --script http-methods --script-args http-methods.url-path='${path}' ${host}\n"
   nmap -p ${ports} --script http-methods --script-args http-methods.url-path=${path} ${host}
done

# Check method using pure request

for path in ${paths}; do
  for methods in ${http_methods}; do
    status=$(printf "${methods} ${path} HTTP/1.1\r\n\r\n" | nc ${host} ${ports} | head -n 1 | awk '{print $2}')
    printf "%s %s %d\n" ${methods} ${path} $status
  done
done

