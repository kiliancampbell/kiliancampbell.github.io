## GOAL: Use whale tracking data to predict the migrational patterns of blue whales. To better protect endangered species, a local government agency wants to predict where a whale species may be to notify and warn locals.

## CLEAN: Counting readings not associated with 'Balaenoptera musculus' to check for mispellings and 'null' values

SELECT 
  COUNT(*) AS readings,
  individual_taxon_canonical_name AS Genus_species
FROM `migrationdata-361519.azores_great_whales.whales` 
GROUP BY 
  Genus_species

## Exploring null values

SELECT
  *
FROM `migrationdata-361519.azores_great_whales.whales` 
WHERE
  individual_taxon_canonical_name IS NULL

## distinct tag_local_id to see if nulls belong to other whales

SELECT
  DISTINCT(individual_taxon_canonical_name)
FROM
  `migrationdata-361519.azores_great_whales.whales`
WHERE 
  tag_local_identifier = 60786
GROUP BY
  individual_taxon_canonical_name,
  tag_local_identifier
## to see if null values are duplicates
SELECT
  *
FROM
  `migrationdata-361519.azores_great_whales.whales`
WHERE 
  tag_local_identifier = 80692

## Update null values with individual_taxon_canonical_name that corresponds to the null's tag_local_identifier

UPDATE
   `migrationdata-361519.azores_great_whales.whales` AS b

SET 
  b.individual_taxon_canonical_name = whales.individual_taxon_canonical_name

FROM (
  SELECT
    DISTINCT(whales.tag_local_identifier), 
    whales.individual_taxon_canonical_name 
  FROM
    `migrationdata-361519.azores_great_whales.whales` AS whales
  WHERE 
    whales.individual_taxon_canonical_name IS NOT NULL
  ) AS whales
WHERE 
  whales.tag_local_identifier = b.tag_local_identifier
AND
  b.individual_taxon_canonical_name IS NULL

## null values have been cleaned except for speciment 60786 which has no individual_taxon_canonical_name assigned and will be omitted in the analysis.

## Exporting clean data set into 'blue_whale' data set consisting of only blue whale species for visualization and analysis in R

SELECT 
  *
FROM `migrationdata-361519.azores_great_whales.whales` AS blue_whale
WHERE individual_taxon_canonical_name = 'Balaenoptera musculus'
AND location_long IS NOT NULL
AND location_lat IS NOT NULL
ORDER BY
  event_id
