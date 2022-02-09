/*
SQL Server で指定したテーブルの下記の情報を一覧で取得するクエリです。
- 主キーの有無
- 属性
- 長さ
- NULL 許可

★のコメントを記述している箇所へ、情報を取得したいテーブル名を指定して実行してください。

▼参考サイト
https://style.potepan.com/articles/24713.html
https://ichiroku11.hatenablog.jp/entry/2015/12/20/213107
*/


SELECT
    t.name                  AS 'テーブル名',
    c.name                  AS 'カラム名',
    CASE
        WHEN is_primary_key = 1
        THEN 'YES'
        ELSE 'NO'
    END                     AS 'PK',
    type_name(user_type_id) AS '属性',
    max_length              AS '長さ',
    CASE
        WHEN is_nullable = 1
        THEN 'YES'
        ELSE 'NO'
    END                     AS 'NULL 許可'

FROM sys.objects t
    INNER JOIN sys.columns c
    ON t.object_id = c.object_id
    LEFT OUTER JOIN (
        -- PK を取得
        SELECT
            ic.object_id,
            ic.column_id,
            i.is_primary_key
        FROM sys.indexes AS i
            INNER JOIN sys.index_columns AS ic
            ON
                i.object_id = ic.object_id
                AND i.index_id = ic.index_id
    ) pk
    ON
        t.object_id = pk.object_id
        AND c.column_id = pk.column_id

WHERE
    t.type = 'U'
    AND t.name IN ('members') -- ★ここに確認したいテーブル名を指定。他に見たいテーブルがあれば IN の指定にカンマ区切りで追加可能。

-- テーブル名 > カラム ID の順に昇順で出力
ORDER BY
    t.name,
    c.column_id
;
