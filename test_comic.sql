/************************************************************************************************************  

	Name:			Comic Database Test Script
	
	Description:	Handles testing database operation stored procedures using the testing data from
                    the populate_comic.sql file.
	
	Authors:		Kyle Lierer

*************************************************************************************************************/

/************************************************************************************************************  
												TEST PROCEDURES
*************************************************************************************************************/
-- Add two new people.
EXEC spAddUpdateDeletePerson 0, 'William', 'Moustain'
EXEC spAddUpdateDeletePerson 0, 'Harry', 'Peter'

-- Update person with the id of 40.
EXEC spAddUpdateDeletePerson 40, 'William', 'Marston'

-- Add a new file type.
EXEC spAddUpdateDeleteFileType 0, '.ZIO'

-- Change the new file types value.
EXEC spAddUpdateDeleteFileType 3, '.ZIP'

-- Add a new publisher.
EXEC spAddUpdateDeletePublisher 0, 'Valianr'

-- Change the new publisher's name.
EXEC spAddUpdateDeletePublisher 9, 'Valiant'

-- Add a new comic.
EXEC spAddUpdateDeleteComic 0, 'Wonder Woman #1', 3, 5, '6/1/2020', '', 'N/A', '/home/media/Comics/Wonder-Woman-#1.zip'

-- Update the newly added comic.
EXEC spAddUpdateDeleteComic 21, 'Wonder Woman #1', 3, 5, '6/1/1942', 'Who Is She?" text story by William Moulton Marston, art by Harry G. Peter; The Gods behind the epithet, "Beautiful as Aphrodite, Wise as Athena, Strong as Hercules and Swift as Mercury", are visually and in text introduced to the reader.', 'N/A', '/home/media/Comics/Wonder-Woman-#1.zip'

-- Add William Marston as author of Wonder Woman #1.
EXEC spAddDeleteComicAuthor 40, 21

-- Add Harry Peter as an author of Wonder Woman #1.
EXEC spAddDeleteComicIllustrator 41, 21

-- Add a new tag.
EXEC spAddUpdateDeleteTag 0, 'Classiv'

-- Update the new tag.
EXEC spAddUpdateDeleteTag 14, 'Classic'

-- Add 'Classic' tag to Wonder Woman #1.
EXEC spAddDeleteComicTag 21, 14

-- Add 'Action' tag to Wonder Woman #1.
EXEC spAddDeleteComicTag 21, 5

-- Add 'Adventure' tag to Wonder Woman #1.
EXEC spAddDeleteComicTag 21, 6

-- Gets all people.
EXEC spGetPeople

-- Gets authors.
EXEC spGetComicAuthors

-- Gets all illustrators.
EXEC spGetComicIllustrator

-- Gets all authors of Folklords #3.
EXEC spGetComicAuthors 20

-- Gets all illustrators of Folklords #3.
EXEC spGetComicIllustrator 20

-- Gets Harry Peters
EXEC spGetPeopleById 41

-- Gets all people named Matt
EXEC spGetPeopleByName 'Matt', '', 0

-- Gets all people exactly named Matt. None. 
EXEC spGetPeopleByName 'Matt', '', 1

-- Gets comics by William Marston.
EXEC spGetComicByAuthor 40

-- Gets comics by Harry Peter
EXEC spGetComicByIllustrator 41

-- Get comics by .CBZ
EXEC spGetComicByFileType 2

-- Get comics by DC
EXEC spGetComicByPublisher 5

-- Get comics by Action
EXEC spGetComicByTag 5

-- Get comics with 'man' in the title.
EXEC spGetComicByTitle 'man', 0

-- Get comics exactly called 'man'. None.
EXEC spGetComicByTitle 'man', 1

-- Gets Deadman #1
EXEC spGetComicById 14

-- Gets all publishers
EXEC spGetPublishers

-- Gets DC
EXEC spGetPublishersById 5

-- Gets publishers with 'Bo' in the title.
EXEC spGetPublishersByName 'Bo', 0

-- Gets publishers exactle named 'Bo'.
EXEC spGetPublishersByName 'Bo', 1

-- Gets all tags.
EXEC spGetTags

-- Gets tags of Faithless #2.
EXEC spGetTagsByComic 2

-- Delete all tags from Wonder Woman #1
EXEC spAddDeleteComicTag 21, 14, 1
EXEC spAddDeleteComicTag 21, 5, 1
EXEC spAddDeleteComicTag 21, 6, 1

-- Delete 'Classic' tag.
EXEC spAddUpdateDeleteTag 14, 'Classic', 1

-- Remove authors/illustrator from Wonder Woman #1
EXEC spAddDeleteComicAuthor 40, 21, 1
EXEC spAddDeleteComicIllustrator 41, 21, 1

-- Remove Harry Peter and William Marston from people
EXEC spAddUpdateDeletePerson 41, 'Harry', 'Peter', 1
EXEC spAddUpdateDeletePerson 40, 'William', 'Marston', 1

-- Remove Wonder Woman #1.
EXEC spAddUpdateDeleteComic 21, 'Wonder Woman #1', 3, 5, '6/1/1942', 'Who Is She?" text story by William Moulton Marston, art by Harry G. Peter; The Gods behind the epithet, "Beautiful as Aphrodite, Wise as Athena, Strong as Hercules and Swift as Mercury", are visually and in text introduced to the reader.', 'N/A', '/home/media/Comics/Wonder-Woman-#1.zip', 1

-- Hard deletes everything marked with a soft delete.
EXEC spHardDeletePerson
EXEC spHardDeleteComic
EXEC spHardDeletePublisher

-- Remove .ZIP filetype.
EXEC spAddUpdateDeleteFileType 3, '.ZIP', 1

-- Remove Valiant as a publisher.
EXEC spAddUpdateDeletePublisher 9, 'Valiant', 1