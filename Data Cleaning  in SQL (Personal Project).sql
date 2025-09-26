*/

Cleaning Data in SQL Queries

*/

Select *
From dbo.NashvilleHousing

________________________________________________________

-- Standardize Date Format

Select SaleDateConverted,CONVERT (Date,SaleDate)
From dbo.NashvilleHousing

Update NashvilleHousing
Set	SaleDate = CONVERT (Date,SaleDate)

--If it does'nt Update properly

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set	SaleDateConverted = CONVERT (Date,SaleDate)


________________________________________________________________________

-- Populate Property Address data


Select *
From dbo.NashvilleHousing
-- Where PropertyAddress is null
order by ParcelID



Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.NashvilleHousing a
join dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.NashvilleHousing a
join dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



_____________________________________________________________________________________

-- Breaking out Addess into Individual Columns (Address, City, State)


Select PropertyAddress
From dbo.NashvilleHousing
-- Where PropertyAddress is null
-- order by ParcelID


Select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) as Address
From dbo.NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set	PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set	PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress))


Select *
From dbo.NashvilleHousing




Select OwnerAddress
From dbo.NashvilleHousing



Select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From dbo.NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set	OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)


Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set	OwnerSplitCity= PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set	OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)




____________________________________________________________________________________________

--Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2



Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
     Else SoldAsVacant
     End
From dbo.NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
     Else SoldAsVacant
     End



---------------------------------------------------------------------------------

-- Remove Duplicates



With RowNumCTE AS(
Select *,
ROW_NUMBER() Over(
Partition by ParcelID,
             PropertyAddress,
             SalePrice,
             SaleDate,
             LegalReference
             Order by
             UniqueID
             ) Row_Num
From dbo.NashvilleHousing
--Order by ParcelID
)
Delete
From RowNumCTE
where Row_Num > 1
--order by PropertyAddress


__________________________________________________________________________________

--Delete Unused Columns



Select *
from dbo.NashvilleHousing


Alter Table dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter Table dbo.NashvilleHousing
Drop Column SaleDate


