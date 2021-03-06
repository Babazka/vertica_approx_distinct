\set libfile '\''`pwd`'/build/CardinalityEstimators.so\'';
CREATE LIBRARY CardinalityEstimators AS :libfile;
CREATE AGGREGATE FUNCTION estimate_count_distinct AS LANGUAGE 'C++'
NAME 'EstimateCountDistinctFactory' LIBRARY CardinalityEstimators;

CREATE TABLE T (x INTEGER, y NUMERIC(5,2), z VARCHAR(10));
COPY T FROM STDIN DELIMITER ',';
1,1.5,'A'
1,3.5,'A'
2,2.0,'B'
2,3.0,'A'
2,2.6,'B'
2,1.4,'A'
3,0.5,'C'
3,3.5,'C'
3,1.5,'B'
3,7.5,'B'
\.

SELECT x, sum(y), count(z), estimate_count_distinct(z) as est_count
FROM T
GROUP BY x;

DROP TABLE T;
DROP LIBRARY CardinalityEstimators CASCADE;
