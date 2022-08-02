/*******************************************************************
データファイルのインサートクエリ

CSV などのファイルをテーブルへ挿入できる。

▼参考サイト
- https://docs.microsoft.com/ja-jp/sql/t-sql/statements/bulk-insert-transact-sql?view=sql-server-ver15
- https://qiita.com/fuk101/items/d98716a48d69d5c7f1a7

*******************************************************************/

-- SQL Server 2017 以降は FORMAT で指定するだけでだいたい取り込めるらしい
BULK INSERT members
FROM '/mount_dir/csv/members.csv'
WITH
    (
        FORMAT = 'CSV', -- CSV 形式で取り込み
        FIRSTROW = 2    -- 読み込み開始行を指定
    )
;

-- 細かく指定する場合は下記のような感じで
BULK INSERT members
FROM '/mount_dir/csv/members.csv'
WITH
    (
        DATAFILETYPE = 'char', -- 文字形式で取り込み
        FIELDTERMINATOR = ',', -- 区切り文字を指定
        ROWTERMINATOR = '\n',  -- 行末を示す文字を指定
        FIRSTROW = 2           -- 読み込み開始行を指定
    )
;
