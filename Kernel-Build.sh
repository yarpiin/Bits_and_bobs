#!/bin/bash

# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
KERNEL="Image"
DTBIMAGE="dtb.img"
STARDEFCONFIG="exynos9810-starlte_defconfig"
STARPERM_DEFCONFIG="perm_exynos9810-starlte_defconfig"
STAR2DEFCONFIG="yarpiin_defconfig"
STAR2PERM_DEFCONFIG="perm_yarpiin_defconfig"
KERNEL_DIR="/home/yarpiin/Android/Kernel/SGS9/White-Wolf-SGS9-TW-ELS"
RESOURCE_DIR="$KERNEL_DIR/.."
KERNELFLASHER_DIR="/home/yarpiin/Android/Kernel/SGS9/KernelFlasher"
TOOLCHAIN_DIR="/home/yarpiin/Android/Toolchains"

# Kernel Details
BASE_YARPIIN_VER="WHITE.WOLF.UNI.PIE"
VER=".023"
PERM=".PERM"
AOSP=".AOSP"
LOS=".LOS"
LOSVER=".007"
YARPIIN_VER="$BASE_YARPIIN_VER$VER"
YARPIIN_PERM_VER="$BASE_YARPIIN_VER$VER$PERM"
YARPIIN_LOS_VER="$BASE_YARPIIN_VER$LOS$LOSVER"
YARPIIN_AOSP_VER="$BASE_YARPIIN_VER$AOSP$LOSVER"

# Vars
export LOCALVERSION=-`echo $YARPIIN_VER`
export CROSS_COMPILE="$TOOLCHAIN_DIR/aarch64-linux-gnu/bin/aarch64-linux-gnu-"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=yarpiin
export KBUILD_BUILD_HOST=kernel

# Paths
TOOLCHAIN_DIR="/home/yarpiin/Android/Toolchains"
SGS9KERNELDIR="/home/yarpiin/Android/Kernel/SGS9/White-Wolf-SGS9-TW-ELS"
SGS9LOSKERNELDIR="/home/yarpiin/Android/Kernel/SGS9/White-Wolf-SGS9-LOS"
N9KERNELDIR="/home/yarpiin/Android/Kernel/N9/White-Wolf-N9-TW-Pie-ELS"
N9LOSKERNELDIR="/home/yarpiin/Android/Kernel/N9/White-Wolf-N9-LOS"
KERNELFLASHER_DIR="/home/yarpiin/Android/Kernel/SGS9/KernelFlasher"
LOSFLASHER_DIR="/home/yarpiin/Android/Kernel/SGS9/LosFlasher"
AOSPFLASHER_DIR="/home/yarpiin/Android/Kernel/SGS9/AOSPFlasher"
ZIP_MOVE="/home/yarpiin/Android/Kernel/SGS9/Zip"
ZIMAGE_DIR="$KERNEL_DIR/arch/arm64/boot"

# Functions
function clean_all {

		cd $SGS9KERNELDIR
		echo
		make clean && make mrproper

		cd $SGS9LOSKERNELDIR
		echo
		make clean && make mrproper

		cd $N9KERNELDIR
		echo
		make clean && make mrproper

		cd $N9LOSKERNELDIR
		echo
		make clean && make mrproper
}

function make_SGS9_kernel {

		cd $SGS9KERNELDIR
		#!/bin/bash 
		/home/yarpiin/Android/Kernel/SGS9/White-Wolf-SGS9-TW-ELS/yarpiin-build.sh
}

function make_crown_kernel {

		cd $N9KERNELDIR
		#!/bin/bash 
		/home/yarpiin/Android/Kernel/N9/White-Wolf-N9-TW-Pie-ELS/yarpiin-build.sh
}

function make_sgs_los_kernel {

		cd $SGS9LOSKERNELDIR
		#!/bin/bash 
		/home/yarpiin/Android/Kernel/SGS9/White-Wolf-SGS9-LOS/yarpiin-build.sh
}

function make_crown_los_kernel {

		cd $N9LOSKERNELDIR
		#!/bin/bash 
		/home/yarpiin/Android/Kernel/N9/White-Wolf-N9-LOS/yarpiin-build.sh
}

function make_zip {
		cd $KERNELFLASHER_DIR
		zip -r9 `echo $YARPIIN_VER`.zip *
		mv  `echo $YARPIIN_VER`.zip $ZIP_MOVE

}

function make_Permissive_zip {
		cd $KERNELFLASHER_DIR
		zip -r9 `echo $YARPIIN_PERM_VER`.zip *
		mv  `echo $YARPIIN_PERM_VER`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}

function make_los_zip {
		cd $LOSLASHER_DIR
		zip -r9 `echo $YARPIIN_LOS_VER`.zip *
		mv  `echo $YARPIIN_LOS_VER`.zip $ZIP_MOVE

}

function make_aosp_zip {
		cd $AOSPFLASHER_DIR
		zip -r9 `echo $YARPIIN_AOSP_VER`.zip *
		mv  `echo $YARPIIN_AOSP_VER`.zip $ZIP_MOVE

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

while read -p "Do you want to build S9 kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_SGS9_kernel
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

while read -p "Do you want to build N9 kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_crown_kernel
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

while read -p "Is kernel to be zipped permissive (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_Permissive_zip
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

while read -p "Do you want to zip kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_zip
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

while read -p "Do you want to build S9 LOS kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_sgs_los_kernel
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

while read -p "Do you want to build N9 LOS kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_crown_los_kernel
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

while read -p "Do you want to zip LOS kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_los_zip
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

while read -p "Do you want to zip AOSP kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_aosp_zip
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

