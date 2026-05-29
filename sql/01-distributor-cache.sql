-- distributor_cache
-- Caching table that stores nearby distributors discovered via a maps/places API.
-- A Power Automate flow refreshes the cache on a schedule so the app loads
-- new nearby customers without calling the external API on every open.

SELECT TOP (1000)
       [cache_id]
      ,[state]
      ,[city]
      ,[radius_miles]
      ,[keyword]
      ,[company_name]
      ,[full_address]
      ,[phone]
      ,[website]
      ,[latitude]
      ,[longitude]
      ,[source_type]
      ,[last_refreshed]
      ,[visit_count]
      ,[created_at]
  FROM [ClientDW].[dbo].[distributor_cache];
