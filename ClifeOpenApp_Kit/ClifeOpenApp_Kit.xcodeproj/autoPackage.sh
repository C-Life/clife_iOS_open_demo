
#!/usr/bin/env bash
# name: admin
 
echo "~~~~~~~~~~~~~~~~开始执行脚本~~~~~~~~~~~~~~~~"
#开始时间
beginTime=`date +%s`
DATE=`date '+%Y-%m-%d-%T'`
#需要编译的 targetName
TARGET_NAME="AirConditioner"
#编译模式 工程默认有 Debug Release
CONFIGURATION_TARGET=Release
#编译路径
BUILDPATH=/Users/YY/Documents/iOS/het/AirConditioner_Pakistan/${TARGET_NAME}
#archivePath
ARCHIVEPATH=${BUILDPATH}/${TARGET_NAME}.xcarchive
#输出的ipa目录
IPAPATH=/Users/YY/Desktop/
 
#导出ipa 所需plist
ADHOCExportOptionsPlist=${ARCHIVEPATH}/Info.plist
 
ExportOptionsPlist=${ADHOCExportOptionsPlist}
 
# 是否上传蒲公英
UPLOADPGYER=false
 
# git项目分支号
breach=v2.0.0
 
# git clone -b $breach 项目git地址
 
 
echo "~~~~~~~~~~~~~~~~开始构建~~~~~~~~~~~~~~~~~~~"
#开始构建
xcodebuild archive -workspace ${TARGET_NAME}.xcworkspace \
-scheme ${TARGET_NAME} \
-archivePath ${ARCHIVEPATH} \
-configuration ${CONFIGURATION_TARGET}
 
echo "~~~~~~~~~~~~~~~~检查是否构建成功~~~~~~~~~~~~~~~~~~~"
# xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if [ -d "$ARCHIVEPATH" ]
then
echo "构建成功......"
else
echo "构建失败......"
rm -rf $BUILDPATH
exit 1
fi
endTime=`date +%s`
ArchiveTime="构建时间$[ endTime - beginTime ]秒"
 
 
echo "~~~~~~~~~~~~~~~~导出ipa~~~~~~~~~~~~~~~~~~~"
 
beginTime=`date +%s`
 
xcodebuild -exportArchive \
-archivePath ${ARCHIVEPATH} \
-exportOptionsPlist ${ExportOptionsPlist} \
-exportPath ${IPAPATH}
 
echo "~~~~~~~~~~~~~~~~检查是否成功导出ipa~~~~~~~~~~~~~~~~~~~"
IPAPATH=${IPAPATH}/${TARGET_NAME}.ipa
if [ -f "$IPAPATH" ]
then
echo "导出ipa成功......"
else
echo "导出ipa失败......"
# 结束时间
endTime=`date +%s`
echo "$ArchiveTime"
echo "导出ipa时间$[ endTime - beginTime ]秒"
exit 1
fi
 
endTime=`date +%s`
ExportTime="导出ipa时间$[ endTime - beginTime ]秒"
 
    # 上传蒲公英
if [ $UPLOADPGYER = true ]; then
    echo "~~~~~~~~~~~~~~~~上传ipa到蒲公英~~~~~~~~~~~~~~~~~~~"
    curl -F "file=@$IPAPATH" \
    -F "uKey=9c86dd6f*******d7d784e841d91" \
    -F "_api_key=220fd5e840f******bdb80e2e80" \
    -F "password=蒲公英密码" \
    https://www.pgyer.com/apiv1/app/upload
 
    if [ $? = 0 ]
    then
	echo -e "\n"
        echo "~~~~~~~~~~~~~~~~上传蒲公英成功~~~~~~~~~~~~~~~~~~~"
    else
	echo -e "\n"
        echo "~~~~~~~~~~~~~~~~上传蒲公英失败~~~~~~~~~~~~~~~~~~~"
    fi
fi
 
 
 
echo "~~~~~~~~~~~~~~~~配置信息~~~~~~~~~~~~~~~~~~~"
echo "开始执行脚本时间: ${DATE}"
echo "编译模式: ${CONFIGURATION_TARGET}"
echo "导出ipa配置: ${ExportOptionsPlist}"
echo "打包文件路径: ${ARCHIVEPATH}"
echo "导出ipa路径: ${IPAPATH}"
 
echo "$ArchiveTime"
echo "$ExportTime"
exit 1