DECLARE @startDate datetime,
        @endDate datetime,
        @startTime datetime,
        @endTime datetime,
        @employeeId varchar(30)
SET     @startDate = '2018-11-27 00:00:00'
SET     @endDate = '2018-11-27 00:00:00'
SET     @startTime = 17
SET     @endTime = 23
SET     @employeeId = '%'
SELECT CAST(end_tran_date AS DATE) AS 'Date'
    , DATEPART(HOUR, end_tran_time) AS 'Hour'
    , COUNT(DISTINCT ttl.order_number) AS 'Orders Packed'
    , SUM(ttl.tran_qty) AS 'Units Packed'
    , ttl.employee_id AS 'Employee ID'
FROM t_tran_log ttl with(NOLOCK)
WHERE tran_type = '317'
AND CAST(end_tran_date AS DATE) BETWEEN @startDate AND @endDate
AND DATEPART(HOUR, end_tran_time) BETWEEN @startTime AND @endTime
AND employee_id LIKE @employeeId
GROUP BY CAST(end_tran_date AS DATE), DATEPART(HOUR,end_tran_time), ttl.employee_id
ORDER BY CAST(end_tran_date AS DATE), DATEPART(HOUR,end_tran_time)
