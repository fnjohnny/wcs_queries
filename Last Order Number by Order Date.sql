SELECT MAX(order_number)
FROM t_order with(NOLOCK)
WHERE CAST(order_date As DATE) = '2018-11-26'
AND order_number NOT LIKE 'TO%'
AND order_number NOT LIKE 'RTV%'
AND order_number NOT LIKE 'SO%'
