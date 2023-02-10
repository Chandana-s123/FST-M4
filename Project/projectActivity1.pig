episodeLines = LOAD 'hdfs:///user/chandana/project/' USING PigStorage('\t') as (word:chararray,desc:chararray);
lines = FILTER episodeLines BY NOT(word matches '^STAR WARS - EPISODE.*');

rankedTable = RANK episodeLines;
lines = FILTER rankedTable BY (rank_episodeLines > 1);

GroupByWord = GROUP lines by word;
wordCount = FOREACH GroupByWord GENERATE (chararray)$0, COUNT($1);
sortWords = ORDER wordCount BY $1 DESC;

rmf hdfs:///user/chandana/projectResults;

STORE sortWords INTO 'hdfs:///user/chandana/projectResults';
