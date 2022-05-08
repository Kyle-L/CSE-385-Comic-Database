/************************************************************************************************************  

	Name:			Comic Database Script
	
	Description:	A database to store the metadata (such as author, illustrator, etc.) for corresponding 
					comics and graphic novel entries as well as the file location.
	
	Authors:		Kyle Lierer

*************************************************************************************************************/

USE master
GO

DROP DATABASE IF EXISTS ComicDB
GO

CREATE DATABASE ComicDB
GO 

USE ComicDB
GO

/************************************************************************************************************  
												CREATE TABLES
*************************************************************************************************************/
CREATE TABLE tags (
	tagId				INT					NOT NULL	PRIMARY KEY		IDENTITY,
	[description]		VARCHAR(32)			NOT NULL
);
GO

CREATE TABLE fileTypes (
	fileTypeId			INT					NOT NULL	PRIMARY KEY		IDENTITY,
	[value]				VARCHAR(32)			NOT NULL
);
GO

CREATE TABLE publishers (
	publisherId			INT					NOT NULL	PRIMARY KEY		IDENTITY,
	[name]				VARCHAR(64)			NOT NULL,
	isDeleted			BIT					NOT NULL	DEFAULT(0)
);
GO

CREATE TABLE people (
	personId			INT					NOT NULL	PRIMARY KEY		IDENTITY,
	fName				VARCHAR(64)			NOT NULL	DEFAULT(''),
	lName				VARCHAR(64)			NOT NULL,
	isDeleted			BIT					NOT NULL	DEFAULT(0)
);
GO

CREATE TABLE comics (
	comicId				INT					NOT NULL	PRIMARY KEY		IDENTITY,
	title				VARCHAR(128)		NOT NULL,
	filetypeId			INT					NOT NULL	FOREIGN KEY	REFERENCES fileTypes(fileTypeId),
	publisherId			INT					NOT NULL	FOREIGN KEY	REFERENCES publishers(publisherId),
	publicationDate		DATE				NOT NULL,
	[description]		VARCHAR(2048)		NOT NULL	DEFAULT(''),
	notes				VARCHAR(1024)		NOT NULL	DEFAULT(''),
	filePath			VARCHAR(256)		NOT NULL,
	isDeleted			BIT					NOT NULL	DEFAULT(0)
);
GO

CREATE TABLE comicAuthors (
	comicId				INT					NOT NULL	FOREIGN KEY	REFERENCES comics(comicId),
	authorId			INT					NOT NULL	FOREIGN KEY	REFERENCES people(personId),
	PRIMARY KEY (comicId, authorId)
);
GO

CREATE TABLE comicIllustrators (
	comicId				INT					NOT NULL	FOREIGN KEY	REFERENCES comics(comicId),
	illustratorId		INT					NOT NULL	FOREIGN KEY	REFERENCES people(personId),
	PRIMARY KEY (comicId, illustratorId)
);
GO

CREATE TABLE comicTags (
	comicId				INT					NOT NULL	FOREIGN KEY	REFERENCES comics(comicId),
	tagId				INT					NOT NULL	FOREIGN KEY	REFERENCES tags(tagId),
	PRIMARY KEY (comicId, tagId)
);
GO

CREATE TABLE errors (
	errorId 			INT					NOT NULL	PRIMARY KEY		IDENTITY,
	[ERROR_NUMBER]		INT					NOT NULL,
	[ERROR_SEVERITY] 	INT					NOT NULL,
	[ERROR_STATE] 		INT					NOT NULL,
	[ERROR_PROCEDURE] 	VARCHAR(64)			NOT NULL,
	[ERROR_LINE]		INT					NOT NULL,
	[ERROR_MESSAGE] 	VARCHAR(512)		NOT NULL,
	errorDate 			DATETIME			NOT NULL	DEFAULT(GETDATE()),
	resolvedOn			DATETIME			NULL,
	comments			VARCHAR(MAX)		NOT NULL	DEFAULT(''),
	userName			VARCHAR(128)		NOT NULL	DEFAULT(''),
	params				VARCHAR(MAX)		NOT NULL	DEFAULT('')
);
GO

