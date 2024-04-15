/*

Create Data in SQL Queries

*/

Select*
From PortfolioProject..NashVilleHousing

-- Standard Date Format

Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject..NashVilleHousing

ALTER TABLE PortfolioProject..NashVilleHousing
ADD SaleDateConverted Date;

Update PortfolioProject..NashVilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted
From PortfolioProject..NashVilleHousing


-- Populate Property Address date

Select *
From PortfolioProject..NashVilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress
, b.ParcelID, b.PropertyAddress
, ISNULL(a.PropertyAddress,b.PropertyAddress) 
From PortfolioProject..NashVilleHousing a
Join PortfolioProject..NashVilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <>  b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
From PortfolioProject..NashVilleHousing a
Join PortfolioProject..NashVilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <>  b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Column (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashVilleHousing

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

FROM PortfolioProject..NashVilleHousing

ALTER TABLE PortfolioProject..NashVilleHousing
ADD PropertySplitAddress nvarchar(255);

Update PortfolioProject..NashVilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject..NashVilleHousing
ADD PropertySplitCity nvarchar(255);

Update PortfolioProject..NashVilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
From PortfolioProject..NashVilleHousing



-- Cleaning Owner Address into Individual Column



Select OwnerAddress
From PortfolioProject..NashVilleHousing

Select 
PARSENAME(Replace(OwnerAddress,',','.'), 3)
,PARSENAME(Replace(OwnerAddress,',','.'), 2)
,PARSENAME(Replace(OwnerAddress,',','.'), 1)
From PortfolioProject..NashVilleHousing


ALTER TABLE PortfolioProject..NashVilleHousing
ADD OwnerSplitAddress nvarchar(255);

Update PortfolioProject..NashVilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)

ALTER TABLE PortfolioProject..NashVilleHousing
ADD OwnerSplitCity nvarchar(255);

Update PortfolioProject..NashVilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'), 2)

ALTER TABLE PortfolioProject..NashVilleHousing
ADD OwnerSplitState nvarchar(255);

Update PortfolioProject..NashVilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1)

Select *
From PortfolioProject..NashVilleHousing



-- Change Y and N to Yes and No in 'SoldasVacant' field

Select distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashVilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END
 From PortfolioProject..NashVilleHousing


 Update PortfolioProject..NashVilleHousing
 SET SoldAsVacant = CASE
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END


--- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

From PortfolioProject..NashVilleHousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
--Order By PropertyAddress


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

From PortfolioProject..NashVilleHousing
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order By PropertyAddress

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

From PortfolioProject..NashVilleHousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
Order By PropertyAddress


-- Delete Unusal Columns


Select *
From PortfolioProject..NashVilleHousing


ALTER TABLE PortfolioProject..NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashVilleHousing
DROP COLUMN SaleDate