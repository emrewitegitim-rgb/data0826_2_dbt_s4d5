WITH agg_parcel_product as (
    SELECT
        parcel_id
        , count(model_name) as nb_model
        , sum(quantity) as qty
    FROM {{ ref("stg_raw__parcel_product") }}
    GROUP BY parcel_id
)

SELECT
    p.*
    , EXTRACT(MONTH FROM date_purchase) as month_purchase
    , CASE
        WHEN date_cancelled is not null THEN '4 - Cancelled'
        WHEN date_delivery is not null THEN '3 - Delivered'
        WHEN date_shipping is not null THEN '2 - Shipped'
        WHEN date_purchase is not null THEN '1 - In Progress'
        ELSE null
    END as status
    , DATE_DIFF(date_shipping, date_purchase, DAY) as expedition_time
    , DATE_DIFF(date_delivery, date_shipping, DAY) as transport_time
    , DATE_DIFF(date_delivery, date_purchase, DAY) as delivery_time
    , IF(DATE_DIFF(date_delivery, date_purchase, DAY) > 5, (DATE_DIFF(date_delivery, date_purchase, DAY) - 5), null) as delay
    , pp.qty
    , pp.nb_model
FROM {{ ref("stg_raw__parcel")}} as p
JOIN agg_parcel_product as pp
    using(parcel_id)