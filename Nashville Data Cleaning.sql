-- Converting the SaleDate Column from Datetime to type Date
SELECT SaleDate, CONVERT(Date,SaleDate)
FROM [dbo].[Nashville]

ALTER TABLE Nashville
ADD SaleDateConverted Date

UPDATE Nashville
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted
FROM [dbo].[Nashville]

-- Populating the null cells in the Property Address column
SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [dbo].[Nashville] a
JOIN [dbo].[Nashville] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [dbo].[Nashville] a
JOIN [dbo].[Nashville] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Breaking out Address into individual columns(Address, City, State) 
SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress)) AS City
FROM Nashville

ALTER TABLE Nashville
ADD PropertySplitAddress nvarchar(255)

UPDATE Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Nashville
ADD PropertySplitCity nvarchar(255)

UPDATE Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress))

SELECT OwnerAddress FROM Nashville

-- Splitting the Owner Address into Address, City, State
SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Nashville

ALTER TABLE Nashville
ADD OwnerSplitAddress nvarchar(255)

UPDATE Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Nashville
ADD OwnerSplitCity nvarchar(255)

UPDATE Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Nashville
ADD OwnerSplitState nvarchar(255)

UPDATE Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT COUNT(SoldAsVacant) FROM Nashville

SELECT SoldAsVacant,
CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
 FROM Nashville
 WHERE SoldAsVacant = 'N'

 UPDATE Nashville
 SET SoldAsVacant = CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
 FROM Nashville

 -- Remove Duplicates

 WITH RowNumCTE AS
 (
 SELECT *, ROW_NUMBER() OVER (Partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference ORDER BY UniqueID) row_num
 FROM Nashville
 --ORDER BY ParcelID
 )
DELETE FROM RowNumCTE
 WHERE row_num > 1

-- Delete Unused Columns
ALTER TABLE Nashville
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE Nashville
DROP COLUMN SaleDate


SELECT * FROM Nashville

