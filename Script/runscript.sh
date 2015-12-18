#!/bin/sh

#声明数组


function delete1XImages() {
	tmpFileName="tmp_xx.tmp";
	cwd=`pwd`;
	for file in `ls`;
	do
		if [[ $file == *png* ]] && [[ $file != *@* ]]; then
			if [ -f "$file" ]; then
				mv "$file" "$tmpFileName";
				fName=${file%.*};
				# echo "check 文件：$file, fName:$fName, safe_file=$safe_file,pattern==$pattern";
				csa=`find . -name ${fName}@2x.png`
				csb=`find . -name ${fName}@3x.png`
				if [ -n "$csa" ] || [ -n "$csb" ]; then
					echo "需要删除1倍图片:""$file";
					rm "$tmpFileName";
				else
				 	mv "$tmpFileName" "$file";
				fi
			fi;
		fi

	done
}



echo "执行runscript--SRC_DIR=${SRCROOT}, BUILD_DIR=${BUILD_DIR}"
SDKRoot="${SDKROOT}"

CopyFileList="ttf|nib|png|jpg|gif|jpeg|plist|db|xml|json|storyboardc|car"
IgnoreFileList="Info.plist"
#echo "$SDKRoot" | grep -q "iPhoneOS" && echo "include" ||echo "not"
echo "***************************开始处理子工程资源***************************"
TARGET_PLATFORM="none";
if  echo "$SDKRoot" | grep -q "iPhoneOS"
then
TARGET_PLATFORM="iphoneos"
else
TARGET_PLATFORM="iphonesimulator"
fi

echo "当前SDK平台:${TARGET_PLATFORM}"

echo "通用编译"
cd "$BUILD_DIR/$CONFIGURATION-$TARGET_PLATFORM"

for file1 in `ls`
	do
	if echo "$file1" | grep -q "bundle"
	then
		echo "***检查[$file1], 复制资源中的文件到app中***"

		for item_path in ./$file1/* # `find "$file1" -name "*[${CopyFileList}]" | grep -E  "$CopyFileList" | grep -v "$IgnoreFileList"`
			do
				item_file_name=${item_path##*/};
				item_file_sufix=${item_path##*.};
				# echo "item_file_sufix==${item_file_sufix}"
				item_dest_path="${CONTENTS_FOLDER_PATH}/${item_file_name}";
				file_path="${file1}/${item_file_name}";
				if [ "$item_file_name" == "$IgnoreFileList" ]; then
					va="x" #echo "Info.plist here, ignore";
				elif [ -f "$file_path" ] || [ -d "$file_path" ]; then
					rm -rf "$item_dest_path";
					cp -rf "$file_path" "$item_dest_path";
					#mv $file_path ${file_path%.*}".moved"
				fi
			done
	fi
	done

if  echo "$CONFIGURATION" | grep -q "Release"
then

cd "${SRCROOT}";
cd ..;
cd "Script"

#获取没用到的文件名单数组
if [ ! -f "./IgnoreResource.list" ]; then
    echo "忽略文件不存在"
else
    ignoreArray=()
    ignoreArray=`cat ./IgnoreResource.list`
fi


cd "$BUILD_DIR/$CONFIGURATION-$TARGET_PLATFORM"


for file1 in `ls`
    do
    if echo "$file1" | grep -q "app"
    then

        for item_path in ./$file1/*
        do
            item_file_name=${item_path##*/};
            item_file_sufix=${item_path##*.};

            #如果是没用到的文件则跳过
            if [[ "${ignoreArray[@]}" =~ $item_file_name ]]
            then
                rm -rf $item_path
                echo "已忽略无用文件 $item_file_name"
                continue
            fi

            cd "${SRCROOT}";
            cd ..;
            cd "Script/image_suppress"

            image_absolute_path="$BUILD_DIR/$CONFIGURATION-$TARGET_PLATFORM/$file1/$item_file_name"
            if [[ $item_path == *.png ]]; then
            `./optipng -strip all -quiet -clobber -o3 "$image_absolute_path" -out "$image_absolute_path"`
            elif [[ $item_path == *.jpg ]]; then
            `./jpegtran -copy none -optimize -progressive -outfile "$image_absolute_path" "$image_absolute_path"`
            elif [[ $item_path == *.gif ]]; then
            `./gifsicle -O3 --careful --no-comments --no-names --same-delay --same-loopcount --no-warnings  -o "$image_absolute_path" "$image_absolute_path"`
            fi
            cd "$BUILD_DIR/$CONFIGURATION-$TARGET_PLATFORM"
        done
    fi


    done
fi

cd ..;
echo "***************************结束处理子工程资源***************************"
