SELECT
    p.parcel_id
    , spp.model_name
    , p.parcel_tracking
    , p.transporter
    , p.priority
    , p.date_purchase
    , p.date_shipping
    , p.date_delivery
    , p.date_cancelled
    , p.month_purchase
    , p.status
    , p.expedition_time
    , p.transport_time
    , p.delivery_time
    , p.delay
    , spp.quantity as qty
FROM {{ ref("cc_parcel")}} as p
JOIN {{ ref("stg_raw__parcel_product")}} as spp
    Using(parcel_id)
ORDER BY parcel_id