# -- coding: utf-8 -*-
#author:thomas

import zipfile
import os
import re
import fnmatch
import itertools
import subprocess
import sys
import csv
import shutil
 
#代码路径
codepath = None
#类名集合
class_names = []
#出现次数
times = 0
#过滤的工程目录
filter_project = ['3rd_libs','EMCompileEnv','Script','WorkDocuments']

#
def isExist(filename,list):
    for value in list:
        if value in filename:
            return 'YES'
    return None

#去掉.h .m
def pureFileName(filename):
    pure_name = filename.replace('.h', '')
    pure_name = pure_name.replace('.m', '')

    return pure_name

#所在的根文件夹
def rootSrcDocument(srcPath):
    documentNames = srcPath.split('/')
    codepathNames = codepath.split('/')
    
    #路径最后一个
    if codepathNames[-1] == '':
        lastCodepathName = codepathNames[-2]
    else:
        lastCodepathName = codepathNames[-1]


    index = documentNames.index(lastCodepathName)

    if index < len(documentNames) - 1:
        return documentNames[index + 1]
    else:
        return documentNames[index]
        
    return ''


#文件中是否存在过类名 有即返回True
def existNameInFile(class_name, filename):
    with open(filename,'r') as foo:
        for line in foo.readlines():
            if class_name in line:
                return 'True'
    return 'False'




#遍历工程中的文件里面有没有类名
def isUsedInterfaceName(class_name, origin_filename,origin_srcPath):

    flag = 0
    documentDictionary = {}
    for parent,dirnames,filenames in os.walk(codepath):    
    #三个参数：分别返回1.父目录 2.所有文件夹名字（不含路径） 3.所有文件名字
        if isNeedFiltered(parent) == 'True':
            continue
        if '.svn' in parent:
            continue
        for filename in filenames:

            #print "父目录:" + parent
            #print "文件名:" + filename

            #只搜索.h
            if isExist(filename, ['.h','m','.json']):
                
                #缓存文件
                if isExist(filename, ['.swpa']):
                    continue
                
                # 判断当前文件是不是搜索的类所在的头文件或实现文件
                if pureFileName(filename) == pureFileName(origin_filename):
                    continue
            
                srcPath = os.path.join(parent,filename)
                if existNameInFile(class_name, srcPath) == 'True':
                    flag += 1
                    if flag > times:
                        return
    
    filerootpath = rootSrcDocument(origin_srcPath)
    if flag == 0:
        print filerootpath + ":" + origin_filename + ":" + class_name
    else:
        print filerootpath + ":" + origin_filename + ":" + class_name + ":" + str(v)

#过滤掉一些工程或者文件夹
def isNeedFiltered(srcPath):
    project_document_name = rootSrcDocument(srcPath)
    if project_document_name != '':
        for projectName in filter_project:
            if project_document_name == projectName:
                return 'True'
    return 'False'


#找出用不到的interface
def findUnusedInterface():
    #类名汇总
    for parent,dirnames,filenames in os.walk(codepath):    
    #三个参数：分别返回1.父目录 2.所有文件夹名字（不含路径） 3.所有文件名字
        if isNeedFiltered(parent) == 'True':
            continue
        if '.svn' in parent:
            continue
        
        for filename in filenames:

            #只搜索.h
            if isExist(filename,['.h']):
                srcPath = os.path.join(parent,filename)
                kw = '@interface' #--------------------要查询的字符串
                with open(srcPath,'r') as foo:
                    for line in foo.readlines():
                        if kw in line:
                            #正则，找出类名
                            res = re.match('@interface(.*)[:]', line)
                            if res:
                                class_name = res.group(1)
                                class_name = class_name.replace(' ','')
                                isUsedInterfaceName(class_name, filename,srcPath)


def main(argv):
    global codepath
    global times
    if len(argv) >= 1:
        codepath = argv[0]

    if len(argv) >= 2:
        times = int(argv[1])

    #目录
    if codepath == None:
        print '请输入codepath(代码路径，根目录)'
        return;
    
    findUnusedInterface()


if __name__ == '__main__':
    main(sys.argv[1:])