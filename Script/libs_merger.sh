#!/bin/sh
#合成通用静态库脚本
#author:wei_l@ctrip.com
#为了保证脚本的通用性，请设置 build settings 中的 Installation Directory 为 $(BUILT_PRODUCTS_DIR)。
#脚本运行成功会在工程根目录下生成 lib_products 目录放合成后的静态库。

a_simulator_path="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${EXECUTABLE_NAME}";
a_device_path="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${EXECUTABLE_NAME}";

if [ -e "$a_simulator_path" ]
then
echo "用于模拟器的静态库找到";
else
echo "用于模拟器上的${a_simulator_path}不存在，请检查是否编译成功或者build settings 中的 Installation Directory 是否设置为了 \$(BUILT_PRODUCTS_DIR)";
exit -1;
fi

if [ -e "$a_device_path" ]
then
echo "用于真机的静态库找到";
else
echo "用于真机上的${a_device_path}不存在，请检查是否编译成功或者build settings 中的 Installation Directory 是否设置为了 '\$(BUILT_PRODUCTS_DIR)'";
exit -1;
fi

simupator_create_time=`stat -f%B -t %Y%m%d%H%M ${a_simulator_path}`;
device_create_time=`stat -f%B -t %Y%m%d%H%M ${a_device_path}`;
time_diff=`expr $simupator_create_time - $device_create_time`;
DS=60;
time_diff=`expr $time_diff / $DS`;

echo "simupator_create_time($simupator_create_time) - device_create_time($device_create_time) = $time_diff 分钟";

if [ "${time_diff}" -gt 60 ]
then
echo "用于真机的静态库太旧了，请重新编译用于真机的静态库。";
rm -rdf "${a_device_path}";#因为如果代码没改动静态库不会重编，所以这里先删除掉过期的静态库文件。
exit -1;
elif [ "${time_diff}" -lt -60 ]
then
echo "用于模拟器的静态库太旧了，请重新编译用于模拟器的静态库。";
rm -rdf "${a_simulator_path}";#因为如果代码没改动静态库不会重编，所以这里先删除掉过期的静态库文件。
exit -1;
else
echo "";
fi

cd "${SRCROOT}";
rm -rdf "lib_profucts";
mkdir  "lib_profucts";
cd "lib_profucts";

cp "${a_simulator_path}" "s_${EXECUTABLE_NAME}";
cp "${a_device_path}" "d_${EXECUTABLE_NAME}";

#thin
lipo "s_${EXECUTABLE_NAME}" -thin i386 -output i386.a;
lipo "s_${EXECUTABLE_NAME}" -thin x86_64 -output x86.a;
lipo "d_${EXECUTABLE_NAME}" -thin armv7 -output armv7.a;
lipo "d_${EXECUTABLE_NAME}" -thin arm64 -output arm64.a;

lipo -create x86.a i386.a armv7.a arm64.a -output "${EXECUTABLE_NAME%.*}_release.a";
rm "x86.a" "i386.a" "armv7.a" "arm64.a" "s_${EXECUTABLE_NAME}" "d_${EXECUTABLE_NAME}";

open .;