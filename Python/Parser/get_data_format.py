import numpy as np
import json
from tkinter.filedialog import askopenfilename, askdirectory
import os

def search_string_in_file(file_name, string_to_search, nMax = 1):
    """Search for the given string in file and return lines containing that string,
    along with line numbers"""
    line_number = 0
    list_of_results = np.zeros(nMax, dtype= int)
    nFound = 0
    # Open the file in read only mode
    with open(file_name, 'r') as read_obj:
        # Read all lines in the file one by one
        for line in read_obj:
            if string_to_search in line:
                # If yes, then add the line number & line as a tuple in the list
                list_of_results[nFound] = line_number
                nFound += 1
                if(nFound >= nMax):
                    return list_of_results[0:nFound]
            # For each line, check if line contains the string
            line_number += 1
    # Return list of tuples containing line numbers and lines where string is found
    return list_of_results[0:nFound]


# Parse the logging format declared by the FC
def parse_data_format(filePath, fSavedDictPath):
    idStart = search_string_in_file(filePath, "LOGGING_FORMAT")
    idEnd = search_string_in_file(filePath, "END")

    fDict = open(fSavedDictPath, "w")

    dictObj = []
    with open(filePath, 'r') as f:
        lines = f.readlines()
        for i in range(idStart[0] + 1, idEnd[0]):
            curStr = lines[i].replace("\n","")
            jsonStr = '{' + curStr+ '}'
            topicFormat = json.loads(jsonStr)
            dictObj.append(topicFormat["Format"])
            
    
    json.dump(dictObj, fDict, indent=4,separators=(',',': ')) #
    fDict.close()

def get_format_dict(formatFilePath):
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

    return declaredTopicID, formatList

if __name__ == "__main__":
    overwrite = True


    print("Please choose the raw log file...")
    logFilePath = askopenfilename()
    fileSubFolder = os.path.dirname(logFilePath)
    fileName = os.path.splitext(os.path.basename(logFilePath))[0]

    print("File Name: ", fileName)

    processedFolder = os.path.join(fileSubFolder, "Processed_" + fileName)
    
    print("Generating processed folder to contain the processed file...", processedFolder)
    print(processedFolder)
    
    orgFilePath = os.path.join(os.getcwd(), fileSubFolder, fileName + ".TXT")
    dictFilePath = os.path.join(os.getcwd(), processedFolder, fileName + "_format.json")

    if(not os.path.isdir(processedFolder)):
        print("Creating new folder ...", processedFolder)
        os.mkdir(processedFolder)
        os.chmod(processedFolder, 0o777)

        get_data_format(orgFilePath, dictFilePath)

    elif overwrite:
        get_data_format(orgFilePath, dictFilePath)

    else:
        print("Log file's processed folder exists. Abort...")

    
    # Read the file as unit test
    with open(dictFilePath, 'r') as f:
        content = f.read()
        dictionary = json.loads(content)

    print("JSON file for data format was generated and tested.")


    


    