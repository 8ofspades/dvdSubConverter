#!/bin/bash

OPTIND=1
IFS=$'\n'

show_help (){
    echo "Converts dvd image subs to srt subs"
    echo "Example: "
    echo "Options:"
    echo "-h = help (this menu)"
    echo "-i = File input"
    echo "-n = stream number (starting with 0 as the first)"
    echo "-l = stream language in lowercase 2 letter format (en, fr, de, etc.)"
}


#Options Menu
while getopts ":hi:o:n:l:" opt; do
    case $opt in 
    h)
        show_help
	exit 0
	;;
    i)
	input=$OPTARG
	;;
    o)
	output=$OPTARG
	;;
    n)
	sub=$OPTARG
	;;
    l)
	lang=$OPTARG
	;;
    esac
done

folder=$(dirname "$input")
video=$(basename "$input")
subs=subs_${lang}

cd ${folder}/
mkdir $subs
cat $video | tcextract -x ps1 -t vob -a 0x2$sub > ${subs}/${subs}.ps1
cd ${subs}/
subtitle2pgm -i ${subs}.ps1 -c 255,0,0,255 -o $subs #add -c 255,0,0,255 for grey subs
~/Projects/Scripts/pgm2txt -f $lang $subs
srttool -s -i ${subs}.srtx -o ../${subs}.srt

cd ../
pwd

if [ $lang = "en" ]
then
sed -i -e "s/l'd/I'd/g" -e "s/l'm/I'm/g" -e "s/l'll/I'll/g" -e "s/\ l\ /\ I\ /g"  -e "s/l've/I've/g" 
       -e "s/evey/every/g" -e "s/doni/don't/I" -e "s/Iil/I'll/g" -e "s/hasni/hasn't/g" -e "s/weil/we'll/g" 
       -e "s/woni/won't/g" -e "s/doesni/doesn't/g" -e "s/youil/you'll/g" -e "s/mustni/mustn't/g" 
       -e "s/areni/aren't/I" -e "s/shani/shan't/g" ${subs}.srt
fi

if [ $lang = "de" ]
then
sed -i -e "s/Dt/ßt/g"  -e "s/aD/aß/g" -e "s/uD/uß/g" -e "s/üD/üß/g" -e "s/iD/iß/g" -e "s/äD/äß/g" -e "s/oD/oß/g"
       -e "s/eD/eß/g" ${subs}.srt
fi

if [ $lang = "it" ]
then
sed -i -e "s/ė/è/g" -e "s/ȧ/à/g" -e "s/ȯ/ò/g" -e "s/%/'a/g"${subs}.srt
fi




