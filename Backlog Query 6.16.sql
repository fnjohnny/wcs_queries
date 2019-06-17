--*****adding total orders BACKLOG with Social Media PLUS problem imports
SELECT CAST(orm.order_date AS DATE) AS order_date
	  ,ISNULL(back.BacklogOrders,0) AS 'Backlog Orders'--need new sub
      ,ISNULL(back.BackUnits,0) AS 'Backlog Units' --need new sub
	  ,COUNT(DISTINCT orm.order_number) AS order_count
	  ,isnull(bklg.backlog,0) AS 'Social Media Orders'
	  ,isnull(prob.ProblemOrders,'0') AS 'Potential Problem Orders'
FROM t_order orm WITH (NOLOCK)
LEFT OUTER JOIN (select cast(convert(char(11), order_date, 113) as datetime) as BackOrderdate
	  ,COUNT(DISTINCT ormn.order_number) AS BacklogOrders
	  ,SUM(ord.qty) AS BackUnits
      FROM t_order ormn (nolock)
	  LEFT OUTER JOIN t_order_detail ord WITH (NOLOCK)
      ON ormn.order_number = ord.order_number
	  WHERE ormn.status NOT IN ('SHIPPED','CANCELLED','PACKED','LOADED','S')
      AND ormn.order_type NOT IN ('RT','RTV','SM')
      AND ord.qty > (ISNULL(ord.cancel_qty,0) + ISNULL(ord.bo_qty,0))
	  group by cast(convert(char(11), order_date, 113) as datetime)
	  )back
		ON cast(convert(char(11), orm.order_date, 113) as datetime) = back.BackOrderdate 


LEFT outer join (select cast(convert(char(11), order_date, 113) as datetime) as orderdate
	   ,count(distinct order_number) as backlog
			from t_order (nolock)
			where status NOT IN ('SHIPPED','CANCELLED','PACKED','LOADED','S')
			and order_type IN ('SM')
			group by cast(convert(char(11), order_date, 113) as datetime)
			)bklg
		ON cast(convert(char(11), orm.order_date, 113) as datetime) = bklg.orderdate 

left outer join (select cast(convert(char(11), imp2.order_date, 113) as datetime) as Prob_orderdate --add orders with potential import problems
	   ,count(distinct imp2.order_number) as ProblemOrders
	   --select imp2.order_number, orm2.order_number, * -- get details for problem orders (run without grouping)
			from t_import_order imp2(nolock)
			left outer join t_order orm2(nolock)
			on imp2.order_number = orm2.order_number
			where imp2.order_type IN ('Ecommerce Order')
			AND imp2.dateTimeInserted > getdate() - 7
			AND imp2.dateTimeInserted < getdate() - 0.0205
			AND orm2.order_number is null
			group by cast(convert(char(11), imp2.order_date, 113) as datetime)
			)prob
		ON cast(convert(char(11), orm.order_date, 113) as datetime) = prob.Prob_orderdate 

WHERE --orm.status NOT IN ('SHIPPED','CANCELLED','PACKED','LOADED','S')
      orm.order_type NOT IN ('RT','RTV')
      --AND ord.qty > (ISNULL(ord.cancel_qty,0) + ISNULL(ord.bo_qty,0))
GROUP BY CAST(orm.order_date AS DATE), bklg.backlog, prob.ProblemOrders ,back.BacklogOrders,back.BackUnits
HAVING back.BacklogOrders > 0 OR bklg.backlog > 0
ORDER BY CAST(orm.order_date AS DATE)