/************************************************************************************************************  
												CREATE VIEWS
*************************************************************************************************************/
CREATE VIEW vwPublishers AS
	SELECT publisherId, [name]
	FROM publishers 
	WHERE isDeleted = 0
GO

CREATE VIEW vwPeople AS
	SELECT personId, fName, lName
	FROM people 
	WHERE isDeleted = 0
GO

CREATE VIEW vwComics AS 
	SELECT comicId, title, filetypeId, publisherId, publicationDate, [description], notes, filePath
	FROM comics 
	WHERE isDeleted = 0
GO

/************************************************************************************************************  
												CREATE STORED PROCEDURES
*************************************************************************************************************/

/* =====================================================================

	Name:           spSave_Error
	Purpose:        Saves an error to the database.

======================================================================== */
CREATE PROCEDURE spSave_Error
	@params varchar(MAX) = ''
AS
BEGIN

     BEGIN TRY

    	INSERT INTO errors (ERROR_NUMBER,   ERROR_SEVERITY,   ERROR_STATE,   ERROR_PROCEDURE,   ERROR_LINE,   ERROR_MESSAGE, userName, params)
			VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), SUSER_NAME(), @params)
     
	 END TRY BEGIN CATCH END CATCH

END
GO

/* =====================================================================

	Name:           spAddUpdateDeleteTag
	Purpose:        Adds/Updates/Deletes a tag to/from the database.

======================================================================== */
CREATE PROCEDURE spAddUpdateDeleteTag
	@tagId					INT,
	@description			VARCHAR(32),
	@delete					BIT = 0
AS BEGIN

	BEGIN TRY
		IF(@tagId = 0) BEGIN							-- ADD TAG
			
			INSERT	INTO tags([description]) 
					VALUES (@description)

			SELECT	@@IDENTITY AS tagId,
					[success] = CAST(1 AS BIT)

		END ELSE IF(@delete = 1) BEGIN					-- DELETE TAG

			IF NOT EXISTS (SELECT NULL FROM tags WHERE tagId = @tagId) BEGIN
				SELECT	[message] = 'That tagId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				DELETE FROM tags WHERE tagId = @tagId
				SELECT	0 AS tagId,
						[success] = CAST(1 AS BIT)

			END

		END ELSE BEGIN									-- UPDATE TAG

			IF NOT EXISTS (SELECT NULL FROM tags WHERE tagId = @tagId) BEGIN
				SELECT	[message] = 'That tagId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				UPDATE tags
				SET [description] = @description
				WHERE tagId = @tagId
				SELECT	@tagId AS tagId,
						[success] = CAST(1 AS BIT)

			END
		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT(	'@tagId = ', @tagId,
													', @description = ', @description,
													', @delete = ', @delete
													)
		EXEC spSave_Error @params = @errorParams

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

END
GO

/* =====================================================================

	Name:           spAddUpdateDeleteFileType
	Purpose:        Adds/Updates/Deletes a file type to/from the database.

======================================================================== */
CREATE PROCEDURE spAddUpdateDeleteFileType
	@fileTypeId				INT,
	@value					VARCHAR(32),
	@delete					BIT = 0
