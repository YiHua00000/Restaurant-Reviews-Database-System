--Drop Statements
DROP TABLE IF EXISTS [Review.Visit];
DROP TABLE IF EXISTS [Review.Ratings];
DROP TABLE IF EXISTS [Review.Restaurant];
DROP TABLE IF EXISTS [Review.Seating];
DROP TABLE IF EXISTS [Review.ModeOfPayment];
DROP TABLE IF EXISTS [Review.ModeOfInteraction];
DROP TABLE IF EXISTS [Review.Amenities];
DROP TABLE IF EXISTS [Review.Customer];

--Customer table
CREATE TABLE [Review.Customer] (
	cstId CHAR (4) NOT NULL,
	cstFirstName VARCHAR(20),
	cstLastInitial VARCHAR(20),
	cstCity VARCHAR(20),
	cstState VARCHAR(20),
	CONSTRAINT pk_Customer_cstId PRIMARY KEY (cstId) )

--Amenities table
CREATE TABLE [Review.Amenities] (
	amtId CHAR(4) NOT NULL,
	amtReservation VARCHAR(5),	
	CONSTRAINT pk_Amenities_amtId PRIMARY KEY (amtId));

--Table for mode of interaction
CREATE TABLE [Review.ModeOfInteraction]  (
	amtId CHAR(4) NOT NULL,
	amtModeOfInteraction VARCHAR(40) NOT NULL,
CONSTRAINT pk_ModeOfInteraction_amtModeOfInteraction_amtId PRIMARY KEY (amtModeOfInteraction,amtId),
CONSTRAINT fk_ModeOfInteraction_amtId FOREIGN KEY (amtId)
		REFERENCES [Review.Amenities] (amtId)
		ON DELETE CASCADE ON UPDATE CASCADE);

--Table for mode of payment
CREATE TABLE [Review.ModeOfPayment]  (
	amtId CHAR(4) NOT NULL,
	amtModeOfPayment VARCHAR(40) NOT NULL,
CONSTRAINT pk_ModeOfPayment_amtModeOfPayment_amtId PRIMARY KEY (amtModeOfPayment, amtId),
CONSTRAINT fk_ModeOfPayment_amtId FOREIGN KEY (amtId)
		REFERENCES [Review.Amenities] (amtId)
		ON DELETE CASCADE ON UPDATE CASCADE);

--Table for seating amenities
CREATE TABLE [Review.Seating]  (
	amtId CHAR(4) NOT NULL,
	amtSeating VARCHAR(10) NOT NULL,
	CONSTRAINT pk_Seating_amtSeating_amtId PRIMARY KEY (amtSeating,amtId),
	CONSTRAINT fk_Seating_amtId FOREIGN KEY (amtId)
		REFERENCES [Review.Amenities] (amtId)
		ON DELETE CASCADE ON UPDATE CASCADE);

--Restaurant table
CREATE TABLE [Review.Restaurant] (
	rstId CHAR(4) NOT NULL,
	rstName VARCHAR(20),
	rstStreet VARCHAR(40),
	rstCity VARCHAR(20),
	rstState VARCHAR(10),
	rstZipCode CHAR(5),
	rstPhone  CHAR(10),
	rstStartTime VARCHAR(10),
	rstEndTime  VARCHAR(10),
	rstCusineOffered VARCHAR(20),
	amtId  CHAR(4) NOT NULL,
CONSTRAINT pk_Restaurant_rstId PRIMARY KEY (rstId),
CONSTRAINT fk_Restaurant_amtId FOREIGN KEY (amtId)
		REFERENCES [Review.Amenities] (amtId)
		ON DELETE NO ACTION ON UPDATE CASCADE);

--Table for ratings data
CREATE TABLE [Review.Ratings]  (
	ratId CHAR(4) NOT NULL,
	ratStars CHAR (4) NOT NULL,
	ratComment VARCHAR(330),
	ratNumberOfPhotos INTEGER,
	ratSourceWebsite VARCHAR(11),
	cstDateOfRating DATE,
	cstId CHAR (4) NOT NULL,
	rstId CHAR(4) NOT NULL,
CONSTRAINT pk_Ratings_ratId PRIMARY KEY (ratId),
CONSTRAINT fk_Ratings_rstId FOREIGN KEY (rstId)
		REFERENCES [Review.Restaurant] (rstId)
		ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Ratings_cstId FOREIGN KEY (cstId)
		REFERENCES [Review.Customer] (cstId)
		ON DELETE NO ACTION ON UPDATE CASCADE)

--Table for visiting data
CREATE TABLE [Review.Visit]  (
	rstDateOfVisit DATE,
	cstId CHAR (4) NOT NULL,
	rstId CHAR(4) NOT NULL,
CONSTRAINT pk_Visit_rstId_cstId PRIMARY KEY (rstId, cstId),
CONSTRAINT fk_Visit_rstId FOREIGN KEY (rstId)
		REFERENCES [Review.Restaurant] (rstId)
		ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Visit_cstId FOREIGN KEY (cstId)
		REFERENCES [Review.Customer] (cstId)
		ON DELETE CASCADE ON UPDATE CASCADE)
