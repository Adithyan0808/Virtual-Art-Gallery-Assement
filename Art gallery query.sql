create table Artists(
	artistID int primary key,
	name varchar(255) not null,
	biography text,
	nationality varchar(100)
)

create table categories(
	categoryID int primary key,
	name varchar(100) not null
)
create table artworks(
	artworkID int primary key,
	title varchar(255) not null,
	artistID int,
	categoryID int,
	year int,
	description text,
	imageURL varchar(255),
	foreign key (artistID) references artists(artistID),
	 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
)

CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT )
 CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID)
 )

 INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian')


 INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');
 INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picassos powerful anti-war mural.', 'guernica.jpg')
 select * from artworks
 INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.')
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2)
 select * from ExhibitionArtworks
 -- 1.Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks

select a.name , count(a.artistID) as Number_of_Artworks
from Artists as a
join artworks as ar on a.artistID = ar.artistID
group by a.name
order by Number_of_Artworks

-- 2.List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order

select 
	ar.title,
	a.nationality,
	ar.year
from artworks as ar
join Artists as a on a.artistID = ar.artistID
group by nationality , ar.title , ar.year
having nationality in ('spanish' , 'dutch')
order by year desc

-- 3.Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category

select
	a.name as Artist_Name,
	c.name as category,
	count(ar.artistID) as [Number of arts]
from Artists as a
join artworks as ar on a.artistID = ar.artistID
join categories as c on ar.categoryID = c.categoryID
group by c.name , a.name
having c.name = 'Painting'


-- 4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories.

select
	a.name as [Artist Name],
	ar.title as [Art Title],
	c.name as [Category Name],
	ex.Title
from artworks as ar
join Artists as a on a.artistID = ar.artistID
join categories as c on c.categoryID = ar.categoryID
join ExhibitionArtworks as er on ar.artworkID = er.ArtworkID
join Exhibitions as ex on er.ExhibitionID = ex.ExhibitionID
group by a.name,ar.title,c.name,ex.Title
having ex.Title = 'Modern Art Masterpieces'

-- 5. Find the artists who have more than two artworks in the gallery

select
	a.name as [Artist Name],
	count(ar.artistID) as [Count of Arts]
from Artists as a
join artworks as ar on a.artistID = ar.artistID
group by a.name
having count(ar.artistID) >= 2

-- 6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions

select
	ar.title as [Title of Artworks],
	e.Title as [Exhibition Name]
from artworks as ar
join ExhibitionArtworks as er on ar.artworkID = er.ArtworkID
join Exhibitions as e on er.exhibitionID = e.exhibitionID
group by ar.title,e.Title
having e.Title in ('Modern Art Masterpieces','Renaissance Art')

-- 7. Find the total number of artworks in each category
select
	c.name as [Category Name],
	count(artistID) as [Number of Artworks]
from artworks as ar
join categories as c on ar.categoryID = c.categoryID
group by c.name

-- 8. List artists who have more than 3 artworks in the gallery

select
	a.name as [Artist Name],
	count(ar.artistID) as [Number Of Arts]
from Artists as a
join artworks as ar on a.artistID = ar.artistID
group by a.name
having count(ar.artistID)>3

-- 9.Find the artworks created by artists from a specific nationality (e.g., Spanish).

select
	a.name as [Artist Name],
	ar.title as [Artwork Name],
	a.nationality as [Nationality]
from artworks as ar
join Artists as a on ar.artistID = a.artistID
where a.nationality = 'Spanish'


-- 10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci

select
	e.Title as [Exhibition Name]
from artworks as ar
join Artists as a on ar.artistID = a.artistID
join ExhibitionArtworks as ex on ar.artworkID = ex.ArtworkID
join Exhibitions as e on e.ExhibitionID = ex.ExhibitionID
where a.name in ('Vincent van Gogh' , 'Leonardo da Vinci')
group by e.Title
having count(a.name) = 2

-- 11.Find all the artworks that have not been included in any exhibition

select
    ar.Title as [Artwork Name]
from Artworks as ar
left join ExhibitionArtworks as ea on ar.ArtworkID = ea.ArtworkID
where ea.ArtworkID IS NULL;

-- 12. List artists who have created artworks in all available categories.

select
	a.name as [Artist Name]
from artworks as ar
join Artists as a on ar.artistID = a.artistID
join categories as c on ar.categoryID = c.categoryID
group by a.name
having count(distinct c.categoryID) = (select count(*) from categories)

-- 13. List the total number of artworks in each category

select
	c.name as [Category Name],
	count(ar.artworkID) as [Total Artworks]
from artworks as ar
join Artists as a on ar.artistID = a.artistID
join categories as c on ar.categoryID = c.categoryID
group by c.name


-- 14. Find the artists who have more than 2 artworks in the gallery

select
	a.name as [Artist]
from artworks as ar
join Artists as a on ar.artistID = a.artistID
group by a.name
having count(ar.artworkID) > 2

-- 15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.
select 
	c.Name AS [Category Name],
    AVG(ar.Year) AS [Average Year]
from Categories as c
join Artworks as ar on c.CategoryID = ar.CategoryID
group by c.Name
having COUNT(ar.ArtworkID) > 1;

--16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.
select
    ar.Title as [Artwork Name]
from Artworks as ar
left join ExhibitionArtworks as ea on ar.ArtworkID = ea.ArtworkID
where ea.ArtworkID IS NULL;

--17. Find the categories where the average year of artworks is greater than the average year of all artworks
select 
    c.Name as [Category Name],
    avg(ar.Year) as [Average Year]
from Categories as c
join Artworks as ar on c.CategoryID = ar.CategoryID
group by c.Name
having avg(ar.Year) > (select avg(Year) from Artworks);

--18. List the artworks that were not exhibited in any exhibition.
select
    ar.Title as [Artwork Name]
from Artworks as ar
join ExhibitionArtworks as ea on ar.ArtworkID = ea.ArtworkID
where ea.ArtworkID is null;

--19. Show artists who have artworks in the same category as "Mona Lisa."
select  
    a.Name AS [Artist Name]
from Artists as a
join Artworks as ar on a.ArtistID = ar.ArtistID
where ar.CategoryID = (SELECT CategoryID FROM Artworks WHERE Title = 'Mona Lisa');

-- 20. List the names of artists and the number of artworks they have in the gallery.
select 
    a.Name AS [Artist Name],
    COUNT(ar.ArtworkID) AS [Number of Artworks]
from Artists as a
join Artworks as ar on a.ArtistID = ar.ArtistID
group by a.Name;





