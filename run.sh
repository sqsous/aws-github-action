touch test1.txt
touch test2.txt

date=$(date +"%s")
echo $date | tee -a test1.txt
echo $date | tee -a test2.txt

