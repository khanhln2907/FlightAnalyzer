%% Returns a line specification (line+marker) based on a simple index
function LineSpec = LineSpecs(idx)

markers = {'none', 'o', '+', '*', '.', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'};
lines = {'-', '--', ':', '-.'};

iSpecs = 1;

for iLine = 1:length(lines)
	for iMarker = 1:length(markers)
		if iMarker ~=1
			LineSpec{iSpecs} = horzcat(markers{iMarker}, lines{iLine});
		else
			LineSpec{iSpecs} = lines{iLine};
		end
		iSpecs = iSpecs +1;
	end
end

if exist('idx', 'var')
	LineSpec = LineSpec{idx};
end

end