SELECT CAST(orm.order_date AS DATE) AS order_date
, orm.order_number, orm.status As order_status
, orm.carrier, orm.carrier_scac
, tpd.container_id 
, txl.error_text
FROM t_order orm WITH (NOLOCK)
