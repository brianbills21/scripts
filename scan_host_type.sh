for i in {1..254}
do
nmap -O 134.86.188.$i awk '/Running/' | awk '{print $2,"",$3}' >> os_list
done
for i in {1..254}
do
nmap -O 134.86.189.$i awk '/Running/' | awk '{print $2,"",$3}' >> os_list
done