/************************************************************************************************************  

	Name:			Comic Database Test Script
	
	Description:	Handles populating the database with test data to test system functionality.
	
	Authors:		Kyle Lierer

*************************************************************************************************************/

/************************************************************************************************************  
												TABLE POPULATION
*************************************************************************************************************/
-- Add Publishers
SET IDENTITY_INSERT publishers ON
INSERT INTO publishers (publisherId, [name])
	VALUES	(1, 'BOOM!'),
			(2, 'Image Comics'),
			(3, 'Marvel'),
			(4, 'Oni Press'),
			(5, 'DC'),
			(6, 'IDW Publishing'),
			(7, 'Vertigo'),
			(8, 'Dark Horse')
SET IDENTITY_INSERT publishers OFF
GO

-- Add FileTypes
SET IDENTITY_INSERT fileTypes ON
INSERT INTO fileTypes (fileTypeId, [value])
	VALUES	
		(1, '.CBR'),
		(2, '.CBZ')
SET IDENTITY_INSERT fileTypes OFF
GO

-- Add Comics
SET IDENTITY_INSERT comics ON
INSERT INTO comics (comicId, title, filetypeId, publisherId, publicationDate, [description], notes, filePath) 
	VALUES 
		(1, 'Giant Days #1', 1, 1, '2015-12-01', '"Susan, Esther, and Daisy started at university three weeks ago and became fast friends. Now, away from home for the first time, all three want to reinvent themselves. But in the face of hand-wringing boys, ôpersonal experimentation,ö influenza, mystery-mold, nu-chauvinism, and the willful, unwanted intrusion of ôacademia,ö they may be lucky just to make it to spring alive. Going off to university is always a time of change and growth, but for Esther, Susan, and Daisy, things are about to get a little weird."', 'N/A', '/home/media/Comics/Giant-Days-#1.cbr'),
		(2, 'Saga #1', 1, 2, '2012-03-14', '"Y: THE LAST MAN writer BRIAN K. VAUGHAN returns to comics with red-hot artist FIONA STAPLES for an all-new ONGOING SERIES! Star Wars-style action collides with Game of Thrones-esque drama in this original sci-fi/fantasy epic for mature readers, as new parents Marko and Alana risk everything to raise their child amidst a never-ending galactic war."', 'N/A', '/home/media/Comics/Saga-#1.cbr'),
		(3, 'Jessica Jones #4', 1, 3, '2017-01-11', 'Jessica Jones latest case has revealed a new hidden evil in the Marvel Universe. An evil so terrifying she was willing to rip her family apart to save them from it. But was the sacrifice enough? Another all-new blistering chapter of Marvel''s premier detective.', 'N/A', '/home/media/Comics/Jessica-Jones-#4.cbr'),
		(4, 'Scott Pilgrim #3', 1, 4, '2013-05-15', '"The full color, completely remastered, utterly astounding republication of the Scott Pilgrim epic continues! This new edition presents Scott''s run-in with Ramona ex, Envy boy toy and The Clash at Demon Head bassist Todd Ingram as you''ve never seen it before -- in full-color! Plus, previously unpublished extras, hard-to-find short stories, and exclusive bonus materials will make you see Scott Pilgrim in a whole new light!"', 'N/A', '/home/media/Comics/Scott-Pilgrim-#3.cbr'),
		(5, 'Watchmen #5', 1, 5, '1986-12-31', '"While Dr. Manhattan continues his seclusion on Mars, back on Earth, Dan offers Laurie a place to stay while Rorschach continues his investigation of Blake''s murder. Plus, a mugger attacks Ozymandias and Moloch offers to come clean."', 'N/A', '/home/media/Comics/Watchmen-#5.cbr'),
		(6, 'Love is Love', 1, 6, '2017-01-10', '"The comic book industry comes together to honor those killed in Orlando this year. From IDW Publishing, with assistance from DC Entertainment, this oversize comic contains moving and heartfelt material from some of the greatest talents in comics - - mourning the victims, supporting the survivors, celebrating the LGBTQ community, and examining love in today''s"', 'N/A', '/home/media/Comics/Love-is-Love.cbr'),
		(7, 'Faithless #2', 1, 1, '2019-05-22', '"Faith is drawn into a new world when she attends a party at the home of renowned artist Louis Thorn. ItÆs a world of opulence, excess, and sensualityùand something darker that she canÆt put her finger on. There is something . . . curious about these people, a darkness or shadow just at the edge of reason . . . and maybe it is exactly what Faith is looking for."', 'N/A', '/home/media/Comics/Faithless-#2.cbr'),
		(8, 'Shutter #1', 1, 2, '2014-04-09', '"INDIANA JONES FOR THE 21ST CENTURY! Marvel Knights: Hulk and GLORY writer JOE KEATINGE teams up with artist extraordinaire LEILA DEL DUCA for her Image Comics debut in an all-new ongoing series combining the urban fantasy of Fables and the globe-spanning adventure of Y: The Last Man. Kate Kristopher, once the most famous explorer of an Earth far more fantastic than the one we know, is forced to return to the adventurous life she left behind when a family secret threatens to destroy everything she spent her life protecting."', 'N/A', '/home/media/Comics/Shutter-#1.cbr'),
		(9, 'Paper Girls #2', 1, 2, '2015-11-04', '"The hottest new ongoing series of the year continues, as the Paper Girls witness the impossible."', 'N/A', '/home/media/Comics/Paper-Girls-#2.cbr'),
		(10, 'Lucifer Book #3', 1, 7, '2018-12-19', '"Lucifer is in misery. No longer able to heal his broken body, escape seems further away than ever...until hope arrives in the form of a mad poet. Meanwhile: a tome of prophecy is found among the cookbooks, and a finger or two are lost down the side of the couch."', 'N/A', '/home/media/Comics/Lucifer-Book-#3.cbr'),
		(11, 'The Lost Boys #2', 1, 5, '2016-11-09', '"The comic book sequel to everyoneÆs favorite blood-and-fangs flick continues. The Frog Bros. have a beef with the new vampires in town, and now theyÆre on an unholy mission to show the Blood Belles that they picked the wrong turf to try to set up shop. Will these teenage boys be any match for the deadliest undead ladies to ever terrorize Santa Carla? We think you know the answer to that, Death Breath!á"', 'N/A', '/home/media/Comics/The-Lost-Boys-#2.cbr'),
		(12, 'RWBY #2', 1, 5, '2019-11-13', '"After the attack on Beacon Academy, Ruby Rose has been teamed up with the remaining members of team JNPR, but can she fit into this new team''s dynamics?"', 'N/A', '/home/media/Comics/RWBY-#2.cbr'),
		(13, 'Witcher #1', 1, 8, '2014-03-19', '"Traveling near the edge of the Black Forest, monster hunter Geralt meets a widowed fisherman whose dead and murderous wife resides in an eerie mansion known as the House of Glassùwhich seems to have endless rooms, nothing to fill them with, and horror around every corner."', 'N/A', '/home/media/Comics/Witcher-#1.cbr'),
		(14, 'Deadman #1', 1, 5, '2017-11-01', '"ôJourney into Deathö part one! When we last left Deadman, the true story had barely begun! DeadmanÆs death was unsolved, and his fate was intertwined with that of his parents and siblings. Even the Dark Night Detective couldnÆt solve the mysteries of Boston BrandÆs fantastic secrets! Now, Batman is back, confronting Deadman about who was really behind his death. Was Boston BrandÆs assassination a test for the League of Assassins? Why does Batman think RaÆs al Ghul was involved? And why does Deadman need the help of Zatanna, Phantom Stranger, Dr. Fate and the Spectre to defend Nanda Parbat?"', 'N/A', '/home/media/Comics/Deadman-#1.cbr'),
		(15, 'Something is Killing the Children #2', 1, 1, '2019-10-16', '"Children are dying in the town of ArcherÆs Peak and the ones who survive bring back terrible stories. A strange woman named Erica Slaughter has appeared and says she fights these monsters behind the murders, but that canÆt possibly be true. Monsters arenÆt realà are they?"', 'N/A', '/home/media/Comics/Something-is-Killing-the-Children-#2.cbr'),
		(16, 'iZombie #3', 1, 7, '2010-07-07', '"Unless zombie gravedigger Gwen Dylan eats a dead perso''s brain once a month, she loses her memories. The trouble is, for the week following a feeding, she shares her head with the dead perso''s final thoughts and has to complete any unfinished business they''ve left behind. In this case, it involves solving the murder of Dead Fred."', 'N/A', '/home/media/Comics/iZombie-#3.cbr'),
		(17, 'Over the Garden Wall #2', 2, 1, '2015-01-01', '"OVER THE GARDEN WALL #2 BOOM! STUDIOS (W) Pat McHale (A/CA) Jim Campbell The Tale of Fred the Horse! This issue takes place between episodes 4-5 of the Cartoon Network miniseries and tells the story of Fred, a down-on-his-luck horse who finds himself in trouble with the Highwayman."', 'N/A', '/home/media/Comics/Over-the-Garden-Wall-#2.cbz'),
		(18, 'Locke & Key #5', 2, 6, '2010-01-01', '"Single issue comic book format; Award winning suspense-horror series from Joe Hill(Horns, NOS4A@)."', 'N/A', '/home/media/Comics/Locke-&-Key-#5.cbz'),
		(19, 'Ghosted In L.A. #6', 2, 1, '2019-12-04', 'It''s never a good thing when your ex has a crush on your roommate. It''s awkward enough that the part where Daphne''s roommates are all ghosts is''t even the weirdest part of the situation. Daphne is about to learn that personal drama does''t stop when your heart does.', 'N/A', '/home/media/Comics/Ghosted-In-L.A.-#6.cbz'),
		(20, 'Folklords #3', 2, 1, '2020-01-22', '"Outside of the village, life is no fairy tale-and Ansel has learned this the hard way. Betrayed by one of his traveling companions, Ansel finds himself at the mercy of Hanz and Greta. He needs to escape before the worst happens, but the siblings have a story for him, and the truth is more gruesome than he could have imagined."', 'N/A', '/home/media/Comics/Folklords-#3.cbz')
