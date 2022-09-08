from importlib.resources import path
import json
from operator import mod
import os
from datetime import datetime
import sys

from Python.Parser.get_data_format import parse_data_format
sys.path.append(os.getcwd())

from tkinter.filedialog import askopenfilename, askdirectory

def compute_cs(str):
    CS1 = 0
    CS2 = 0
    # Fletcher16
    for k in range(len(str)):
        CS1 = CS1 + ord(str[k])
        CS2 = CS2 + CS1

    CS1 = CS1 % 256
    CS2 = CS2 % 256

    return [CS1, CS2]

import numpy as np

class ParsedPath:
    orgFile = ""
    processedFolderDir = ""
    verifiedFile = ""
    ignoredFile = ""
    dictFile = ""

def validate_log_file(flightLogPath = None):
    ret =  ParsedPath()

    if(flightLogPath is None):
        flightLogPath = askopenfilename()

    print("Processing log file ", flightLogPath)

    fileSubFolder = os.path.dirname(flightLogPath)
    fileName = os.path.splitext(os.path.basename(flightLogPath))[0]
    processedFolder = os.path.join(os.getcwd(), fileSubFolder, "Processed_" + fileName)
    ret.processedFolderDir = processedFolder
    
    if(not os.path.isdir(processedFolder)):
        print("Creating new folder ...", processedFolder)
        os.mkdir(processedFolder)
        os.chmod(processedFolder, 0o777)

        orgFilePath = os.path.join(os.getcwd(), fileSubFolder, fileName + ".TXT")
        verifiedFilePath = os.path.join(os.getcwd(), processedFolder, fileName + "_verified.TXT")
        ignoredFilePath = os.path.join(os.getcwd(), processedFolder, fileName + "_ignored.TXT")
        dictFilePath = os.path.join(os.getcwd(), processedFolder, fileName + "_format.json")

        ret.dictFile = dictFilePath
        ret.ignoredFile = ignoredFilePath
        ret.verifiedFile = verifiedFilePath
        ret.orgFile = orgFilePath

        fOrg = open(orgFilePath, "r")
        parse_data_format(orgFilePath, dictFilePath)
        fClean = open(verifiedFilePath, 'w+')
        fWrongCs = open(ignoredFilePath, 'w+')

        lines = fOrg.readlines()
        
        curLine = 0

        
        now = datetime.now()
        current_time = now.strftime("%H:%M:%S")
        print("Start validating file at", current_time)


        for line in lines: 
            curLine += 1

            try:
                y = json.loads('{' + line + '}')        
                cs1 = int(y["CS"][0])
                cs2 = int(y["CS"][1])
                endId = line.find(',"CS"')
                dataStr = line[0:endId]
                [rxCs1, rxCs2] = compute_cs(dataStr)
                isValid = (rxCs1 == cs1) and (rxCs2 == cs2)
                if(isValid):
                    fClean.writelines(dataStr + '\n')

                else:
                    fWrongCs.writelines(line)

            except Exception as e:
                #print("Ignored Line ...")
                #print(e)
                fWrongCs.writelines(line)
        
            if(curLine % 50000 == 0):
                fClean.close()
                fWrongCs.close()
                fClean = open(verifiedFilePath, 'a')
                fWrongCs = open(ignoredFilePath, 'a')

        fClean.close()
        fWrongCs.close()


        now = datetime.now()
        current_time = now.strftime("%H:%M:%S")
        print("End parsing at", current_time)

    else:
        print(processedFolder, "Folder exists. Abort parsing...")
        return None

        
    return ret

if __name__ == "__main__":

    validate_log_file()