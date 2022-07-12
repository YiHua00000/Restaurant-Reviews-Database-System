-- Restaurants that received the highest ratings within the last month
GO
CREATE VIEW [Review.the_highest_rated_restaurant_within_the_last_month]
AS
SELECT r.ratStars AS 'Restaurant Ratings', rst.rstName AS 'Restaurant Name', r.cstDateOfRating AS 'Date of Review'
FROM [Review.Restaurant] rst, [Review.Ratings] r
WHERE rst.rstId=r.rstId
AND r.ratStars IN (SELECT MAX(r1.ratStars) FROM [Review.Ratings] r1 
WHERE DATEDIFF(day, r1.cstDateOfRating, getdate())<=30) AND DATEDIFF(day, r.cstDateOfRating, getdate())<=30


--Top 3 rated restaurants open past midnight offering reservations
GO
CREATE VIEW [Review.Highest_Rated_Midnight_Rest] 
AS
SELECT TOP 3 favg.[Average Rating],  favg.rstName AS 'Restaurant Name', favg.rstEndTime AS 'Restaurant End Time'
FROM (
	SELECT *
	FROM (
		SELECT amavg.*, r.rstEndTime, r.rstName
		FROM [Review.Restaurant] r
			,(
				SELECT amavg.rstId , amavg.[Average Rating]
				FROM (
					SELECT avgrat.*, am.amtReservation
					FROM [Review.Amenities] am
						,(
							SELECT rsa.amtId ,rsa.rstID, CAST(AVG(rsa.ratStars) AS DECIMAL(2,1)) AS 'Average Rating'
							FROM (
								SELECT ra.ratStars, r.rstId, r.amtId
								FROM [Review.Ratings] ra, [Review.Restaurant] r
								WHERE ra.rstId = r.rstId
								) rsa
							GROUP BY rsa.rstId, rsa.amtId
							) avgrat
					WHERE avgrat.amtId = am.amtId
					) amavg
				WHERE amavg.amtReservation = 1
				) amavg
		WHERE amavg.rstId = r.rstId
		) rstavg
	WHERE rstavg.rstEndTime > '00:00:00'
		AND rstavg.rstEndTime < '06:00:00'
	) favg
ORDER BY 'Average Rating' DESC

--Restaurants offering only Japanese food along with their ratings
GO
CREATE VIEW [Review.Japanese_highest_rating_Rest]
AS
SELECT MAX(rat.ratStars) AS 'Restaurant Ratings', r.rstName AS 'Restaurant Name' ,r.rstStreet AS 'Restaurant Street Address'
FROM [Review.Restaurant] r ,[Review.Ratings] rat
WHERE  r.rstId = rat.rstId
	AND r.rstCusineOffered = 'Japanese'
GROUP BY rat.rstId,r.rstName,r.rstStreet

--The highest-rated restaurant on Baltimore Avenue offering outdoor seating
GO
CREATE VIEW [Review.Highest_Baltimore_Outdoor_Rest]
AS
SELECT TOP 3 street.[Average Rating], street.rstName AS 'Restaurant Name', street.rstStreet AS 'Restaurant Street Name'
FROM (
	SELECT *
	FROM (
		SELECT amtrst.*, r.rstStreet, r.rstName
		FROM [Review.Restaurant] r
			,(
				SELECT amtrst.rstId , amtrst.[Average Rating]
				FROM (
					SELECT amt.*, s.amtSeating
					FROM [Review.Seating] s
						,(
							SELECT rest.amtId ,rest.rstID, CAST(AVG(rest.ratStars) AS DECIMAL(2,1)) AS 'Average Rating'
							FROM (
								SELECT ra.ratStars, r.rstId, r.amtId
								FROM [Review.Ratings] ra, [Review.Restaurant] r
								WHERE ra.rstId = r.rstId
								) rest
							GROUP BY rest.rstId, rest.amtId
							) amt
					WHERE amt.amtId = s.amtId
					) amtrst
				WHERE amtrst.amtSeating='Outdoor'
				) amtrst
		WHERE amtrst.rstId = r.rstId
		) rst
	WHERE rst.rstStreet LIKE '%Baltimore Ave%'
	) street
ORDER BY 'Average Rating' DESC

--American restaurants accepting payment in the form of cash or digital wallets
GO
CREATE VIEW [Review.Mode_of_payements_American_Rest]
AS 
SELECT rat.ratStars AS 'Restaurant Ratings', r.rstName AS 'Restaurant Name' ,r.rstStreet AS 'Restaurant Street Address' ,p.amtModeOfPayment AS 'Accepted Mode of Payment'
FROM [Review.Restaurant] r ,[Review.ModeOfPayment] p ,[Review.Ratings] rat
WHERE r.amtId = p.amtId
	AND r.rstId = rat.rstId
	AND r.rstCusineOffered = 'American'
	AND ((p.amtModeOfPayment = 'Cash') OR (p.amtModeOfPayment='Digital Wallets'))

--File to run all the created Views which provides information for our business use cases

--Which restaurants received the highest ratings within the last month?
SELECT * FROM [Review.the_highest_rated_restaurant_within_the_last_month]

--Which are the top 3 rated restaurants open past midnight offering reservations?
SELECT * FROM [Review.Highest_Rated_Midnight_Rest]

--Which restaurants offer only Japanese food along with their ratings?
SELECT * FROM [Review.Japanese_highest_rating_Rest]

--Which is the highest-rated restaurant on Baltimore Avenue offering outdoor seating?
SELECT * FROM [Review.Highest_Baltimore_Outdoor_Rest]

--Which American restaurants accepting payment in the form of cash or digital wallets?
SELECT * FROM [Review.Mode_of_payements_American_Rest]