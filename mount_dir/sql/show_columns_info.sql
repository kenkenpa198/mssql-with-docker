/*******************************************************************
カラム情報取得クエリ

指定したテーブルの下記のカラム情報を一覧で取得する SQL Server 用の SQL クエリ。
- 主キーの有無
- データ型
- 長さ
- NULL 許可
- デフォルト値

★ のコメントを記述している箇所へ、情報を取得したいテーブル名を指定して実行する。

▼参考サイト
- https://style.potepan.com/articles/24713.html
- https://ichiroku11.hatenablog.jp/entry/2015/12/20/213107
- https://johobase.com/sqlserver-catalogview-table-column/
- https://docs.microsoft.com/ja-jp/sql/relational-databases/system-catalog-views/object-catalog-views-transact-sql?view=sql-server-ver15

*******************************************************************/

SELECT
    o.name                    AS 'テーブル名',
    c.name                    AS 'カラム名',
    CASE
        WHEN pk.is_primary_key = 1
        THEN 'YES'
        ELSE 'NO'
    END                       AS 'PK',
    type_name(c.user_type_id) AS 'データ型',
    c.max_length              AS '長さ',
    CASE
        WHEN c.is_nullable = 1
        THEN 'YES'
        ELSE 'NO'
    END                       AS 'NULL 許可',
    CASE
        -- デフォルト値に含まれている '((' と '))' を除去する
        WHEN LEFT(d.definition, 2) = '((' AND RIGHT(d.definition, 2) = '))'
        THEN SUBSTRING(d.definition, 3, LEN(d.definition) - 4)
        -- デフォルト値に含まれている '(' と ')' を除去する
        WHEN LEFT(d.definition, 1) = '(' AND RIGHT(d.definition, 1) = ')'
        THEN SUBSTRING(d.definition, 2, LEN(d.definition) - 2)
        ELSE NULL
    END                       AS 'デフォルト値'

-- ベースとなる sys.objects カタログビューテーブル。このビューへ各情報を結合する
FROM
    sys.objects AS o

    -- カラムのカタログビュー（カラム名やデータ型などの情報を保有）と内部結合
    INNER JOIN sys.columns AS c
    ON o.object_id = c.object_id

    --インデックス関連のカタログビュー（PK の情報を保有）と外部結合
    LEFT OUTER JOIN (
        SELECT
            ic.object_id,
            ic.column_id,
            i.is_primary_key
        FROM
            sys.indexes AS i
            INNER JOIN sys.index_columns AS ic
            ON
                i.object_id = ic.object_id
                AND i.index_id = ic.index_id
    ) pk
    ON
        o.object_id = pk.object_id
        AND c.column_id = pk.column_id

    -- デフォルト制約のカタログビュー（デフォルト値の情報を保有）と外部結合
    LEFT OUTER JOIN sys.default_constraints AS d
    ON
        o.object_id = d.parent_object_id
        AND c.column_id = d.parent_column_id

WHERE
    o.type = 'U' -- オブジェクトの種類を「テーブル (ユーザー定義)」のみに制限
    AND o.name IN ('members') -- ★ ここに確認したいテーブル名を指定する。他に見たいテーブルがあれば IN の指定にカンマ区切りで追加可能

-- テーブル名 > カラム ID の順に昇順で出力
ORDER BY
    o.name,
    c.column_id
;
