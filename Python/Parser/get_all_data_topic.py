from importlib.resources import path
import json
import os
from tkinter.filedialog import askopenfilename, askdirectory
import re
import numpy as np
import pandas as pd
from datetime import datetime

from Python.Parser.get_data_topic import get_data_topic

if __name__ == "__main__":
  
    print("Please choose the directory to be processed")
    formatFilePath = askopenfilename()
    processedDirPath = os.path.dirname(formatFilePath)


    print("Processed files will be put in folder", processedDirPath)

    with open(formatFilePath, 'r') as f:
        content = f.read()
        dictionary = json.loads(content)

    # Read the available data format from the dictionary
    declaredTopicID = []
    formatList = []
    for topic in dictionary:
        key, value = list(topic.items())[0] 
        topicID = key
        topicNumber = int(topicID)
        declaredTopicID.append(key)
        formatList.append(value)

    print("Loaded dictionary. Please choose the clean log files")
    cleanedFilePath = askopenfilename()


    df, name = get_data_topic(cleanedFilePath, formatList[0], declaredTopicID[0])
    
    processedTopicPath = os.path.join(processedDirPath, name + ".csv")
    df.to_csv(processedTopicPath, index = False)
