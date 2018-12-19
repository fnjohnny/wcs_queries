SELECT CAST(end_tran_date as date) as 'Date', DATEPART(hour,end_tran_time) as 'Hour', COUNT(description) as 'Number of Frozens' 
FROM t_tran_log WITH (NOLOCK) 
WHERE tran_type IN ('616','617') AND end_tran_date >= DATEADD(hh, -48, GETDATE()) 
GROUP BY CAST(end_tran_date as date), DATEPART(hour,end_tran_time) 
ORDER BY CAST(end_tran_date as date), DATEPART(hour,end_tran_time) ASC
