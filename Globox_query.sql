--Write a SQL query that returns: 
SELECT 
	DISTINCT u.id, --the user ID
  g.join_dt, --the date
  COALESCE(u.country, 'Others') AS country, --the user’s country
  COALESCE(u.gender, 'O') AS gender, --the user’s gender
  COALESCE(g.device, 'Other') AS device, --the user’s device type
  g.group AS user_group, --the user’s test group
  CASE 																--whether or not they converted (spent > $0)
  	WHEN a.spent IS NULL THEN 0
  	WHEN a.spent IS NOT NULL THEN 1
  	ELSE a.spent
	END AS conv_indicator,
	ROUND(CAST(SUM(COALESCE(a.spent, 0)) AS numeric), 2) AS spend_per_user,
	COUNT(a.spent) AS num_spent  --and how much they spent in total ($0+)
FROM users AS u   --join tables using users as the left table and the relevant join keys
LEFT JOIN activity AS a
	ON u.id = a.uid
LEFT JOIN groups AS g
  ON u.id = g.uid
GROUP BY 1, 2, 3, 4, 5, 6, 7 ---group by non-aggregated fields
