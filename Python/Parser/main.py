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

    # Get the path
    if(logPath is None):
        logPath = askopenfilename()
    fileName = os.path.splitext(os.path.basename(logPath))[0]

    # Validate, ignore CS and undeclared data format    
    pathHandle = validate_log_file(logPath)
    declaredTopicID, formatList = get_format_dict(pathHandle.dictFile)

    # Obtain the logging format and write them as CSV files
    parse_all_data_topic(pathHandle.verifiedFile, pathHandle.processedFolderDir, formatList, declaredTopicID, saveCSVFolderPath = os.path.join(pathHandle.processedFolderDir, "CSV"))

if __name__ == "__main__":
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    print("Start parsing at", current_time)


    # Parse the file
    parse_flight_log()



    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    print("Finish parsing at", current_time)
 