AS BEGIN

	BEGIN TRY
		IF(@fileTypeId = 0) BEGIN						-- ADD FILETYPE
			
			INSERT	INTO fileTypes([value]) 
					VALUES (@value)

			SELECT	@@IDENTITY AS fileTypeId,
					[success] = CAST(1 AS BIT)

		END ELSE IF(@delete = 1) BEGIN					-- DELETE FILETYPE

			IF NOT EXISTS (SELECT NULL FROM fileTypes WHERE fileTypeId = @fileTypeId) BEGIN
				SELECT	[message] = 'That fileTypeId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				DELETE FROM fileTypes WHERE fileTypeId = @fileTypeId
				SELECT	0 AS fileTypeId,
						[success] = CAST(1 AS BIT)

			END

		END ELSE BEGIN									-- UPDATE FILETYPE

			IF NOT EXISTS (SELECT NULL FROM fileTypes WHERE fileTypeId = @fileTypeId) BEGIN
				SELECT	[message] = 'That fileTypeId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				UPDATE fileTypes
				SET [value] = @value
				WHERE fileTypeId = @fileTypeId
				SELECT	@fileTypeId AS fileTypeId,
						[success] = CAST(1 AS BIT)

			END

		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT(	'@fileTypeId = ', @fileTypeId,
													', @value = ', @value,
													', @delete = ', @delete
													)
		EXEC spSave_Error @params = @errorParams

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

END
GO

/* =====================================================================

	Name:           spAddUpdateDeletePublisher
	Purpose:        Adds/Updates/Deletes a publisher to/from the database.

======================================================================== */
CREATE PROCEDURE spAddUpdateDeletePublisher
	@publisherId			INT,
	@name					VARCHAR(64),
	@delete					BIT = 0
AS BEGIN

	BEGIN TRY
		IF(@publisherId = 0) BEGIN						-- ADD PUBLISHER
			
			INSERT	INTO publishers([name]) 
					VALUES (@name)
			SELECT	@@IDENTITY AS publisherId,
					[success] = CAST(1 AS BIT)

		END ELSE IF(@delete = 1) BEGIN					-- SOFT DELETE PUBLISHER

			IF NOT EXISTS (SELECT NULL FROM publishers WHERE publisherId = @publisherId) BEGIN
				SELECT	[message] = 'That publisherId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				UPDATE publishers
				SET isDeleted = 1
				WHERE publisherId = @publisherId
				SELECT	0 AS publisherId,
						[success] = CAST(1 AS BIT)

			END

		END ELSE BEGIN									-- UPDATE PUBLISHER

			IF NOT EXISTS (SELECT NULL FROM publishers WHERE publisherId = @publisherId) BEGIN
				SELECT	[message] = 'That publisherId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN
		
				UPDATE publishers
				SET [name] = @name
				WHERE publisherId = @publisherId
				SELECT	@publisherId AS publisherId,
						[success] = CAST(1 AS BIT)

			END

		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT(	'@publisherId = ', @publisherId,
													', @name = ', @name,
													', @delete = ', @delete
													)
		EXEC spSave_Error @params = @errorParams

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

END
GO

/* =====================================================================

	Name:           spHardDeletePublisher
	Purpose:        Hard deletes a publisher to/from the database.

======================================================================== */
CREATE PROCEDURE spHardDeletePublisher
	@publisherId			INT = 0
AS BEGIN

	BEGIN TRY
		IF(@publisherId = 0) BEGIN						-- HARD DELETE ALL PUBLISHER MARKED AS ISDELETED

			DELETE FROM publishers
			WHERE isDeleted = 1
			SELECT [success] = CAST(1 AS BIT)

		END ELSE BEGIN									-- HARD DELETE A SPECIFIC PUBLISHER

			IF NOT EXISTS (SELECT NULL FROM publishers WHERE publisherId = @publisherId) BEGIN
				SELECT	[message] = 'That publisherId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				DELETE FROM publishers
				WHERE publisherId = @publisherId
				SELECT	0 AS publisherId,
						[success] = CAST(1 AS BIT)

			END

		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT('@publisherId = ', @publisherId)
		EXEC spSave_Error @params = @errorParams

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

END
GO

/* =====================================================================

	Name:           spAddUpdateDeletePerson
	Purpose:        Adds/Updates/Deletes a person to/from the database.

======================================================================== */
CREATE PROCEDURE spAddUpdateDeletePerson
	@personId			INT,
	@fName				VARCHAR(64) = '',
	@lName				VARCHAR(64),
	@delete				BIT = 0
