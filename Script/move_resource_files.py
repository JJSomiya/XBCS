# -- coding: utf-8 -*-
#author:gjzwluck@outlook.com

import zipfile
import os
import re
import fnmatch
import itertools
import subprocess
import sys
import csv
import shutil

buSubNameList = ["invest", "news", "stockbar", "market", "trade", "txtrade", "mycenter", "more", "public"]
iSInBuList = [0, 0, 0, 0, 0, 0, 0, 0]
buContentList = ["images", "nibs"]
buProjNameList = ["SBPortMoudle", "SBNewsModule", "SBBarModule", "EMMoudleStockList", "EMModuleTrade", "EMModuleTXTrade", "EMPsptNSelfSel", "EMMoudleMore"]

#代码所在路径 需要设置
codepath = None

#App 所在位置
apppath = None

def findFiles(pattern,path):
    for root, dirnames, filenames in os.walk(path):
        for filename in fnmatch.filter(filenames, pattern):
            filepath = os.path.join(root, filename)
            
            yield filepath;

def isExist(filename,list):
    for value in list:
        if value in filename:
            return 'YES'
    return None



def scanForPattern(pattern, files):
    for sourceFile in files:
        fileHandle = open(sourceFile)
        fileContent = fileHandle.read()
        fileContent = fileContent.lower()
        if fileContent.find(pattern) != -1:
            return True
        elif pattern in fileContent:
            return True
    return False

def judgeFileContain(path,filename):
    sourceFiles = [file for file in itertools.chain(
                                                    findFiles("*.h",path),
                                                    findFiles("*.m",path),
                                                    findFiles("*.xib",path),
                                                    findFiles("*.plist",path),
                                                    findFiles("*.json",path),
                                                    findFiles("*.html",path))]
    
    m = re.match("(.*?)(?:@2x|@3x|~iphone|~ipad)*(?:\.png|\.gif|\.jpg|\.xib|\.xml|\.json|\.plist|\.html){1}", filename)
    
    if m:
        pattern = m.group(1)
        if scanForPattern(pattern.split('/')[-1], sourceFiles):
            return True
    return False


def analyze_apk():

    for filename in os.listdir(apppath):
        FileName = filename
        filename = filename.lower()
        if isExist(filename,['.png','.jpg','.gif']):
            if judgeFileContain(codepath,filename) == False:
                print FileName;

#def findImagePathList():
#    for parent,dirnames,filenames in os.walk(os.path.join(codepath,"Image")):
#        listPath = []
#        for dirname in dirnames:
#            listPath.apppath(os.path.join(parent,dirname))
#    return listPath


def mkImagesDir():
    
    #判断目录是否存在，存在删除
    if os.path.exists(codepath + "/EMResources"):
        shutil.rmtree(codepath + "/EMResources")

    #在Codepath下  声成EMResources目录
    os.makedirs(codepath + "/EMResources")
    #循环生成Bu子目录
    for i in buSubNameList:
        os.makedirs(codepath + "/EMResources" + "/" + i)
        #循环生成资源目录
        for j in buContentList:
            os.makedirs(codepath + "/EMResources" + "/" + i + "/" +j)

def findClass(fileName):
    listClass = [".png",".jpg",".gif",".xib"] #这要和buContentList顺序对应
    for i,j in enumerate(listClass):
        if j in fileName:
            if i < 3:
                return 0
            else :
                return i - 2
    return 0




def findAndcopy():
    #执行目录生成算法
    mkImagesDir()
    #进入apppath目录，循环搜索

    for parent,dirnames,filenames in os.walk(apppath):    
    #三个参数：分别返回1.父目录 2.所有文件夹名字（不含路径） 3.所有文件名字
        for filename in filenames:
            # print "父目录:" + parent
            # print "文件名:" + filename
            # print os.path.join(parent,filename)
            FileName = filename
            filename = filename.lower()
            if isExist(filename,['.png','.jpg','.gif','.xib']):
                if isExist(filename, ['.svn']):
                    continue
                srcPath = os.path.join(parent,FileName)
                iSInBuList = [0, 0, 0, 0, 0, 0, 0, 0]

                #判断图片,到各个Bu目录去搜索（codePath+"/"+buProjNameList[i]）
                for i, j in enumerate(buProjNameList):
                    # print "iSInBuList%i = %i" %(i, iSInBuList[i])
                    #如果第i个工程用到了该文件，则iSInBuList第i个位置设为1
                    if judgeFileContain(codepath + "/" + buProjNameList[i],filename):
                        # print buProjNameList[i] + "用到了该文件"
                        iSInBuList[i] = 1

                n = 0 #拥有该文件的工程个数
                d = 0 #拥有该文件的工程在列表buProjNameList或iSInBuList中的位置
                for k, m in enumerate(iSInBuList):
                    # print "m = %i" %m
                    n = n + m
                    if m > 0:
                        d = k

                # print "%i个工程用到了该文件" % n
                index = -1
                index = findClass(FileName)
                if n != 1:
                    d = -1

                destinationPath = "/EMResources" + "/" + buSubNameList[d] + "/" + buContentList[index]
                print srcPath.replace(apppath,"") + " ==> " + destinationPath
                shutil.copy(srcPath,codepath+destinationPath)

                    


def main(argv):
    global codepath
    global apppath
    if len(argv) >= 1:
        codepath = argv[0]
        apppath = codepath + "/EMMain/Resources"
    if codepath == None:
        print '请输入codepath(代码路径，根目录)'
        return;
    #analyze_apk()
    findAndcopy()


if __name__ == '__main__':
    main(sys.argv[1:])