SET IDENTITY_INSERT comics OFF
GO

-- Add People
SET IDENTITY_INSERT people ON
INSERT INTO people (personId, fName, lName)
	VALUES	
		(1, 'John', 'Allison'),
		(2, 'Lissa', 'Treiman'),
		(3, 'Brian', 'Vaughan'),
		(4, 'Fiona', 'Staples'),
		(5, 'Kelly', 'Thompson'),
		(6, 'Mattia', 'Lulis'),
		(7, 'Bryan', 'Malley'),
		(8, 'Alan', 'Moore'),
		(9, 'Dave', 'Gibbons'),
		(10, 'Marc', 'Andreyko'),
		(11, 'Taran', 'Killam'),
		(12, 'Brian', 'Azzarello'),
		(13, 'Maria', 'Llovet'),
		(14, 'Joe', 'Keatinge'),
		(15, 'Leila', 'Duca'),
		(16, 'Owen', 'Gieni'),
		(17, 'Cliff', 'Chiang'),
		(18, 'Neil', 'Gaiman'),
		(19, 'Sam', 'Kieth'),
		(20, 'Tim', 'Seeley'),
		(21, 'Scott', 'Godlewski'),
		(22, 'Marguerite', 'Bennett'),
		(23, 'Maciej', 'Parowski'),
		(24, 'Boguslaw', 'Polch'),
		(25, 'Arnold', 'Drake'),
		(26, 'Neal', 'Adams'),
		(27, 'Miqel', 'Muerto'),
		(28, 'James', 'Tynion IV'),
		(29, 'Werther', 'Edera'),
		(30, 'Chris', 'Roberson'),
		(31, 'Michael', 'Allred'),
		(32, 'Pat', 'McHale'),
		(33, 'Jim', 'Campbell'),
		(34, 'Joe', 'Hill'),
		(35, 'Gabriel', 'Rodríguez'),
		(36, 'Sina', 'Grace'),
		(37, 'Siobhan', 'Keenan'),
		(38, 'Matt', 'Smith'),
		(39, 'Matt', 'Kindt')
