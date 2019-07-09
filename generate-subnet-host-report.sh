for i in {1..254}
do
    nslookup 134.86.188.$i | awk 'NR==4' | awk '{print $2}' >> host_list
done
for i in {1..254}
do
    nslookup 134.86.189.$i | awk 'NR==4' | awk '{print $2}' >> host_list
done
