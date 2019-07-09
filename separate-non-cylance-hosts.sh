for i in {A..Z}
do
    cat notincylance.txt | grep "^$i" > add-agent-$i.`date +"%m%d%y"`.txt
done
