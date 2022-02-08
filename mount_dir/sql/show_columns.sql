-- https://style.potepan.com/articles/24713.html より

SELECT
	t.name                  AS テーブル名,
	c.name                  AS 項目名,
	type_name(user_type_id) AS 属性,
	max_length              AS 長さ,
	CASE
		WHEN
			is_nullable = 1
		THEN
			'YES'
		ELSE
			'NO'
	END AS NULL許可
FROM
	sys.objects t
    INNER JOIN sys.columns c ON
		t.object_id = c.object_id
WHERE
	t.type = 'U'
AND
	t.name IN ('members') -- 他に見たいテーブルがあれば IN の指定に追加
ORDER BY
	c.column_id
;