SET IDENTITY_INSERT people OFF
GO

-- Add Comic Authors
INSERT INTO comicAuthors (authorId, comicId)
	VALUES	
		(1, 1),
		(3, 2),
		(5, 3),
		(7, 4),
		(8, 5),
		(10, 6),
		(12, 7),
		(14, 8),
		(3, 9),
		(18, 10),
		(20, 11),
		(22, 12),
		(23, 13),
		(25, 14),
		(27, 15),
		(28, 15),
		(30, 16),
		(32, 17),
		(34, 18),
		(36, 19),
		(38, 20),
		(39, 20)
GO

-- Add Comic Illustrators
INSERT INTO comicIllustrators(illustratorId, comicId)
	VALUES	
		(2, 1),
		(4, 2),
		(6, 3),
		(7, 4),
		(9, 5),
		(11, 6),
		(13, 7),
		(15, 8),
		(16, 8),
		(17, 9),
		(19, 10),
		(21, 11),
		(22, 12),
		(24, 13),
		(26, 14),
		(28, 15),
		(31, 16),
		(33, 17),
		(35, 18),
		(37, 19),
		(39, 20)
GO

-- Add Tags
SET IDENTITY_INSERT tags ON
INSERT INTO tags(tagId,[description])
	VALUES	(1, 'Crime'),
			(2, 'Mystery'),
			(3, 'Fantasy'),
			(4, 'LGBTQ*'),
			(5, 'Action'),
			(6, 'Adventure'),
			(7, 'Drama'),
			(8, 'Romance'),
			(9, 'Horror'),
			(10, 'Supernatural'),
			(11, 'Thriller'),
			(12, 'Slice-of-Life'),
			(13, 'Humor')
