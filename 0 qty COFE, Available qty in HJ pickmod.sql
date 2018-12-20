SELECT location_id, hu_id, item_number, actual_qty, status FROM t_stored_item with(NOLOCK)
WHERE location_id LIKE 'A%'
AND status = 'A'
AND actual_qty > '0'
AND item_number IN (--insert cofe sku shortage--)
GROUP BY location_id, hu_id, item_number, actual_qty, status
