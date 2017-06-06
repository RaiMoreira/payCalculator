#iterating thru the list of names which is comming from names url
#check that we actually found an id
function getids {

	wget -q $1 -O - | while read names
	do
		id=`grep "$names" IDS | cut -d";" -f2`
		if [ -z $id ]
		then
			echo no id for $names  1>&2
			id=none
		fi
		echo $id $names 
	done
}

function gethours {
	hours=`grep "$1;" HOURS | cut -d";" -f2`
	if [ -z "$hours" ]
	then 
		echo 0
	else
		echo $hours
	fi
}

function getrate {
	rate=`grep "$1;" RATE  | cut -d";" -f2`
	if [ -z "$rate" ]
	then 
		echo 0
	else
		echo $rate
	fi
}

#construct the actual urls you needed to be created, 
#you could have put those urls in temp files to make it easier to grep


if [ $# -ne 5 ]
then
	echo Usage: $0 dir names ids hours rates 1>&2
	exit -1
fi

rm  -f HOURS RATE IDS
dir=$1
names=$dir/$2
ids=$dir/$3
hours=$dir/$4
rate=$dir/$5
wget -q $hours -O  HOURS
wget -q $rate -O RATE
wget -q $ids -O IDS


#pipe output of getids into this read command whichs gets ids and names
#this loop will iterate for all the names which contain an id 
getids $names | while read  idents name
do
	if [ "$idents" == "none" ]
	then
		continue
	fi
	hours=`gethours $idents`
	rate=`getrate $idents`
	let pay=$rate*$hours
	echo -e "$name\t\$$pay"
done | sort 

