import sys
import os
sys.path.append(os.getcwd())
import json
from tkinter.filedialog import askopenfilename, askdirectory
import re
import numpy as np
import pandas as pd
import datetime

from Python.Parser.get_data_format import get_format_dict
from Python.Parser.get_data_topic import parse_all_data_topic
from Python.Parser.validate_checksum import validate_log_file



def parse_flight_log(logPath = None):
    print("Start parsing log file", logPath)

    # Get the path
    if(logPath is None):
        logPath = askopenfilename()
    
    # Validate, ignore CS and undeclared data format    
    pathHandle = validate_log_file(logPath)

    # Parse the file only if they are not yet parsed...
    if pathHandle is not None:
        declaredTopicID, formatList = get_format_dict(pathHandle.dictFile)

        # Obtain the logging format and write them as CSV files
        parse_all_data_topic(pathHandle.verifiedFile, formatList, declaredTopicID, saveCSVFolderPath = os.path.join(pathHandle.processedFolderDir, "CSV"))

def parse_flight_log_folder(folderPath = None):
    import glob
    # Get the path
    if(folderPath is None):
        folderPath = askdirectory()
    logFilesPath = glob.glob(os.path.join(folderPath, '**','LOG**.TXT'), recursive=False)
    print("Log files to be parsed: ", logFilesPath)

    for filePath in logFilesPath:
        parse_flight_log(filePath)

if __name__ == "__main__":
    now = datetime.datetime.now()
    current_time = now.strftime("%H:%M:%S")
    print("Start parsing folder at", current_time)

    # Parse the file
    #parse_flight_log()
    parse_flight_log_folder()

    now = datetime.datetime.now()
    current_time = now.strftime("%H:%M:%S")
    print("Finish parsing at", current_time)
 