AS BEGIN

	BEGIN TRY
		IF(@personId = 0) BEGIN							-- ADD PERSON
			
			INSERT	INTO people(fName, lName) 
					VALUES (@fName, @lName)
			SELECT	@@IDENTITY AS personId,
					[success] = CAST(1 AS BIT)

		END ELSE IF(@delete = 1) BEGIN					-- SOFT DELETE PERSON

			IF NOT EXISTS (SELECT NULL FROM people WHERE personId = @personId) BEGIN
				SELECT	[message] = 'That personId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				UPDATE people
				SET isDeleted = 1
				WHERE personId = @personId
				SELECT	0 AS personId,
						[success] = CAST(1 AS BIT)

			END

		END ELSE BEGIN									-- UPDATE PERSON

			IF NOT EXISTS (SELECT NULL FROM people WHERE personId = @personId) BEGIN
				SELECT	[message] = 'That personId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				UPDATE people
				SET fName = @fName, lName = @lName
				WHERE personId = @personId
				SELECT	@personId AS personId,
						[success] = CAST(1 AS BIT)

			END

		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT(	'@personId = ', @personId,
													', @fName = ', @fName,
													', @lName = ', @lName,
													', @delete = ', @delete
													)
		EXEC spSave_Error @params = @errorParams

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

END
GO

/* =====================================================================

	Name:           spHardDeletePerson
	Purpose:        Hard deletes a person to/from the database.

======================================================================== */
CREATE PROCEDURE spHardDeletePerson
	@personId			INT = 0
AS BEGIN

	BEGIN TRY
		IF(@personId = 0) BEGIN							-- HARD DELETE ALL PEOPLE MARKED AS ISDELETED

			DELETE FROM people
			WHERE isDeleted = 1
			SELECT [success] = CAST(1 AS BIT)

		END ELSE BEGIN									-- HARD DELETE A SPECIFIC PERSON

			IF NOT EXISTS (SELECT NULL FROM people WHERE personId = @personId) BEGIN
				SELECT	[message] = 'That personId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				DELETE FROM people
				WHERE personId = @personId
				SELECT	0 AS personId,
						[success] = CAST(1 AS BIT)

			END

		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT('@personId = ', @personId)

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

END
GO

/* =====================================================================

	Name:           spAddUpdateDeleteComic
	Purpose:        Adds/Updates/Deletes a comic to/from the database.

======================================================================== */
CREATE PROCEDURE spAddUpdateDeleteComic
	@comicId			INT,	
	@title				VARCHAR(100),
	@filetypeId			INT,	
	@publisherId		INT,
	@publicationDate	DATE,
	@description		VARCHAR(2048),
	@notes				VARCHAR(1024),
	@filePath			VARCHAR(256),
	@delete				BIT	= 0			
