-- =============================================================================
-- vw_CustomerSalesSummary
-- Aggregates total sales and order count per partner (customer), with a
-- normalized, view-only city value and a concatenated full address.
-- =============================================================================
ALTER VIEW vw_CustomerSalesSummary AS
SELECT
    dp.partner_key,
    dp.partner_id,
    dp.company_name,
    dp.address_street_num,
    dp.address_street_name,

    -- Normalized city (view-only)
    CASE
        WHEN dp.address_city IS NULL THEN NULL
        ELSE
            UPPER(LEFT(
                LTRIM(RTRIM(REPLACE(dp.address_city, ',', ''))), 1
            ))
            + LOWER(SUBSTRING(
                LTRIM(RTRIM(REPLACE(dp.address_city, ',', ''))), 2, 200
            ))
    END AS address_city,

    dp.address_state,
    dp.address_zip,

    CONCAT(
        dp.address_street_num, ' ',
        dp.address_street_name, ', ',
        CASE
            WHEN dp.address_city IS NULL THEN ''
            ELSE
                UPPER(LEFT(
                    LTRIM(RTRIM(REPLACE(dp.address_city, ',', ''))), 1
                ))
                + LOWER(SUBSTRING(
                    LTRIM(RTRIM(REPLACE(dp.address_city, ',', ''))), 2, 200
                ))
        END, ', ',
        dp.address_state, ' ',
        dp.address_zip
    ) AS full_address,

    SUM(fop.total_price) AS total_sales,
    COUNT(DISTINCT fo.order_key) AS order_count
FROM dim_partner dp
LEFT JOIN fact_order fo
    ON dp.partner_key = fo.partner_key
LEFT JOIN fact_order_position fop
    ON fo.order_key = fop.order_key
GROUP BY
    dp.partner_key,
    dp.partner_id,
    dp.company_name,
    dp.address_street_num,
    dp.address_street_name,
    dp.address_city,
    dp.address_state,
    dp.address_zip;
GO

-- =============================================================================
-- vw_LowSalesCustomers
-- Buckets customers with sales into 5 tiers (NTILE) and returns the lowest
-- tier -- the under-served accounts the outreach app should prioritize.
-- =============================================================================
ALTER VIEW vw_LowSalesCustomers AS
WITH Ranked AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY total_sales ASC) AS SalesTier
    FROM vw_CustomerSalesSummary
    WHERE total_sales > 0
      AND order_count > 0
)
SELECT *
FROM Ranked
WHERE SalesTier = 1;
GO
