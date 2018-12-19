SELECT CAST(order_date AS DATE) As order_date, order_number, status, carrier, carrier_scac
FROM t_order with(NOLOCK)
WHERE order_number LIKE 'SO%'
AND status IN ('IMPORTED','RATEFAIL')