AS BEGIN

	BEGIN TRY
		IF(@comicId = 0) BEGIN							-- ADD COMIC
			
			INSERT	INTO comics(title, filetypeId, publisherId, publicationDate, [description], notes, filePath) 
					VALUES (@title, @filetypeId, @publisherId, @publicationDate, @description, @notes, @filePath)
			SELECT	@@IDENTITY AS comicId,
					[success] = CAST(1 AS BIT)

		END ELSE IF(@delete = 1) BEGIN					-- SOFT DELETE COMIC

			IF NOT EXISTS (SELECT NULL FROM comics WHERE comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				UPDATE comics
				SET isDeleted = 1
				WHERE comicId = @comicId
				SELECT	0 AS comicId,
						[success] = CAST(1 AS BIT)

			END

		END ELSE BEGIN									-- UPDATE COMIC

			IF NOT EXISTS (SELECT NULL FROM comics WHERE comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF NOT EXISTS (SELECT NULL FROM fileTypes WHERE fileTypeId = @filetypeId) BEGIN
				SELECT	[message] = 'That fileTypeId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF NOT EXISTS (SELECT NULL FROM publishers WHERE publisherId = @publisherId) BEGIN
				SELECT	[message] = 'That publisherId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				UPDATE comics
				SET	title = @title, filetypeId = @filetypeId, publisherId = @publisherId, publicationDate = @publicationDate, 
					[description] = @description, notes = @notes, filePath = @filePath
				WHERE comicId = @comicId
				SELECT	@comicId AS comicId,
						[success] = CAST(1 AS BIT)
			END

		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT(	'@comicId = ', @comicId,
													', @title = ', @title,
													', @filetypeId = ', @filetypeId,
													', @publisherId = ', @publisherId,
													', @publicationDate = ', @publicationDate,
													', @description = ', @description,
													', @notes = ', @notes,
													', @filePath = ', @filePath,
													', @delete = ', @delete
													)
		EXEC spSave_Error @params = @errorParams

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

END
GO

/* =====================================================================

	Name:           spHardDeleteComic
	Purpose:        Hard deletes a comic to/from the database.

======================================================================== */
CREATE PROCEDURE spHardDeleteComic
	@comicId			INT = 0
AS BEGIN

	BEGIN TRY
		IF(@comicId = 0) BEGIN							-- HARD DELETE ALL COMICS MARKED AS ISDELETED

			DELETE FROM comics
			WHERE isDeleted = 1
			SELECT [success] = CAST(1 AS BIT)

		END ELSE BEGIN									-- HARD DELETE A SPECIFIC COMIC

			IF NOT EXISTS (SELECT NULL FROM comics WHERE comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				DELETE FROM comics
				WHERE comicId = @comicId
				SELECT	0 AS comicId,
						[success] = CAST(1 AS BIT)

			END

		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT('@comicId = ', @comicId)
		EXEC spSave_Error @params = @errorParams

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

END
GO

/* =====================================================================

	Name:           spAddUpdateDeleteTag
	Purpose:        Adds/Updates/Deletes a comic author to/from the database.

======================================================================== */
CREATE PROCEDURE spAddDeleteComicAuthor
	@personId					INT,
	@comicId					INT,
	@delete						BIT = 0
 AS BEGIN

	BEGIN TRY
		IF(@delete = 0) BEGIN							-- ADD COMIC AUTHOR

			IF NOT EXISTS (SELECT NULL FROM people WHERE personId = @personId) BEGIN
				SELECT	[message] = 'That personId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF NOT EXISTS (SELECT NULL FROM comics WHERE comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF EXISTS (SELECT NULL FROM comicAuthors WHERE authorId = @personId AND comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicAuthor already exists.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				INSERT	INTO comicAuthors(authorId, comicId) 
				VALUES (@personId, @comicId)
				SELECT	@personId AS authorId,
						@comicId AS comicId,
						[success] = CAST(1 AS BIT)

			END

		END ELSE BEGIN									-- DELETE COMIC AUTHOR

			IF NOT EXISTS (SELECT NULL FROM people WHERE personId = @personId) BEGIN
				SELECT	[message] = 'That personId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF NOT EXISTS (SELECT NULL FROM comics WHERE comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				DELETE FROM comicAuthors
				WHERE authorId = @personId AND comicId = @comicId
				SELECT	0 AS personId,
						0 AS comicId,
						[success] = CAST(1 AS BIT)

			END
		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT(	'@personId = ', @personId,
													', @comicId = ', @comicId,
													', @delete = ', @delete
													)
		EXEC spSave_Error @params = @errorParams

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

 END
GO

/* =====================================================================

	Name:           spAddUpdateDeleteTag
	Purpose:        Adds/Updates/Deletes a comic illustrator to/from the database.

======================================================================== */
CREATE PROCEDURE spAddDeleteComicIllustrator
	@personId				INT,
	@comicId					INT,
	@delete						BIT = 0
 AS BEGIN

	BEGIN TRY
		IF(@delete = 0) BEGIN							-- ADD COMIC ILLUSTRATOR

			IF NOT EXISTS (SELECT NULL FROM people WHERE personId = @personId) BEGIN
				SELECT	[message] = 'That personId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF NOT EXISTS (SELECT NULL FROM comics WHERE comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF EXISTS (SELECT NULL FROM comicIllustrators WHERE illustratorId = @personId AND comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicIllustrator already exists.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				INSERT	INTO comicIllustrators(illustratorId, comicId) 
				VALUES (@personId, @comicId)
				SELECT	@personId AS illustratorId,
						@comicId AS comicId,
						[success] = CAST(1 AS BIT)

			END

		END ELSE BEGIN									-- DELETE COMIC ILLUSTRATOR

			IF NOT EXISTS (SELECT NULL FROM people WHERE personId = @personId) BEGIN
				SELECT	[message] = 'That personId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF NOT EXISTS (SELECT NULL FROM comics WHERE comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				DELETE FROM comicIllustrators
				WHERE illustratorId = @personId AND comicId = @comicId
				SELECT	0 AS personId,
						0 AS comicId,
						[success] = CAST(1 AS BIT)

			END
		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT(	'@personId = ', @personId,
													', @comicId = ', @comicId,
													', @delete = ', @delete
													)
		EXEC spSave_Error @params = @errorParams

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

 END
GO

/* =====================================================================

	Name:           spAddUpdateDeleteTag
	Purpose:        Adds/Updates/Deletes a comic tag to/from the database.

======================================================================== */
CREATE PROCEDURE spAddDeleteComicTag
	@comicId					INT,
	@tagId						INT,
	@delete						BIT = 0
 AS BEGIN

	BEGIN TRY
		IF(@delete = 0) BEGIN							-- ADD COMIC TAG

			IF NOT EXISTS (SELECT NULL FROM comics WHERE comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF NOT EXISTS (SELECT NULL FROM tags WHERE tagId = @tagId) BEGIN
				SELECT	[message] = 'That tagId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF EXISTS (SELECT NULL FROM comicTags WHERE comicId = @comicId AND tagId = @tagId) BEGIN
				SELECT	[message] = 'That comicTag already exists.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				INSERT	INTO comicTags(comicId, tagId) 
				VALUES (@comicId, @tagId)
				SELECT	@comicId AS comicId,
						@tagId AS tagId,
						[success] = CAST(1 AS BIT)

			END

		END ELSE BEGIN									-- DELETE COMIC TAG

			IF NOT EXISTS (SELECT NULL FROM comics WHERE comicId = @comicId) BEGIN
				SELECT	[message] = 'That comicId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE IF NOT EXISTS (SELECT NULL FROM tags WHERE tagId = @tagId) BEGIN
				SELECT	[message] = 'That tagId does not exist.', 
						[success] = CAST(0 AS BIT)
			END ELSE BEGIN

				DELETE FROM comicTags
				WHERE comicId = @comicId AND tagId = @tagId

			END

		END

	END TRY BEGIN CATCH

		IF(@@TRANCOUNT > 0) ROLLBACK TRAN
		DECLARE @errorParams VARCHAR(MAX) = CONCAT(	'@comicId = ', @comicId,
													', @tagId = ', @tagId,
													', @delete = ', @delete
													)
		EXEC spSave_Error @params = @errorParams

	END CATCH

	IF(@@TRANCOUNT > 0) COMMIT TRAN

 END
GO

/* =====================================================================

	Name:           spGetComics
	Purpose:        Gets a list of all comics from the database.

======================================================================== */
CREATE PROCEDURE spGetComics
AS BEGIN

	SELECT * 
	FROM vwComics

END
GO

/* =====================================================================

	Name:           spGetComicById
	Purpose:        Gets a list of all comics from the database by id.

======================================================================== */
CREATE PROCEDURE spGetComicById
	@comicId		INT
AS BEGIN

	SELECT * 
	FROM vwComics
	WHERE comicId = @comicId

END
GO

/* =====================================================================

	Name:           spGetComicByTitle
	Purpose:        Gets a list of all comics from the database by title.

======================================================================== */
CREATE PROCEDURE spGetComicByTitle
	@title			VARCHAR(100),
	@hardMatch		BIT = 0
AS BEGIN

	IF(@hardMatch = 1) BEGIN

		SELECT * 
		FROM vwComics
		WHERE title = @title

	END ELSE BEGIN

		SELECT * 
		FROM vwComics
		WHERE title LIKE CONCAT('%', @title, '%')

	END

END
GO

/* =====================================================================

	Name:           spGetComicByTag
	Purpose:        Gets a list of all comics from the database by tag.

======================================================================== */
CREATE PROCEDURE spGetComicByTag
	@tagId			INT
AS BEGIN

	SELECT c.*, t.*
	FROM tags t
		JOIN comicTags ct On t.tagId = ct.tagId
		JOIN comics c ON ct.comicId = c.comicId
	WHERE t.tagId = @tagId;

END
GO

/* =====================================================================

	Name:           spGetComicByAuthor
	Purpose:        Gets a list of all comics from the database by author.

======================================================================== */
CREATE PROCEDURE spGetComicByAuthor
	@authorId		INT
AS BEGIN

	SELECT c.*, p.personId, p.fName as authorFName, p.lName as authorLName
	FROM vwPeople p
		JOIN comicAuthors ca On p.personId = ca.authorId
		JOIN vwComics c ON ca.comicId = c.comicId
	WHERE p.personId = @authorId

END
GO

/* =====================================================================

	Name:           spGetComicByIllustrator
	Purpose:        Gets a list of all comics from the database by illustrator.

======================================================================== */
CREATE PROCEDURE spGetComicByIllustrator
	@illustratorId		INT
AS BEGIN

	SELECT c.*, p.personId, p.fName as illustratorFName, p.lName as illustratorLName
	FROM vwPeople p
		JOIN comicIllustrators ci On p.personId = ci.illustratorId
		JOIN vwComics c ON ci.comicId = c.comicId
	WHERE p.personId = @illustratorId

END
GO

/* =====================================================================

	Name:           spGetComicByPublisher
	Purpose:        Gets a list of all comics from the database by publisher.

======================================================================== */
CREATE PROCEDURE spGetComicByPublisher
	@publisherId		INT
AS BEGIN

	SELECT c.*, p.publisherId, p.[name] as publisherName
	FROM vwPublishers p
		JOIN vwComics c ON c.publisherId = p.publisherId
	WHERE p.publisherId = @publisherId

END
GO

/* =====================================================================

	Name:           spGetComicByFileType
	Purpose:        Gets a list of all comics from the database by fileType.

======================================================================== */
CREATE PROCEDURE spGetComicByFileType
	@fileTypeId			INT
AS BEGIN

	SELECT c.*, ft.[value] as fileType
	FROM fileTypes ft
		JOIN vwComics c ON ft.fileTypeId = c.filetypeId
	WHERE ft.fileTypeId = @fileTypeId

END
GO

/* =====================================================================

	Name:           spGetPeople
	Purpose:        Gets a list of all people from the database.

======================================================================== */
CREATE PROCEDURE spGetPeople
AS BEGIN

	SELECT *
	FROM vwPeople

END
GO

/* =====================================================================

	Name:           spGetPeopleById
	Purpose:        Gets a list of all people from the database by id.

======================================================================== */
CREATE PROCEDURE spGetPeopleById
	@personId			INT
AS BEGIN

	SELECT *
	FROM vwPeople
	WHERE personId = @personId

END

GO

/* =====================================================================

	Name:           spGetPeopleByName
	Purpose:        Gets a list of all people from the database by name.

======================================================================== */
CREATE PROCEDURE spGetPeopleByName
	@fName				VARCHAR(64),
	@lName				VARCHAR(64),
	@hardMatch			BIT = 0
AS BEGIN

	IF (@hardMatch = 1) BEGIN

		SELECT *
		FROM vwPeople
		WHERE	(fName = @fName) AND 
				(lName = @lName)

	END ELSE BEGIN

		SELECT *
		FROM vwPeople
		WHERE	(fName LIKE CONCAT('%', @fName, '%')) AND
				(lName LIKE CONCAT('%', @lName, '%'))

	END

END
GO

/* =====================================================================

	Name:           spGetPublishers
	Purpose:        Gets a list of all publishers from the database.

======================================================================== */
CREATE PROCEDURE spGetPublishers
AS BEGIN

	SELECT *
	FROM vwPublishers

END
GO

/* =====================================================================

	Name:           spGetPublishersById
	Purpose:        Gets a list of all publishers from the database by id.

======================================================================== */
CREATE PROCEDURE spGetPublishersById
	@publisherId		INT
AS BEGIN

	SELECT *
	FROM vwPublishers
	WHERE publisherId = @publisherId

END
GO

/* =====================================================================

	Name:           spGetPublishersByName
	Purpose:        Gets a list of all publishers from the database by name.

======================================================================== */
CREATE PROCEDURE spGetPublishersByName
	@publisherName		VARCHAR(64),
	@hardMatch			BIT = 0
AS BEGIN

	IF (@hardMatch = 1) BEGIN

		SELECT *
		FROM vwPublishers
		WHERE [name] = @publisherName

	END ELSE BEGIN

		SELECT *
		FROM vwPublishers
		WHERE [name] LIKE CONCAT('%', @publisherName, '%')

	END

END
GO

/* =====================================================================

	Name:           spGetComicAuthors
	Purpose:        Gets a list of all comic authors from the database
					or a specific list of authors of a comic.

======================================================================== */
CREATE PROCEDURE spGetComicAuthors
	@comicId		INT = 0
AS BEGIN
	IF (@comicId = 0) BEGIN

		SELECT *
		FROM vwPeople
		WHERE personId IN (SELECT authorId FROM comicAuthors)

	END ELSE BEGIN

		SELECT p.*
		FROM vwPeople p
			JOIN comicAuthors ca ON p.personId = ca.authorId
		WHERE ca.comicId = @comicId

	END
END
GO

/* =====================================================================

	Name:           spGetComicIllustrator
	Purpose:        Gets a list of all comic illustrators from the database
					or a specific list of illustrators of a comic.

======================================================================== */
CREATE PROCEDURE spGetComicIllustrator
	@comicId		INT = 0
AS BEGIN
	IF (@comicId = 0) BEGIN

		SELECT *
		FROM vwPeople
		WHERE personId IN (SELECT illustratorId FROM comicIllustrators)

	END ELSE BEGIN

		SELECT p.*
		FROM vwPeople p
			JOIN comicIllustrators ci ON p.personId = ci.illustratorId
		WHERE ci.comicId = @comicId

	END
END
GO

/* =====================================================================

	Name:           spGetTags
	Purpose:        Gets a list of all tags from the database.

======================================================================== */
CREATE PROCEDURE spGetTags
AS BEGIN

	SELECT *
	FROM tags

END
GO

/* =====================================================================

	Name:           spGetTagsByComic
	Purpose:        Gets a list of all tags from the database of a specific comic.

======================================================================== */
CREATE PROCEDURE spGetTagsByComic
	@comicId		INT
AS BEGIN

	SELECT t.*
	FROM comicTags ct
		JOIN tags t ON ct.tagId = t.tagId
	WHERE ct.comicId = @comicId

END
GO