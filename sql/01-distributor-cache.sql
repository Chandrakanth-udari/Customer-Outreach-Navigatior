-- distributor_cache
-- Caching table that stores nearby distributors discovered via a maps/places API.
-- A Power Automate flow refreshes the cache on a schedule so the app loads new
-- nearby customers without calling the external API on every open.

CREATE TABLE dbo.distributor_cache (

    cache_id        INT IDENTITY(1,1) PRIMARY KEY,

    state           VARCHAR(50),

    city            VARCHAR(100),

    radius_miles    INT,

    keyword         VARCHAR(255),

    company_name    VARCHAR(500),

    full_address    VARCHAR(500),

    phone           VARCHAR(50),

    website         VARCHAR(500),

    latitude        DECIMAL(9,6),

    longitude       DECIMAL(9,6),

    source_type     VARCHAR(50),

    last_refreshed  DATETIME,

    visit_count     INT DEFAULT 0,

    created_at      DATETIME DEFAULT GETDATE()

);
