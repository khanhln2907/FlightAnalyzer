from importlib.resources import path
import json
import os
from tkinter.filedialog import askopenfilename, askdirectory
import re
import numpy as np

import pandas as pd

from Python.Parser.get_data_format import get_format_dict

def get_data_topic(filePath, format, key):
    print("Getting data topic", key, "from file", filePath)
    print("Parsing topic ", format["Name"])
    print("Data format ", format["Data"])

    textfile = open(filePath, 'r')
    filetext = textfile.read()
    textfile.close()
    matches = re.findall(key, filetext)
    nMatches = len(matches)

    dataArr = np.zeros((nMatches, len(format["Data"])))
    i = 0
    with open(filePath, "r") as f:
        for num,line in enumerate(f):
            keyMod = '"' + key + '"'
            if re.findall(keyMod, line):
                decodedVal = json.loads('{' + line.strip() + '}')
                valueArr = decodedVal[key]
                dataArr[i, :] = valueArr
                i += 1

    df = pd.DataFrame(dataArr[0:i, :], columns=format["Data"])
    return df, format["Name"]

def parse_all_data_topic(cleanedFilePath, processedDirPath, formatList, declaredTopicID, saveCSVFolderPath = None):
    if saveCSVFolderPath is not None:
        if(not os.path.isdir(saveCSVFolderPath)):
            os.mkdir(saveCSVFolderPath)

    # TODO: maybe add some try catch here in case some line is corrupt
    for i in range(len(formatList)):
        df, name = get_data_topic(cleanedFilePath, formatList[i], declaredTopicID[i])

        # Save to CSV to be conveniently loaded some where else    
        if saveCSVFolderPath is not None:
            df.to_csv(saveCSVFolderPath, index = False)

if __name__ == "__main__":
  
    print("Please choose the directory to be processed")
    formatFilePath = askopenfilename()
    processedDirPath = os.path.dirname(formatFilePath)


    print("Processed files will be put in folder", processedDirPath)
    declaredTopicID, formatList = get_format_dict(formatFilePath)    

    print("Loaded dictionary. Please choose the clean log files")
    cleanedFilePath = askopenfilename()

    # Parse single
    # df, name = get_data_topic(cleanedFilePath, formatList[0], declaredTopicID[0])
    # processedTopicPath = os.path.join(processedDirPath, name + ".csv")
    # df.to_csv(processedTopicPath, index = False)

    # Parse all
    parse_all_data_topic(cleanedFilePath, processedDirPath, formatList, saveCSVFolderPath = os.path.join(processedDirPath, "CSV"))
