function isValid = isGEQRelease(checkedVer)
    % Check if the current matlab release is greater or equal ...
    curRel = version('-release');
    curRelYear = str2num(curRel(1:4));
    checkedVerYear =  str2num(checkedVer(1:4));
    % Compare the release character if the years are equal
    if (curRelYear == checkedVerYear)
        isValid = (curRel(5)) > (checkedVer(5));
    else 
        isValid =  curRelYear > checkedVerYear;
end

