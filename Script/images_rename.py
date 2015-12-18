# -- coding: utf-8 -*-

import zipfile
import os
import re
import fnmatch
import itertools
import subprocess
import sys
import csv


#代码所在路径 需要设置
codepath = '../'
disList = ['invest','news','stockbar','market','trade','txtrade','mycenter','more','main','common']
disProjectName = ['SBPortMoudle','SBNewsModule','SBBarModule','EMMoudleStockList','EMModuleTrade','EMModuleTXTrade','EMPsptNSelfSel','EMMoudleMore','EMMain','EMBusiness']
disNameList = ['投资组合','咨询','股吧','股票详情','交易','同信交易','个人中心','更多','主工程','Business']

def findFiles(pattern,path):
    for root, dirnames, filenames in os.walk(path):
        for filename in fnmatch.filter(filenames, pattern):
            filepath = os.path.join(root, filename)
            
            yield filepath;



def renameBU(imagename,position):
    sourceFiles = [file for file in itertools.chain(
                                                    findFiles("*.h",codepath),
                                                    findFiles("*.m",codepath),
                                                    findFiles("*.xib",codepath),
                                                    findFiles("*.json",codepath),
                                                    findFiles("*.xml",codepath),
                                                    findFiles("*.css",codepath),
                                                    findFiles("*.yaml",codepath),
                                                    findFiles("*.fragment",codepath),
                                                    findFiles("*.js",codepath),
                                                    findFiles("*.fragment",codepath),
                                                    findFiles("*.html",codepath),
                                                    )]
    isFind = False
    for file in sourceFiles:
        fileHandle = open(file)
        fileContent = fileHandle.read()
        fileHandle.close()
        
        if imagename in fileContent:
            isFind = True
    
        write_project_file = open(file,'w')
        
        if disList[position]+"_"+imagename in fileContent:
            write_project_file.write(fileContent);
            write_project_file.close()
            continue
        else:
            fileContent = fileContent.replace(imagename,disList[position]+"_"+imagename)
        
        write_project_file.write(fileContent);
        write_project_file.close()

    return isFind

def replaceProject(imagename, position,imagewithextension):
    sourceFiles = [file for file in itertools.chain(
                                                    findFiles("*.pbxproj",codepath))]

    isFind = False
    for file in sourceFiles:
        fileHandle = open(file)
        fileContent = fileHandle.read()
        fileHandle.close()

        write_project_file = open(file,'w')
        
        if disList[position]+"_"+imagewithextension in fileContent:
            write_project_file.write(fileContent);
            write_project_file.close()
            isFind = True
            continue
        else:
            fileContent = fileContent.replace(imagewithextension,disList[position]+"_"+imagewithextension)
        
        write_project_file.write(fileContent);
        write_project_file.close()

    return isFind


def renmaeBUResource(position):
    
    imageSourceFiles = [file for file in itertools.chain(
                            findFiles("*.png",codepath),
                            findFiles("*.jpg",codepath),
                            findFiles("*.gif",codepath)
                        )]
                        
    write_deal_file = open('logs.txt','w')
    
    contentOfDeal = ""
    contentOfUnDeal = ""
    for image in imageSourceFiles:
        imagePath = image
        image = image.split('/')[-1]
        imageRename = imagePath.replace(image,disList[position]+"_"+image)
        print image
        if image.startswith(disList[position]):
            continue
        m = re.match("(.*?)(?:@2x|@3x|~iphone|~ipad)*(?:\.png|\.gif|\.jpg){1}", image)
        if m:
            pattern = m.group(1)
            if renameBU(pattern, position) == True:
                if replaceProject(pattern, position,image) == True:
                    if image.startswith(disList[position]+'_'):
                        contentOfDeal = contentOfDeal + image+ " 修改为 " + disList[position]+"_"+image + " －－－需手动处理工程文件" + '\n'
                    else:
                        contentOfDeal = contentOfDeal + image+ " 修改为 " + disList[position]+"_"+image + " －－－需手动处理工程文件" + '\n'
                        tool_line = 'mv  '+ imagePath + ' ' + imageRename
                        os.system(tool_line)
                else:
                    if image.startswith(disList[position]+'_'):
                        contentOfDeal = contentOfDeal + image+ " 修改为 " + disList[position]+"_"+image + '\n'
                    else:
                        contentOfDeal = contentOfDeal + image+ " 修改为 " + disList[position]+"_"+image + '\n'
                        tool_line = 'mv  '+ imagePath + ' ' + imageRename
                        os.system(tool_line)
            else:
                contentOfUnDeal = contentOfUnDeal + image+'\n'
        else:
            contentOfUnDeal = contentOfUnDeal + image+'\n'
                
    write_deal_file.write("已处理图片:\n")
    write_deal_file.write(contentOfDeal)
    write_deal_file.write("需确认图片:\n")
    write_deal_file.write(contentOfUnDeal)
    write_deal_file.close()



def analyze_apk():
    global codepath
    i = 0
    for buname in disNameList:
        print buname,": ",disList[i]
        i = i + 1
    
    print '请选择：(如“投资组合”，输入“invest”)'
    choseBuname = None
    position = 0;
    while 1 :
        choseBuname = raw_input("input:\n")
        breakYES = False
        position = 0
        for bunamesup in disList:
            if cmp(choseBuname,bunamesup) == 0 :
                breakYES = True
                break
            position = position + 1
        if breakYES == True:
            break
    codepath = codepath + disProjectName[position]
    renmaeBUResource(position)



def main():
    analyze_apk()
#    analyze_apk('Ctrip_Wireless_View_V5.8_SIT7_BAOLEI_final.apk')
#    analyze_apk('Ctrip_V5.7_8003.apk')


if __name__ == '__main__':
    main()