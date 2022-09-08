get_data;

%manager = CrossAnalyzerBase({frameKC.rateSample, frameK.rateSample});

%rateFilterredAnalyzer = CrossAnalyzerBase({frameK.rateSample, frameK.rateFilterredSample});
rateFilterredAnalyzer = CrossAnalyzerBase({ frameKC.adisRateSample, frameKC.rateSample});