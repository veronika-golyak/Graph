USE master;
DROP DATABASE IF EXISTS BookRecommendation;
CREATE DATABASE BookRecommendation;
USE BookRecommendation;

-- Создаем узлы
CREATE TABLE People
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Books
(
    id INT NOT NULL PRIMARY KEY,
    title NVARCHAR(100) NOT NULL
) AS NODE;

CREATE TABLE Authors
(
    id INT NOT NULL PRIMARY KEY,
    initials NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Genres
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;

-- Создаем рёбра
CREATE TABLE Wrote AS EDGE;

CREATE TABLE Rated
(
    rating INT CHECK (rating BETWEEN 1 AND 5) 
) AS EDGE;

CREATE TABLE BelongsTo AS EDGE;

ALTER TABLE Wrote ADD CONSTRAINT EC_Wrote CONNECTION (Authors TO Books);
ALTER TABLE Rated ADD CONSTRAINT EC_Rated CONNECTION (People TO Books);
ALTER TABLE BelongsTo ADD CONSTRAINT EC_BelongsTo CONNECTION (Books TO Genres);

INSERT INTO People (id, name) VALUES 
(1, 'Иван'), 
(2, 'Анна'), 
(3, 'Сергей'), 
(4, 'Мария'), 
(5, 'Дмитрий'), 
(6, 'Ольга'), 
(7, 'Алексей'), 
(8, 'Наталья'), 
(9, 'Павел'), 
(10, 'Елена');

SELECT * FROM People;

INSERT INTO Books (id, title) VALUES 
(1, 'Война и мир'), 
(2, '1984'), 
(3, 'Убить пересмешника'), 
(4, 'Анна Каренина'), 
(5, 'Братья Карамазовы'), 
(6, 'Мастер и Маргарита'), 
(7, 'Один день Ивана Денисовича'), 
(8, 'Преступление и наказание'), 
(9, 'Великий Гэтсби'), 
(10, 'Тихий Дон'),
(11, 'Воскресение'), 
(12, 'Скотный двор'), 
(13, 'Идиот'), 
(14, 'Белая гвардия'), 
(15, 'Собачье сердце'),
(16, 'Фиеста');

SELECT * FROM Books;

INSERT INTO Authors (id, initials) VALUES
(1, 'Л. Н. Толстой'),          
(2, 'Дж. Оруэлл'),            
(3, 'Харпер Ли'),              
(4, 'Ф. М. Достоевский'),      
(5, 'Ф. С. Фицджеральд'),      
(6, 'М. А. Булгаков'),         
(7, 'А. И. Солженицын'),       
(8, 'М. А. Шолохов'),         
(9, 'Э. Хемингуэй'); 

SELECT * FROM Authors;

DELETE FROM Genres;
INSERT INTO Genres (id, name) VALUES 
(1, 'Роман'),
(2, 'Антиутопия'),
(3, 'Классика'), 
(4, 'Современная проза'), 
(5, 'Драма'), 
(6, 'Фантастика'), 
(7, 'Исторический роман'),
(8, 'Философия'), 
(9, 'Трагедия'), 
(10, 'Социальная проза');

SELECT * FROM Genres;


INSERT INTO Wrote ($from_id, $to_id) VALUES
-- Л. Н. Толстой (id=1, 3 книги)
((SELECT $node_id FROM Authors WHERE id = 1), (SELECT $node_id FROM Books WHERE id = 1)),  -- Война и мир
((SELECT $node_id FROM Authors WHERE id = 1), (SELECT $node_id FROM Books WHERE id = 4)),  -- Анна Каренина
((SELECT $node_id FROM Authors WHERE id = 1), (SELECT $node_id FROM Books WHERE id = 11)), -- Воскресение

-- Дж. Оруэлл (id=2, 2 книги)
((SELECT $node_id FROM Authors WHERE id = 2), (SELECT $node_id FROM Books WHERE id = 2)),  -- 1984
((SELECT $node_id FROM Authors WHERE id = 2), (SELECT $node_id FROM Books WHERE id = 12)), -- Скотный двор

-- Харпер Ли (id=3, 1 книга)
((SELECT $node_id FROM Authors WHERE id = 3), (SELECT $node_id FROM Books WHERE id = 3)),  -- Убить пересмешника

-- Достоевский (id=4, 3 книги)
((SELECT $node_id FROM Authors WHERE id = 4), (SELECT $node_id FROM Books WHERE id = 5)),  -- Братья Карамазовы
((SELECT $node_id FROM Authors WHERE id = 4), (SELECT $node_id FROM Books WHERE id = 8)),  -- Преступление и наказание
((SELECT $node_id FROM Authors WHERE id = 4), (SELECT $node_id FROM Books WHERE id = 13)), -- Идиот

-- Фицджеральд (id=5, 1 книга)
((SELECT $node_id FROM Authors WHERE id = 5), (SELECT $node_id FROM Books WHERE id = 9)),  -- Великий Гэтсби

-- Булгаков (id=6, 3 книги)
((SELECT $node_id FROM Authors WHERE id = 6), (SELECT $node_id FROM Books WHERE id = 6)),  -- Мастер и Маргарита
((SELECT $node_id FROM Authors WHERE id = 6), (SELECT $node_id FROM Books WHERE id = 14)), -- Белая гвардия
((SELECT $node_id FROM Authors WHERE id = 6), (SELECT $node_id FROM Books WHERE id = 15)), -- Собачье сердце

-- Солженицын (id=7, 1 книга)
((SELECT $node_id FROM Authors WHERE id = 7), (SELECT $node_id FROM Books WHERE id = 7)),  -- Один день Ивана Денисовича

-- Шолохов (id=8, 1 книга)
((SELECT $node_id FROM Authors WHERE id = 8), (SELECT $node_id FROM Books WHERE id = 10)), -- Тихий Дон

-- Хемингуэй (id=9, 1 книга)
((SELECT $node_id FROM Authors WHERE id = 9), (SELECT $node_id FROM Books WHERE id = 16));  -- Фиеста
SELECT * FROM Wrote;

-- Вставляем данные в рёбра Rated
INSERT INTO Rated ($from_id, $to_id, rating)
VALUES 
((SELECT $node_id FROM People WHERE id = 1), (SELECT $node_id FROM Books WHERE id = 1), 5),  
((SELECT $node_id FROM People WHERE id = 1), (SELECT $node_id FROM Books WHERE id = 11), 4),
((SELECT $node_id FROM People WHERE id = 2), (SELECT $node_id FROM Books WHERE id = 2), 4),  
((SELECT $node_id FROM People WHERE id = 2), (SELECT $node_id FROM Books WHERE id = 12), 5),
((SELECT $node_id FROM People WHERE id = 3), (SELECT $node_id FROM Books WHERE id = 3), 3),  
((SELECT $node_id FROM People WHERE id = 3), (SELECT $node_id FROM Books WHERE id = 13), 4),
((SELECT $node_id FROM People WHERE id = 4), (SELECT $node_id FROM Books WHERE id = 4), 5),  
((SELECT $node_id FROM People WHERE id = 4), (SELECT $node_id FROM Books WHERE id = 14), 4),
((SELECT $node_id FROM People WHERE id = 5), (SELECT $node_id FROM Books WHERE id = 5), 4),  
((SELECT $node_id FROM People WHERE id = 5), (SELECT $node_id FROM Books WHERE id = 15), 3),
((SELECT $node_id FROM People WHERE id = 6), (SELECT $node_id FROM Books WHERE id = 6), 5),  
((SELECT $node_id FROM People WHERE id = 6), (SELECT $node_id FROM Books WHERE id = 16), 4),
((SELECT $node_id FROM People WHERE id = 7), (SELECT $node_id FROM Books WHERE id = 7), 2),  
((SELECT $node_id FROM People WHERE id = 8), (SELECT $node_id FROM Books WHERE id = 8), 3),  
((SELECT $node_id FROM People WHERE id = 9), (SELECT $node_id FROM Books WHERE id = 9), 4),  
((SELECT $node_id FROM People WHERE id = 10), (SELECT $node_id FROM Books WHERE id = 10), 5); 

SELECT * FROM Rated;

INSERT INTO BelongsTo ($from_id, $to_id) VALUES
((SELECT $node_id FROM Books WHERE id = 1), (SELECT $node_id FROM Genres WHERE id = 7)),  -- Война и мир → Исторический роман
((SELECT $node_id FROM Books WHERE id = 2), (SELECT $node_id FROM Genres WHERE id = 2)),  -- 1984 → Антиутопия
((SELECT $node_id FROM Books WHERE id = 3), (SELECT $node_id FROM Genres WHERE id = 5)),  -- Убить пересмешника → Драма
((SELECT $node_id FROM Books WHERE id = 4), (SELECT $node_id FROM Genres WHERE id = 1)),  -- Анна Каренина → Роман
((SELECT $node_id FROM Books WHERE id = 5), (SELECT $node_id FROM Genres WHERE id = 8)),  -- Братья Карамазовы → Философия
((SELECT $node_id FROM Books WHERE id = 6), (SELECT $node_id FROM Genres WHERE id = 6)),  -- Мастер и Маргарита → Фантастика
((SELECT $node_id FROM Books WHERE id = 7), (SELECT $node_id FROM Genres WHERE id = 10)), -- Один день Ивана Денисовича → Социальная проза
((SELECT $node_id FROM Books WHERE id = 8), (SELECT $node_id FROM Genres WHERE id = 8)),  -- Преступление и наказание → Философия
((SELECT $node_id FROM Books WHERE id = 9), (SELECT $node_id FROM Genres WHERE id = 4)),  -- Великий Гэтсби → Современная проза
((SELECT $node_id FROM Books WHERE id = 10), (SELECT $node_id FROM Genres WHERE id = 7)), -- Тихий Дон → Исторический роман
((SELECT $node_id FROM Books WHERE id = 11), (SELECT $node_id FROM Genres WHERE id = 1)), -- Воскресение → Роман
((SELECT $node_id FROM Books WHERE id = 12), (SELECT $node_id FROM Genres WHERE id = 2)), -- Скотный двор → Антиутопия
((SELECT $node_id FROM Books WHERE id = 13), (SELECT $node_id FROM Genres WHERE id = 5)), -- Идиот → Драма
((SELECT $node_id FROM Books WHERE id = 14), (SELECT $node_id FROM Genres WHERE id = 7)), -- Белая гвардия → Исторический роман
((SELECT $node_id FROM Books WHERE id = 15), (SELECT $node_id FROM Genres WHERE id = 6)), -- Собачье сердце → Фантастика
((SELECT $node_id FROM Books WHERE id = 16), (SELECT $node_id FROM Genres WHERE id = 4)); -- Фиеста → Современная проза
SELECT * FROM BelongsTo;

SELECT p.name AS user_name, b.title AS book_title, r.rating
FROM People p, Rated r, Books b
WHERE MATCH(p-(r)->b)
AND p.name = 'Иван';

SELECT a.initials AS author, b.title AS book
FROM Authors a, Wrote w, Books b
WHERE MATCH(a-(w)->b)
ORDER BY a.initials;

SELECT b.title AS book_title, g.name AS genre, r.rating
FROM Books b, BelongsTo bt, Genres g, Rated r, People p
WHERE MATCH(b-(bt)->g AND p-(r)->b)
AND g.name = 'Роман'
AND r.rating = 5;

SELECT DISTINCT p.name AS user_name, a.initials AS author
FROM People p, Rated r, Books b, Wrote w, Authors a
WHERE MATCH(p-(r)->b AND a-(w)->b)
AND a.initials = 'Ф. М. Достоевский';

SELECT b.title AS book, a.initials AS author, g.name AS genre
FROM Books b, Authors a, Genres g, Wrote w, BelongsTo bt
WHERE MATCH(a-(w)->b AND b-(bt)->g)
ORDER BY b.title;

CREATE TABLE FriendsOf AS EDGE;

ALTER TABLE FriendsOf ADD CONSTRAINT EC_FriendsOf CONNECTION (People TO People);

-- Добавляем дружеские связи (взаимные)
INSERT INTO FriendsOf ($from_id, $to_id) VALUES
-- Иван (id=1) дружит с Анной (id=2) и Сергеем (id=3)
((SELECT $node_id FROM People WHERE id = 1), (SELECT $node_id FROM People WHERE id = 2)),
((SELECT $node_id FROM People WHERE id = 1), (SELECT $node_id FROM People WHERE id = 3)),

-- Анна (id=2) дружит с Марией (id=4)
((SELECT $node_id FROM People WHERE id = 2), (SELECT $node_id FROM People WHERE id = 4)),

-- Сергей (id=3) дружит с Дмитрием (id=5) и Ольгой (id=6)
((SELECT $node_id FROM People WHERE id = 3), (SELECT $node_id FROM People WHERE id = 5)),
((SELECT $node_id FROM People WHERE id = 3), (SELECT $node_id FROM People WHERE id = 6)),

-- Мария (id=4) дружит с Алексеем (id=7)
((SELECT $node_id FROM People WHERE id = 4), (SELECT $node_id FROM People WHERE id = 7)),

-- Дмитрий (id=5) дружит с Натальей (id=8)
((SELECT $node_id FROM People WHERE id = 5), (SELECT $node_id FROM People WHERE id = 8)),

-- Ольга (id=6) дружит с Еленой (id=10)
((SELECT $node_id FROM People WHERE id = 6), (SELECT $node_id FROM People WHERE id = 10)),

-- Алексей (id=7) дружит с Павлом (id=9)
((SELECT $node_id FROM People WHERE id = 7), (SELECT $node_id FROM People WHERE id = 9)),

-- Наталья (id=8) дружит с Еленой (id=10)
((SELECT $node_id FROM People WHERE id = 8), (SELECT $node_id FROM People WHERE id = 10)),

-- Павел (id=9) дружит с Иваном (id=1) (замыкаем круг)
((SELECT $node_id FROM People WHERE id = 9), (SELECT $node_id FROM People WHERE id = 1));

SELECT * FROM FriendsOf;

SELECT Person1.name AS PersonName
 , STRING_AGG(Person2.name, '->') WITHIN GROUP (GRAPH PATH) AS
Friends
FROM People AS Person1
 , FriendsOf FOR PATH AS fo
 , People FOR PATH AS Person2
WHERE MATCH(SHORTEST_PATH(Person1(-(fo)->Person2)+))
 AND Person1.name = N'Иван';

INSERT INTO FriendsOf ($from_id, $to_id)
VALUES ((SELECT $node_id FROM People WHERE id = 1), (SELECT
$node_id FROM People WHERE id = 4))

WITH T1 AS
(
SELECT Person1.name AS PersonName
 , STRING_AGG(Person2.name, '->') WITHIN GROUP (GRAPH PATH)
AS Friends
 , LAST_VALUE(Person2.name) WITHIN GROUP (GRAPH PATH) AS
LastNode
FROM People AS Person1
 , FriendsOf FOR PATH AS fo
 , People FOR PATH AS Person2
WHERE MATCH(SHORTEST_PATH(Person1(-(fo)->Person2)+))
 AND Person1.name = 'Иван'
)
SELECT PersonName, Friends
FROM T1
WHERE LastNode = 'Павел'