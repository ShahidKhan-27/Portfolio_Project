/*This is a kaggle dataset of one month table tennis match 
and I want top ten Players according there Performance. This will be also my 
first dataset to analyze by myself .Lets do this !
*/
-- Lets create a database for the analysis to get some insides
CREATE DATABASE TTGAMES_ANALYSYS;

-- to select database
USE ttgames_analysys;

-- select dataset table
SELECT * FROM table_tennis;

/* Max five sets is there in the match and who will be 
the winner of three ,will be winner of the game .
*/
-- Lets count how many Rows in the table 
select count(*) as 'Total Rows' from (select * from table_tennis) D_set ;-- 7851

-- Game Start Date and End date 
select (select max(date) from table_tennis) end_date,
(select min(date) from table_tennis) start_date from table_tennis -- 2022/7/8	2022/6/10
limit 1;

-- Total Game Days
SELECT DATEDIFF(days_.end_date,days_.start_date) total_days FROM (select (select max(date) from table_tennis) end_date,
(select min(date) from table_tennis) start_date from table_tennis 
limit 1) days_; -- 28

-- Total no of Players Participated in the match
SELECT COUNT(*) count FROM (SELECT Player1 from table_tennis
union
SELECT Player2 FROM table_tennis ) total_Playrs;-- 565

-- Total count of Palyer1
SELECT COUNT(*) TOTAL_PLAYER1 FROM (SELECT DISTINCT Player1 from table_tennis) A; -- 551

-- Total match played by each players as Player1
SELECT DISTINCT Player1 ,count(*) over(partition by Player1) as Match_played1
FROM table_tennis 
ORDER BY Match_played1 desc;

-- Total count of Palyer2
SELECT COUNT(*) TOTAL_PLAYER2 FROM (SELECT DISTINCT Player2 from table_tennis) A; -- 544

-- Total match played by each players as Player2
SELECT DISTINCT Player2 ,count(*) over(partition by Player2) as Match_played2 
FROM table_tennis 
ORDER BY Match_played2 desc;

-- TOTAL MATCH PLAYED BY EACH PLAYER AS A PLAYER1 AND PLAYER2 
SELECT *,a.Match_played1+a.Match_played2 AS TOTAL_MATCH_PLAYED_BY_EACH_ONE
FROM  (SELECT * FROM
(SELECT DISTINCT Player1 ,count(*) over(partition by Player1) as Match_played1
FROM table_tennis ORDER BY Match_played1 desc) P1a
RIGHT JOIN 
(SELECT DISTINCT Player2 ,count(*) over(partition by Player2) as Match_played2 
FROM table_tennis ORDER BY Match_played2 desc) P2a
ON P1a.Player1=P2a.Player2
UNION
SELECT * FROM
(SELECT DISTINCT Player1 ,count(*) over(partition by Player1) as Match_played1
FROM table_tennis ORDER BY Match_played1 desc) P1b
LEFT JOIN 
(SELECT DISTINCT Player2 ,count(*) over(partition by Player2) as Match_played2 
FROM table_tennis ORDER BY Match_played2 desc) P2b
ON P1b.Player1=P2b.Player2) a
ORDER BY TOTAL_MATCH_PLAYED_BY_EACH_ONE DESC ;

SELECT * FROM table_tennis;

-- Create a view total_match_p1_p2 with above table for further use --
CREATE VIEW total_match_p1_p2 AS 
SELECT *,a.Match_played1+a.Match_played2 AS TOTAL_MATCH_PLAYED_BY_EACH_ONE
FROM  (SELECT * FROM
(SELECT DISTINCT Player1 ,count(*) over(partition by Player1) as Match_played1
FROM table_tennis ORDER BY Match_played1 desc) P1a
RIGHT JOIN 
(SELECT DISTINCT Player2 ,count(*) over(partition by Player2) as Match_played2 
FROM table_tennis ORDER BY Match_played2 desc) P2a
ON P1a.Player1=P2a.Player2
UNION
SELECT * FROM
(SELECT DISTINCT Player1 ,count(*) over(partition by Player1) as Match_played1
FROM table_tennis ORDER BY Match_played1 desc) P1b
LEFT JOIN 
(SELECT DISTINCT Player2 ,count(*) over(partition by Player2) as Match_played2 
FROM table_tennis ORDER BY Match_played2 desc) P2b
ON P1b.Player1=P2b.Player2) a
ORDER BY TOTAL_MATCH_PLAYED_BY_EACH_ONE DESC ;

SELECT * FROM total_match_p1_p2;

-- Players who played as Player1 but not played as Player2 and there name list
SELECT count(*) Total FROM (SELECT Player1 FROM total_match_p1_p2 where Player2 is null) p1_noplay_asp2; -- 21

SELECT Player1  FROM total_match_p1_p2 WHERE Player2 IS NULL ; -- 21 Player who did not palyed as Player2


-- Players who played as Player2 but not played as Player1 and there name list
SELECT count(*) Total FROM (SELECT Player2 FROM total_match_p1_p2 where Player1 is null) p2_noplay_asp1; -- 14
SELECT Player2  FROM total_match_p1_p2 WHERE Player1 IS NULL ; -- 14 Player who did not palyed as 

select * from table_tennis;

-- To find the top players we need to set_order the player by there winning sets

SELECT players.Player1 PLAYERS ,sum(Sets_P1) Total_set_won 
FROM (SELECT Player1,Sets_P1 FROM table_tennis
UNION ALL
SELECT Player2,Sets_P2 FROM table_tennis) players
group by players.Player1
order by Total_set_won desc ;

-- As we can see here that no. of sets will help me to find the top 10 Players and bottom 10 Players --
SELECT players.Player1 PLAYERS ,sum(Sets_P1) Total_set_won 
FROM (SELECT Player1,Sets_P1 FROM table_tennis
UNION ALL
SELECT Player2,Sets_P2 FROM table_tennis) players
group by players.Player1
order by Total_set_won desc
LIMIT 10 ;  -- Lyevshyn V.	226 (He is a winner who won max no. of sets)

-- Bottom 10 Players who won least no. of Games --
SELECT players.Player1 PLAYERS ,sum(Sets_P1) Total_set_won 
FROM (SELECT Player1,Sets_P1 FROM table_tennis
UNION ALL
SELECT Player2,Sets_P2 FROM table_tennis) players
group by players.Player1
order by Total_set_won 
LIMIT 10 ; -- Kurkova M.	0 (He won 0 no of set )

/* So these are the Insites which I found very Importante data 
   from this Kaggle.table_tennis data set.
   I hope u like my work 
   Thank you.
*/