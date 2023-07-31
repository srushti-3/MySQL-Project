/*
cleanig data in SQL server

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

--standardize date format

SELECT SaleDateConverted, CONVERT ( Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT ( Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT ( Date, SaleDate)


--Populate Property Address data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID<> b.ParcelID
AND a.[Unnamed: 0]<>b.[Unnamed: 0]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID<> b.ParcelID
AND a.[Unnamed: 0]<>b.[Unnamed: 0]
WHERE a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

Select Address
From PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(Address,',','.') ,1),
PARSENAME(REPLACE(Address,',','.') ,2),
PARSENAME(REPLACE(Address,',','.') ,3)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(Address, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(Address, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(Address, ',', '.') , 1)

Select *
From PortfolioProject.dbo.NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

-- Remove Duplicates
WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY
[Unnamed: 0]
)row_num
From PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
SELECT * 
FROM RowNumCTE
WHERE row_num>1
ORDER by [Unnamed: 0]


--Delete unused columns


Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN Address, TaxDistrict, PropertyAddress, SaleDate