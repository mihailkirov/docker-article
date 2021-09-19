#!/bin/sh
curl --unix-socket /var/run/docker.sock http://localhost/containers/json -XGET > result
for id in $(grep -oP '\"Id\":\"\K\w+' result); do 
	curl --unix-socket /var/run/docker.sock  http://localhost/containers/$id/export -XGET -o $id.tar; 
	mkdir $id && tar -xf $id.tar -C $id && touch analyse-$id;       	
	echo "--------------------CERTS-$id---------------------------" >> analyse-$id;
	for ext in .crt .pem .pub; do
		for f in $(find $id -iname "*.${ext}" 2>/dev/null); do
			cat $f >> $analyse-$id; cat " " >> $analyse-$id;
		done
	done
	echo "---------------------SECRETS-$id------------------------" >> analyse-$id;
	grep -I -n  -r -e "-----BEGIN" $id  2>/dev/null 1>>analyse-$id;
	rm -r -f $id && rm $id.tar && rm result; 
done



