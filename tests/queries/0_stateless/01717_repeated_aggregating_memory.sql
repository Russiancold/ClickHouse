CREATE DATABASE IF NOT EXISTS test_01717;
USE test_01717;

DROP TABLE IF EXISTS test_01717.aggr_memory;
DROP TABLE IF EXISTS test_01717.visits_data;

CREATE TABLE test_01717.visits_data ( `UserID` UInt32, `Region` String, `Day` UInt8, `Age` UInt8, `Sex` UInt8 ) ENGINE = MergeTree() ORDER BY (Day, UserID);

INSERT INTO test_01717.visits_data VALUES (1, 'Moscow', 1, 30, 2);
INSERT INTO test_01717.visits_data VALUES (2, 'SPb', 1, 32, 2);
INSERT INTO test_01717.visits_data VALUES (3, 'Moscow', 1, 22, 1);
INSERT INTO test_01717.visits_data VALUES (4, 'Moscow', 1, 27, 2);
INSERT INTO test_01717.visits_data VALUES (5, 'SPb', 1, 40, 0);
INSERT INTO test_01717.visits_data VALUES (6, 'SPb', 1, 20, 2);
INSERT INTO test_01717.visits_data VALUES (3, 'Moscow', 2, 22, 1);
INSERT INTO test_01717.visits_data VALUES (5, 'SPb', 2, 40, 0);
INSERT INTO test_01717.visits_data VALUES (2, 'SPb', 2, 32, 2);
INSERT INTO test_01717.visits_data VALUES (1, 'Moscow', 2, 30, 2);
INSERT INTO test_01717.visits_data VALUES (3, 'Moscow', 2, 22, 1);


CREATE TABLE test_01717.aggr_memory
( `UserID` UInt32, `Region` String, `Day` UInt8, `Age` UInt8, `Sex` UInt8 ) 
ENGINE = AggregatingMemory()
AS SELECT
    Region,
    Day,
    avg(Age) AS AvgAge,
    count() AS Visits,
    countIf(Sex = 1) AS Boys,
    uniq(UserID) AS Users
FROM test_01717.visits_data
GROUP BY Region, Day
;

SELECT * FROM test_01717.aggr_memory;

INSERT INTO test_01717.aggr_memory SELECT * FROM test_01717.visits_data WHERE Sex = 1;
SELECT * FROM test_01717.aggr_memory;

INSERT INTO test_01717.aggr_memory SELECT * FROM test_01717.visits_data WHERE Sex != 1;
SELECT * FROM test_01717.aggr_memory;

INSERT INTO test_01717.aggr_memory SELECT * FROM test_01717.visits_data WHERE Sex == 3;
SELECT * FROM test_01717.aggr_memory;

DROP TABLE IF EXISTS test_01717.aggr_memory;
DROP TABLE IF EXISTS test_01717.visits_data;

DROP DATABASE test_01717;