SET IDENTITY_INSERT tags OFF
GO

-- Add Comic Tags
INSERT INTO comicTags(comicId, tagId)
	VALUES	
		(1, 13),
		(1, 12),
		(2, 3),
		(2, 4),
		(2, 5),
		(3, 1),
		(3, 2),
		(3, 7),
		(4, 5),
		(4, 6),
		(4, 8),
		(4, 13),
		(5, 1),
		(5, 2),
		(5, 11),
		(6, 4),
		(6, 13),
		(7, 2),
		(7, 4),
		(7, 7),
		(7, 8),
		(7, 10),
		(8, 4),
		(8, 7),
		(9, 13),
		(9, 12),
		(10, 1),
		(10, 3),
		(10, 5),
		(10, 10),
		(10, 11),
		(11, 1),
		(11, 2),
		(11, 9),
		(11, 10),		
		(12, 3),
		(12, 5),
		(12, 6),
		(12, 4),
		(13, 5),
		(13, 6),
		(13, 10),
		(14, 2),
		(14, 5),
		(14, 9),
		(15, 1),
		(15, 2),
		(15, 9),
		(15, 11),
		(16, 2),
		(16, 7),
		(16, 11),
		(16, 13),
		(17, 2),
		(17, 6),
		(17, 12),
		(17, 13),
		(18, 2),
		(18, 6),
		(18, 11),
		(19, 2),
		(19, 7),
		(19, 10),
		(19, 12),
		(20, 2),
		(20, 3),
		(20, 13)
GO