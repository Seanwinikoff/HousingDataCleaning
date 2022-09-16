/*
 * Cleaning Data in SQL Queries
 */

--Final code execution
---Explanation/reasoning of code

---------------------------------------------------------------------------------------------------------

---selects all data w/in nashvillehousing 
select *
from nashvillehousing n 

---------------------------------------------------------------------------------------------------------

--Standardize Date Format

---selects "SaleDate" formated as YYYY-MM-DD
select "SaleDate"
from nashvillehousing n 
---selects "SaleDate" and "SaleDate" cast as date to ensure standardized Date format (YYYY-MM-DD)
select "SaleDate","SaleDate"::date 
from nashvillehousing n 

---if not standardized (YYYY-MM-DD), update to ensure its standardized.
update nashvillehousing 
set "SaleDate" = "SaleDate"::date

---------------------------------------------------------------------------------------------------------

--Populate Property Address data

select *
from nashvillehousing n 
--where "PropertyAddress" is null 
order by "ParcelID" 

---need to join table to itself to ensure both "ParcelId" are the same where n."ProperAddress" is null 
select n."ParcelID", n."PropertyAddress" , n2."ParcelID" , n2."PropertyAddress", isnull(n."PropertyAddress",n2."PropertyAddress")
from nashvillehousing n 
join nashvillehousing n2
	on n."ParcelID" = n2."ParcelID"
	and n."UniqueID " <> n2."UniqueID "
where n."PropertyAddress"  is null

---updates n with new values 
Update nashvillehousing n
SET PropertyAddress = ISNULL(n.PropertyAddress,n2.PropertyAddress)
From NashvilleHousing n
join NashvilleHousing n2
	on n."ParcelID" = n2."ParcelID"
	AND n."UniqueID" <> n2."UniqueID"
Where n.PropertyAddress is null

---------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City , State)

select "PropertyAddress" 
from nashvillehousing n 
--where "PropertyAddress" is null 
--order by "ParcelID" 

---Using substrings and position functions 
select 
substring("PropertyAddress", 1, position(',' in "PropertyAddress") -1) as Address
, substring("PropertyAddress", position(',' in "PropertyAddress") + 1, length("PropertyAddress")) as City
from nashvillehousing n

select 
split_part("PropertyAddress", ',', 1) as address
, substring("PropertyAddress", position(',' in "PropertyAddress") + 1, length("PropertyAddress")) as City
from nashvillehousing n

---creates 2 new columns with their new set substrings
alter table nashvillehousing 
add PropertySplitAddress varchar(255);

update nashvillehousing 
set propertysplitaddress = split_part("PropertyAddress", ',', 1)

alter table nashvillehousing 
add PropertySplitCity varchar(255);

update nashvillehousing 
set propertysplitcity = substring("PropertyAddress", position(',' in "PropertyAddress") + 1, length("PropertyAddress"))

Select *
From NashvilleHousing

---using parsename instead of substring
select 
split_part("OwnerAddress", ',', 1)
,split_part("OwnerAddress", ',', 2) 
,split_part("OwnerAddress", ',', 3) 
from nashvillehousing n 

---creates 3 new columns with their new set split_part addresses 
alter table nashvillehousing 
add OwnerSplitAddress varchar(255)

update nashvillehousing 
set OwnerSplitAddress = split_part("OwnerAddress", ',', 1)

alter table nashvillehousing 
add OwnerSplitCity varchar(255)

update nashvillehousing 
set OwnerSplitCity = split_part("OwnerAddress", ',', 2)

alter table nashvillehousing 
add OwnerSplitState varchar(255)

update nashvillehousing 
set OwnerSplitState = split_part("OwnerAddress", ',', 3)

---------------------------------------------------------------------------------------------------------

--Remove Duplicates 

---using CTE to find where the duplicates are 
---row_num shows how many duplicates we have 
with RowNumCTE as(
select *,
	    row_number() over (
	    partition by "ParcelID" ,
				"PropertyAddress" ,
				"SalePrice" ,
				"SaleDate" ,
				"LegalReference" 
				order by "UniqueID " 
				) as row_num
from nashvillehousing n 
--order by "ParcelID"
)
--- change select to delete to delete the duplicates 
select * 
from RowNumCTE 
where row_num > 1 
order by "PropertyAddress" 

select *
from nashvillehousing n 


---------------------------------------------------------------------------------------------------------

--Delete Unused Columns

---best practice is to not delete raw data-- better to do this for views 
select *
from nashvillehousing n 

alter table nashvillehousing 
drop column "OwnerAddress" ,"TaxDistrict" ,"PropertyAddress" ,"SaleDate" 




