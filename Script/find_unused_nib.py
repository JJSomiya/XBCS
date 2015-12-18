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
codepath = None

#App 所在位置
apppath = None

def findFiles(pattern,path,name):
    for root, dirnames, filenames in os.walk(path):
        for filename in fnmatch.filter(filenames, pattern):
            if cmp(name.split('.')[0].lower(),filename.split('.')[0].lower())==0:
                continue;

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
                                                    findFiles("*.h",path,filename),
                                                    findFiles("*.m",path,filename),
                                                    findFiles("*.plist",path,filename),
                                                    findFiles("*.json",path,filename),
                                                    findFiles("*.html",path,filename))]
    
    m = re.match("(.*?)(?:~iphone|~ipad)*\.nib", filename)
    
    if m:
        pattern = m.group(1)
        print pattern
        if scanForPattern(pattern.split('/')[-1], sourceFiles):
            return True
    return False


def analyze_apk():
    
    
    appPath = apppath
    
    for filename in os.listdir(appPath):
        FileName = filename
        filename = filename.lower()
        if isExist(filename,['.nib']):
            if judgeFileContain(codepath,filename) == False:
                print FileName;


def main(argv):
    global codepath
    global apppath
    if len(argv) >= 2:
        codepath = argv[0]
        apppath = argv[1]
    if codepath == None:
        print '请输入codepath(代码路径，根目录)和 apppath（.app的路径，.ipa需手动解压，路径不包括.app文件名）'
        return;
    analyze_apk()


if __name__ == '__main__':
    main(sys.argv[1:])