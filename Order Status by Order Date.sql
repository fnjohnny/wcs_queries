SELECT COUNT(DISTINCT orm.order_number) As Orders,
SUM(ord.qty) As Units,
orm.status As Status
FROM t_order orm  with(NOLOCK)
JOIN t_order_detail ord with(NOLOCK)
ON orm.order_number = ord.order_number
WHERE orm.order_date BETWEEN '2018-11-26 00:00:00' AND '2018-11-26 23:59:59:59'
GROUP BY orm.status

