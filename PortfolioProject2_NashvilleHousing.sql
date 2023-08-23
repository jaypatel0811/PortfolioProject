--Cleaning data through SQL

SELECT *
 FROM [PortfolioProject].[dbo].[NashvilleHousing]

 --Standardize the date format

 Select SaleDate,convert(date,SaleDate)
 FROM [PortfolioProject].[dbo].[NashvilleHousing]

 Update [PortfolioProject].[dbo].[NashvilleHousing]
 set SaleDate = convert(date,SaleDate)

 Alter table NashvilleHousing
 add SaleDateUpdated date

 Update [PortfolioProject].[dbo].[NashvilleHousing]
 set SaleDateUpdated = convert(date,SaleDate)

  Select SaleDateUpdated,convert(date,SaleDateUpdated)
 FROM [PortfolioProject].[dbo].[NashvilleHousing]

--Populate Property address

Select * 
From NashvilleHousing
where PropertyAddress is null

Select a.PropertyAddress,a.ParcelID,b.PropertyAddress,b.ParcelID,ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing as a
join NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID

Update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing as a
join NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID

Select * 
From NashvilleHousing

-- Split PropertyAddress into Address and City


 Alter table NashvilleHousing
 add PropertySplitAddress nvarchar(255)

 Update [PortfolioProject].[dbo].[NashvilleHousing]
 set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1)

 
 Alter table NashvilleHousing
 add PropertySplitCity nvarchar(255)

 Update [PortfolioProject].[dbo].[NashvilleHousing]
 set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' ,PropertyAddress)+1,len(PropertyAddress))

  Select *
 FROM [PortfolioProject].[dbo].[NashvilleHousing]

 --Splitting Owner Address

 Select OwnerAddress
 FROM [PortfolioProject].[dbo].[NashvilleHousing]


  Select OwnerAddress,
  PARSENAME(Replace(OwnerAddress,',','.'),3),
  PARSENAME(Replace(OwnerAddress,',','.'),2),
  PARSENAME(Replace(OwnerAddress,',','.'),1)
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

  Alter table NashvilleHousing
 add OwnerSplitAddress nvarchar(255)

 Update [PortfolioProject].[dbo].[NashvilleHousing]
 set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

  Alter table NashvilleHousing
 add OwnerSplitCity nvarchar(255)

 Update [PortfolioProject].[dbo].[NashvilleHousing]
 set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

   Alter table NashvilleHousing
 add OwnerSplitState nvarchar(255)

 Update [PortfolioProject].[dbo].[NashvilleHousing]
 set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

 Select *
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

  --Convert Y and N to Yes and No in SoldAsVacant

  Select SoldAsVacant,
  Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
FROM [PortfolioProject].[dbo].[NashvilleHousing]

  Update [PortfolioProject].[dbo].[NashvilleHousing]
  set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end 
Select *
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

Select distinct(SoldAsVacant)
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

  --Remove Duplicates

; WITH RowNumCTE AS (
Select * , 
   ROW_NUMBER() over (
        partition by ParcelID,
                     PropertyAddress,
				     SaleDate,
				     SalePrice,
				     LegalReference
				        order by 
				        UniqueID
				      ) as rownum
				   FROM PortfolioProject.dbo.NashvilleHousing
				)

				  Delete 
				  FROM [PortfolioProject].[dbo].[NashvilleHousing]
				  where rownum > 1
				  order by ParcelID




--  Remove Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing


Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress














































