SELECT
        COUNT(DISTINCT orm.order_number) AS order_count
       ,SUM(ord.qty) AS total_units
FROM t_order orm WITH (NOLOCK)
INNER JOIN t_order_detail ord WITH (NOLOCK)
       ON orm.wh_id = ord.wh_id
       AND orm.order_number = ord.order_number
WHERE orm.status NOT IN ('SHIPPED','CANCELLED','PACKED','LOADED','S')
       AND orm.order_type NOT IN ('RT','RTV')
       AND ord.qty > (ISNULL(ord.cancel_qty,0) + ISNULL(ord.bo_qty,0))
