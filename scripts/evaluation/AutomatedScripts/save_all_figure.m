FolderName = fullfile(pwd, "Local", "Figures", sprintf("%s_%d", date, floor(now)));   % Your destination folder

if(~exist(FolderName, "dir"))
    mkdir(FolderName);
end

FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = get(FigHandle, 'Name');
  try
      saveas(FigHandle, fullfile(FolderName, sprintf("%s.png", FigName)));
  catch
      
  end
end