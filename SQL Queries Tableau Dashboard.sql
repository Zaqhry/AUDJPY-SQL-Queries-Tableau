


--#### TOTAL TRADES, TOTAL BUYS & SELLS & CONFLUENCES #### (COMPLETED)



--TOTAL TRADES TAKEN DURING EACH SESSION 

SELECT Session, COUNT(Session)TradesTaken
FROM AUDJPY
GROUP BY Session
ORDER BY TradesTaken DESC

--TOTAL BUY & SELL POSITIONS

SELECT Position,COUNT(Position) PositionOccurence
FROM AUDJPY 
GROUP BY Position 

--Total Wins/Losses for Buys/Sells FTP

SELECT * 
FROM BUYFTP buy 
	INNER JOIN SELLFTP sell 
	ON buy.session = sell.session 
	ORDER BY buy.session,sell.session,buy.total DESC,sell.total DESC

--Total Wins/Losses for Buys/Sells TSL

SELECT * 
FROM BUYTSL buy 
	INNER JOIN SELLTSL sell 
	ON buy.session = sell.session 
	ORDER BY buy.session,sell.session,buy.total DESC,sell.total DESC

--Types of Confluences & Number of Occurences 

SELECT Confluence, COUNT(Confluence) TypeConfluence
FROM AUDJPY
GROUP BY Confluence
ORDER BY TypeConfluence DESC;

------------------------------------------------------------------------------------------------------------------------

--#### WINS & WIN PERCENTAGE ####



--Wins Per Session,Total Trades,Total Wins & Win Percetange Per Session For FTP

WITH FXCTE AS
(
SELECT Session,COUNT(OutcomeFTP) TotalWinsFTP,(SELECT COUNT(OutcomeFTP) FROM AUDJPY) TotalTrades,ROUND(SUM(TradeID) / (COUNT(OutcomeFTP)),1) WinPercentageFTP
FROM AUDJPY 
WHERE OutcomeFTP = 'Win' 
GROUP BY Session,OutcomeFTP
)
SELECT Session,(SELECT COUNT(OutcomeFTP) FROM AUDJPY) TotalTrades,TotalWinsFTP TotalWinsBySession,(SELECT(SUM(TotalWinsFTP)) FROM FXCTE) TotalWinsCombined,WinPercentageFTP WinPercentageBySession
FROM FXCTE;

--Wins Per Session,Total Trades,Total Wins & Win Percetange Per Session For TSL

WITH FXCTE AS
(
SELECT Session,COUNT(OutcomeTSL) TotalWinsTSL,(SELECT COUNT(OutcomeTSL) FROM AUDJPY) TotalTrades,ROUND(SUM(TradeID) / (COUNT(OutcomeTSL)),1) WinPercentageTSL
FROM AUDJPY 
WHERE OutcomeTSL = 'Win' 
GROUP BY Session,OutcomeTSL
)
SELECT Session,(SELECT COUNT(OutcomeTSL) FROM AUDJPY) TotalTrades,TotalWinsTSL TotalWinsBySession,(SELECT(SUM(TotalWinsTSL)) FROM FXCTE) TotalWinsCombined,WinPercentageTSL WinPercentageBySession
FROM FXCTE;

--FTP Overall Win Percentage For All Sessions Combined

SELECT ROUND(SUM(TradeID) / (COUNT(OutcomeFTP)),1) WinPercentageFTP
FROM AUDJPY 
WHERE OutcomeFTP = 'Win';

--TSL Overall Win Percentage Fro All Sessions Combined

SELECT ROUND(SUM(TradeID) / (COUNT(OutcomeTSL)),1) WinPercentageTSL
FROM AUDJPY 
WHERE OutcomeTSL = 'Win';

--FTP Profit Based On Confluences

SELECT DISTINCT Confluence,COUNT(Confluence) Confluences,SUM(ProfitLossFTP) TotalProfit,ROUND(AVG(ProfitLossFTP),0) AvgProfit,(SELECT SUM(ProfitLossFTP) FROM AUDJPY) OverallProfit
FROM AUDJPY 
WHERE OutcomeFTP = 'Win'
GROUP BY Confluence
ORDER BY 2 DESC

--TSL Profit Based On Confluences

SELECT DISTINCT Confluence,COUNT(Confluence) Confluences,SUM(ProfitLossTSL) TotalProfit,ROUND(AVG(ProfitLossTSL),0) AvgProfit,(SELECT ROUND(SUM(ProfitLossTSL),0) FROM AUDJPY) OverallProfit
FROM AUDJPY 
WHERE OutcomeTSL = 'Win'
GROUP BY Confluence
ORDER BY 2 DESC

------------------------------------------------------------------------------------------------------------------------

--#### FINAL RESULTS ####



--FTP & TSL RESULTS

SELECT * 
FROM TOTALFTP ftp
	INNER JOIN TOTALTSL tsl
	ON ftp.session = tsl.session 

--Most Profitable Confluences for each session FTP

SELECT DISTINCT(Session),Confluence,ProfitLossFTP
FROM AUDJPY 
GROUP BY Session,Confluence,ProfitLossFTP
ORDER BY 1,3 DESC

--Most Profitable Confluences for each session TSL

SELECT DISTINCT(Session),Confluence,ProfitLossTSL
FROM AUDJPY 
GROUP BY Session,Confluence,ProfitLossTSL
ORDER BY 1,3 DESC

--POSITIVE & NEGATIVE FTP For Each Confluence

SELECT ProfitLossFTP,Confluence,COUNT(ProfitLossFTP) FTPOccurence
FROM AUDJPY 
GROUP BY ProfitLossFTP,Confluence
ORDER BY FTPOccurence DESC;

--POSITIVE & NEGATIVE TSL For Each Confluence

SELECT ProfitLossTSL,Confluence,COUNT(ProfitLossTSL) TSLOccurence
FROM AUDJPY 
GROUP BY ProfitLossTSL,Confluence
ORDER BY TSLOccurence DESC;
