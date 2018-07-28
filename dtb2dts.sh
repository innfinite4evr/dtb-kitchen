#!/bin/bash
# Lazy script open written By <Innfinite4evr@xda-developers.com>

WD=$(pwd)

echo "Wanna split that appended dtb from Image.gz-dtb/zImage.dtb?
00)cleanup
0)yes
1)no


Note: answer 00 for cleanup
--OR--
Answer as 0 or 1 after that hit [ENTER]"


echo "Select 1 if you have already splitted those dtbs
and kept in $WD/dtb folder and want to dtb2dts/dts2dtb/appendmydtbs"

read n
case $n in
    00)j=cleanup;;
    0)a=yes;;
    1)a=no;;
    *) invalid option;;
esac

if [ "$j" = "cleanup" ]
then
echo "LOOKOUT: $WD/dtb $WD/dts $WD/newdtb DELETED"
rm -rf $WD/dtb $WD/dts $WD/newdtb
exit
fi

if [ "$a" = "yes" ]
then
echo "SPLITTING THOSE APPENDED DTB FILES"
$WD/split-appended-dtb $WD/boot.img-zImage
mkdir -p $WD/dtb $WD/dts
echo "DTB'S ARE IN $WD/dtb"
mv $WD/dtbdump_*.dtb $WD/dtb
echo "NOTE: You can dts2dtb only after extracting dtb's to dtb folder in script directory"
fi

echo "

You wanna dtb2dts or dts2dtb or appendmydtbs ?
1)dtb2dts
2)dts2dtb
3)appendmydtbs

Note: 
answer as 1 for dtb2dts
answer as 2 for dts2dtb
answer as 3 to append those dtb files in newdtb directory with kernel 
after that hit [ENTER]"

read n
case $n in
    1)j=dtb2dts;;
    2)j=dts2dtb;;
    3)j=appendmydtbs;;
    *) invalid option;;
esac

if [ "$j" = "dtb2dts" ]
then
cd $WD/dtb
for file in $WD/dtb/*.dtb
do
dtc -I dtb -O dts -o $(basename $file | cut -f1 -d'.').dts $file
done
mv *.dts $WD/dts
fi
if [ "$j" = "dts2dtb" ]
then
cd $WD/dts
for file in $WD/dts/*.dts
do
dtc -I dts -O dtb -o $(basename $file | cut -f1 -d'.').dtb $file
done
mkdir $WD/newdtb
mv *.dtb $WD/newdtb
fi
if [ "$j" = "appendmydtbs" ]
then
cp $WD/kernel $WD/newdtb
cd $WD/newdtb
ndtbs=$(echo -E $(ls *.dtb -v))
echo "Note: If kernel exists in this $WD/newdtb directory then it will be appended to all those dtbdump_* dtbs else all those dtbdump_* will be appended into single dtb file"
cat kernel $ndtbs > kernelwithappendeddtb
mv $WD/newdtb/kernelwithappendeddtb $WD/
fi
echo "THIS SCRIPT IS WRITTEN OUT OF OF TOTAL LAZINESS
DONT EXPECT IT TO BE NOOB FRIENDLY OR PERFECT!!"
