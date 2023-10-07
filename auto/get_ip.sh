#!/usr/bin/env 
[ -f ./ext_ip ] && echo > ./ext_ip || touch ./ext_ip
cd terraform/ && terraform output > ../tf_out
cd ..
cat tf_out | sed '/external.*/,/}/!d;//d;s/[",=]//g;/![mv]/,//d' | grep vm| sed 's/^[[:space:]]*//' >> ext_ip