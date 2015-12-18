#!/bin/sh

if [ $# -lt 1 ]; then
	echo "代码路径，参考（../）"
	exit
fi

codePath="$1"

set -e
set -o pipefail


FAST_BUILD="NO"
if [[ -e ~/.embuild.settings ]]; then
FAST_BUILD=$(cat ~/.embuild.settings)
fi

if [[ $FAST_BUILD = "YES" ]]; then
echo "${EXECUTABLE_NAME} in fast build"
#删除原有库
if [[ -e $codePath/EMCompileEnv/Library/$EXECUTABLE_FOLDER_PATH ]]; then
rm -rf $codePath/EMCompileEnv/Library/$EXECUTABLE_FOLDER_PATH
fi
cp -rf $BUILT_PRODUCTS_DIR/$EXECUTABLE_FOLDER_PATH $codePath/EMCompileEnv/Library
exit 0
fi

#cp -rf $BUILT_PRODUCTS_DIR/EMPsptNSelfSel.framework $SRCROOT/../EMCompileEnv/Library
SDK_VERSION=$(echo ${SDK_NAME} | grep -o '.\{3\}$')

# Next, work out if we're in SIM or DEVICE

if [ ${PLATFORM_NAME} = "iphonesimulator" ]
then
OTHER_SDK_TO_BUILD=iphoneos${SDK_VERSION}
else
OTHER_SDK_TO_BUILD=iphonesimulator${SDK_VERSION}
fi

echo "###################################"
echo "CONFIGURATION_BUILD_DIR=${CONFIGURATION_BUILD_DIR}"
echo "###################################"

echo "XCode has selected SDK: ${PLATFORM_NAME} with version: ${SDK_VERSION} (although back-targetting: ${IPHONEOS_DEPLOYMENT_TARGET})"
echo "...therefore, OTHER_SDK_TO_BUILD = ${OTHER_SDK_TO_BUILD}"

if [ "true" == ${ALREADYINVOKED:-false} ]
then
echo "RECURSION: I am NOT the root invocation, so I'm NOT going to recurse"
else
# CRITICAL:
# Prevent infinite recursion (Xcode sucks)
export ALREADYINVOKED="true"

ACTION="clean"

echo "RECURSION: I am the root ... recursing all missing build targets NOW..."
echo "RECURSION: ...about to invoke: xcodebuild -configuration \"${CONFIGURATION}\" -project \"${PROJECT_NAME}.xcodeproj\" -target \"${TARGET_NAME}\" -sdk \"${OTHER_SDK_TO_BUILD}\" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO" BUILD_DIR=\"${BUILD_DIR}\" BUILD_ROOT=\"${BUILD_ROOT}\" SYMROOT=\"${SYMROOT}\"

# 这里我另外设置了 ONLY_ACTIVE_ARCH=NO VALID_ARCHS="armv7s armv7 i386"
xcodebuild ONLY_ACTIVE_ARCH=NO VALID_ARCHS="armv7 i386 arm64 x86_64"  -configuration "${CONFIGURATION}" -project "${PROJECT_NAME}.xcodeproj" -target "${TARGET_NAME}" -sdk "${OTHER_SDK_TO_BUILD}" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" SYMROOT="${SYMROOT}"

ACTION="build"

echo "RECURSION: I am the root ... recursing all missing build targets NOW..."
echo "RECURSION: ...about to invoke: xcodebuild -configuration \"${CONFIGURATION}\" -project \"${PROJECT_NAME}.xcodeproj\" -target \"${TARGET_NAME}\" -sdk \"${OTHER_SDK_TO_BUILD}\" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO" BUILD_DIR=\"${BUILD_DIR}\" BUILD_ROOT=\"${BUILD_ROOT}\" SYMROOT=\"${SYMROOT}\"

# 这里我另外设置了 ONLY_ACTIVE_ARCH=NO VALID_ARCHS="armv7s armv7 i386"
xcodebuild ONLY_ACTIVE_ARCH=NO VALID_ARCHS="armv7 i386 arm64 x86_64"  -configuration "${CONFIGURATION}" -project "${PROJECT_NAME}.xcodeproj" -target "${TARGET_NAME}" -sdk "${OTHER_SDK_TO_BUILD}" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" SYMROOT="${SYMROOT}"


#Merge all platform binaries as a fat binary for each configurations.

# Calculate where the (multiple) built files are coming from:

# 为了兼容自动编译
MHG_THIS_BUILD_DIR=${CONFIGURATION_BUILD_DIR}

if [ ${PLATFORM_NAME} = "iphonesimulator" ]
then
MHG_OTHER_BUILD_DIR=${SYMROOT}/${CONFIGURATION}-iphoneos
else
MHG_OTHER_BUILD_DIR=${SYMROOT}/${CONFIGURATION}-iphonesimulator
fi

echo "Taking device build from: ${CURRENTCONFIG_DEVICE_DIR}"
echo "Taking simulator build from: ${CURRENTCONFIG_SIMULATOR_DIR}"

CREATING_UNIVERSAL_DIR=${SYMROOT}/${CONFIGURATION}-universal
echo "...I will output a universal build to: ${CREATING_UNIVERSAL_DIR}"

# ... remove the products of previous runs of this script
#      NB: this directory is ONLY created by this script - it should be safe to delete!

rm -rf "${CREATING_UNIVERSAL_DIR}"
mkdir "${CREATING_UNIVERSAL_DIR}"
echo "lipo: for current configuration (${CONFIGURATION}) creating output file: ${CREATING_UNIVERSAL_DIR}/${EXECUTABLE_NAME}"

echo "EXECUTABLE_PATH=${EXECUTABLE_PATH}"
echo "EXECUTABLE_FOLDER_PATH=${EXECUTABLE_FOLDER_PATH}"

if [ -d "${MHG_THIS_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}" ]
then
# 随便拷个版本进去
cp -rf "${MHG_THIS_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}" "${CREATING_UNIVERSAL_DIR}"

# 删除里面的二进制文件
rm "${CREATING_UNIVERSAL_DIR}/${EXECUTABLE_PATH}"

# 生成universal的二进制文件
lipo -create -output "${CREATING_UNIVERSAL_DIR}/${EXECUTABLE_PATH}" "${MHG_THIS_BUILD_DIR}/${EXECUTABLE_PATH}" "${MHG_OTHER_BUILD_DIR}/${EXECUTABLE_PATH}"

if [ -d "${CREATING_UNIVERSAL_DIR}/${EXECUTABLE_FOLDER_PATH}" ]
then
# 拷贝到财富通的编译环境目录
cp -rf "${CREATING_UNIVERSAL_DIR}/${EXECUTABLE_FOLDER_PATH}" $codePath/EMCompileEnv/Library
else
echo "warning: generate universal framework failed"
cp -rf "${CONFIGURATION_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}" "${CREATING_UNIVERSAL_DIR}"
fi
fi
fi