-- Find the most common Pet names
SELECT p.Name, COUNT(p.Name)as NameCount FROM [dbo].[P9-Pets] AS p
LEFT OUTER JOIN [dbo].[P9-Owners] AS  own
ON p.OwnerID = own.OwnerID
GROUP BY p.Name
ORDER BY NameCount DESC

-- How many Pets based by gender were attended to
SELECT Gender, COUNT(Gender)AS GenderCount FROM [dbo].[P9-Pets] AS p
LEFT OUTER JOIN [dbo].[P9-Owners] AS  own
ON p.OwnerID = own.OwnerID
GROUP BY Gender

--How many kinds of different pets were attended to
SELECT Kind, COUNT(Kind) AS KindCount  FROM [dbo].[P9-Pets] AS p
LEFT OUTER JOIN [dbo].[P9-Owners] AS  own
ON p.OwnerID = own.OwnerID
GROUP BY Kind

--How many different kinds of each type of pet were attended to in different Cities
SELECT own.City, Kind, COUNT(Kind) AS KindCount FROM [dbo].[P9-Pets] AS p
LEFT OUTER JOIN [dbo].[P9-Owners] AS  own
ON p.OwnerID = own.OwnerID
GROUP BY Kind,City

--Average Age of pets in each city
SELECT own.City, AVG(CAST(Age AS int))AverAge FROM [dbo].[P9-Pets] AS p
LEFT OUTER JOIN [dbo].[P9-Owners] AS  own
ON p.OwnerID = own.OwnerID
Group by City


WITH Firstn (PetID , Name,Kind,Gender,Age,OwnerID, OwnerName, City, StateFull,ZipCode)
 AS
(
SELECT PetID, p.Name,Kind,Gender,Age, own.OwnerID,(own.Name + ' ' + own.Surname) AS OwnerName, City, StateFull,ZipCode FROM [dbo].[P9-Pets] AS p
LEFT OUTER JOIN [dbo].[P9-Owners] AS  own
ON p.OwnerID = own.OwnerID
)
SELECT * FROM Firstn
LEFT OUTER JOIN [dbo].[P9-ProceduresHistory] hist
ON Firstn.PetID = hist.PetID
JOIN [dbo].[P9-ProceduresDetails] det
ON hist.ProcedureType = det.ProcedureType
AND hist.ProcedureSubCode = det.ProcedureSubCode

Create View PetClinic As
WITH Firstn (PetID , Name,Kind,Gender,Age,OwnerID, OwnerName, City, StateFull,ZipCode)
 AS
(
SELECT PetID, p.Name,Kind,Gender,Age, own.OwnerID,(own.Name + ' ' + own.Surname) AS OwnerName, City, StateFull,ZipCode FROM [dbo].[P9-Pets] AS p
LEFT OUTER JOIN [dbo].[P9-Owners] AS  own
ON p.OwnerID = own.OwnerID
)
SELECT Firstn.PetID , Name,Kind,Gender,Age,OwnerID, OwnerName, City, StateFull,ZipCode,hist.ProcedureSubCode,hist.ProcedureType,det.Description,det.Price FROM Firstn
LEFT OUTER JOIN [dbo].[P9-ProceduresHistory] hist
ON Firstn.PetID = hist.PetID
JOIN [dbo].[P9-ProceduresDetails] det
ON hist.ProcedureType = det.ProcedureType
AND hist.ProcedureSubCode = det.ProcedureSubCode