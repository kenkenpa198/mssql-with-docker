SELECT TOP 99999999
    t.column_A,
    t.column_B,
    CASE WHEN t.column_C IS NULL THEN 'NULL' ELSE 'NOT NULL' END AS column_C,
    COUNT(*) AS cnt

FROM
    [tb] t -- ★テーブル名を指定

GROUP BY
    t.column_A,
    t.column_B,
    CASE WHEN t.column_C IS NULL THEN 'NULL' ELSE 'NOT NULL' END

ORDER BY
    column_A,
    column_B,
    column_C
