-- select * from portfolioProject.housing;

select saledate from portfolioProject.housing;

-- convert to standard date format
SELECT saledate, CONVERT(Date, saledate) AS ConvertedDate
FROM portfolioProject.housing;


Alter Table housing 
add saleDateConverted Date;

update housing
set saleDateConverted = convert(date, saleDate)


-- populate property address data
SELECT * 
FROM portfolioProject.housing
where PropertyAddress is null
order by ParcelID;

SELECT * 
FROM portfolioProject.housing a
join portfolioProject.housing b
	on a.ParcelID = b.ParcelID
    and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a 
set propertyAdress = ISNULL(a.propertyAdress, b.propertyAdress)
from portfolioProject.housing a
join portfolioProject.housing b
on a.ParcelID = b.ParcelID
    and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)
select propertyaddress from 
portfolioProject.housing

select 
substring(propertyAdress, 1, charindex(',', propertyaddress) -1) as Address,
substring(propertyAdress, charindex(',', propertyaddress) +1, Len(propertyAddress)) as Address

from portfolioProject.housing

Alter Table housing 
add propertySplitAdress Nvarchar(255);

update housing
set propertySplitAdress = substring(propertyAdress, 1, charindex(',', propertyaddress) -1)

Alter Table housing 
add propertySplitCity Nvarchar(255);

update housing
set propertySplitCity= substring(propertyAdress, charindex(',', propertyaddress) +1, Len(propertyAddress))

select owneraddress 
from  portfolioProject.housing;

SELECT PARSENAME(REPLACE(ownerAddress, ',', '.'), 3),
PARSENAME(REPLACE(ownerAddress, ',', '.'), 2),
PARSENAME(REPLACE(ownerAddress, ',', '.'), 1)
from  portfolioProject.housing;


Alter Table housing 
add ownerSplitAdress Nvarchar(255);

update housing
set ownerSplitAdress = PARSENAME(REPLACE(ownerAddress, ',', '.'), 3);

Alter Table housing 
add ownerSplitcity Nvarchar(255);

update housing
set ownerSplitCity = PARSENAME(REPLACE(ownerAddress, ',', '.'), 2);

Alter Table housing 
add ownerSplitstate Nvarchar(255);

update housing
set ownerSplitState = PARSENAME(REPLACE(ownerAddress, ',', '.'), 1)


select Distinct(soldAsVancant), count(soldAsVancant)
from portfolioProject.housing
group by SoldAsVacant
order by 2;

select soldAsVancant, case 
when soldAsVancant = 'Y' then 'Yes'
when soldAsVancant = 'N' then 'No'
else soldAsVancant
end
from portfolioProject.housing;

select housing
set soldAsVacant = case when soldAsVancant = 'Y' then 'Yes'
when soldAsVancant = 'N' then 'No'
else soldAsVancant
end

-- remove dupilicate 
with RowNumcte as (
select *,
row_number() over(
partition by ParcelID,
			 PropertyAddress,
             SaleDate,
             SalePrice,
             LegalReference
             order by
             UniqueID)
			row_num
from portfolioProject.housing
-- order by ParcelID
)
delete from RowNumcte
where row_num > 1;

select * from RowNumcte
where row_num > 1
order by propertyaddress

-- DELETE UNUSED COLUMNS

select * from portfolioProject.housing;

alter table portfolioProject.housing
drop column owneraddress, TaxDisrict, propertyaddress, salesdate;


