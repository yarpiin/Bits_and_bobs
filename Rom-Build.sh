#!/bin/bash

# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Vars
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL=C
export USE_CCACHE=1
export TARGET_BOOT_ANIMATION_RES=1080
export TARGET_GAPPS_ARCH=arm64

# Paths
ROMDIR="/home/yarpiin/Android/ROM/Evo"
STARKERNELDIR="/home/yarpiin/Android/ROM/Build_Stuff/kernel/samsung/universal9810-star"
CROWNKERNELDIR="/home/yarpiin/Android/ROM/Build_Stuff/kernel/samsung/universal9810-crown"
ROMKERNELDIR="/home/yarpiin/Android/ROM/Evo/kernel/samsung"
ROMCROWNKERNELDIR="/home/yarpiin/Android/ROM/Evo/kernel/samsung/universal9810-crown"
ROMSTARKERNELDIR="/home/yarpiin/Android/ROM/Evo/kernel/samsung/universal9810-star"

# Functions
function clean_all {
		cd $ROMDIR
		echo
		make installclean
}

function repo_sync {
		cd $ROMDIR
		echo
		repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
}

function make_star_rom {
		echo
		cp -r $STARKERNELDIR $ROMKERNELDIR
		rm -r $ROMCROWNKERNELDIR
		cd $ROMDIR
		. build/envsetup.sh
		lunch aosp_starlte-userdebug
		mka bacon -j8
}

function make_star2lte_rom {
		echo
		cp -r $STARKERNELDIR $ROMKERNELDIR
		rm -r $ROMCROWNKERNELDIR
		cd $ROMDIR
		. build/envsetup.sh
		lunch aosp_star2lte-userdebug
		mka bacon -j8
}

function make_crown_rom {
		echo
		cp -r $CROWNKERNELDIR $ROMKERNELDIR
		rm -r $ROMSTARKERNELDIR
		cd $ROMDIR
		. build/envsetup.sh
		lunch aosp_crownlte-userdebug
		mka bacon -j8
}


DATE_START=$(date +"%s")

echo -e "${green}"
echo "YARPIIN Kernel Creation Script:"
echo

echo "---------------"
echo "Kernel Version:"
echo "---------------"

echo -e "${red}"; echo -e "${blink_red}"; echo "$YARPIIN_VER"; echo -e "${restore}";

echo -e "${green}"
echo "-----------------"
echo "Making YARPIIN Kernel:"
echo "-----------------"
echo -e "${restore}"

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to sync repo (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		repo_sync
		echo
		echo "All Synced now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build star2lte Evolution-X Rom (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_star2lte_rom
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build starlte Evolution-X Rom (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_star_rom
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build crownlte Evolution-X Rom (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_crown_rom
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo

