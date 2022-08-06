<!-- omit in toc -->
# SQL メモ

標準 SQL を中心にまとめた自分用メモ。  
実際に使えるコードは [mount_dir 上](../mount_dir/sql/) へ格納。

<!-- omit in toc -->
## 目次

- [1. 環境関連](#1-環境関連)
    - [1.1. SQL Server 環境のバージョン・エディションを確認する](#11-sql-server-環境のバージョンエディションを確認する)
    - [1.2. 環境で使用されている文字コードを調べる](#12-環境で使用されている文字コードを調べる)
- [2. データベース操作](#2-データベース操作)
    - [2.1. データベース一覧を取得する](#21-データベース一覧を取得する)
    - [2.2. データベースを作成する](#22-データベースを作成する)
    - [2.3. 使用するデータベースを設定する](#23-使用するデータベースを設定する)
    - [2.4. 使用しているデータベースを確認する](#24-使用しているデータベースを確認する)
- [3. テーブル操作](#3-テーブル操作)
    - [3.1. テーブル一覧を表示する](#31-テーブル一覧を表示する)
    - [3.2. テーブルの定義を表示する](#32-テーブルの定義を表示する)
    - [3.3. テーブルを作成する](#33-テーブルを作成する)
    - [3.4. テーブルを削除する](#34-テーブルを削除する)
    - [3.5. テーブルの定義を変更する](#35-テーブルの定義を変更する)
        - [3.5.1. 列を追加する場合](#351-列を追加する場合)
        - [3.5.2. 列を削除する場合](#352-列を削除する場合)
        - [3.5.3. 列の設定を変更する場合](#353-列の設定を変更する場合)
        - [3.5.4. 列へ主キーを付与する場合](#354-列へ主キーを付与する場合)
- [4. ビュー](#4-ビュー)
    - [4.1. ビューを作成する](#41-ビューを作成する)
    - [4.2. ビューを削除する](#42-ビューを削除する)
- [5. トランザクション](#5-トランザクション)
    - [5.1. トランザクションの作成](#51-トランザクションの作成)
- [6. レコード操作](#6-レコード操作)
    - [6.1. レコードを追加する](#61-レコードを追加する)
        - [6.1.1. 基本](#611-基本)
        - [6.1.2. 列リストの省略](#612-列リストの省略)
        - [6.1.3. SELECT 句での抽出結果から INSERT する](#613-select-句での抽出結果から-insert-する)
    - [6.2. レコードを削除する](#62-レコードを削除する)
    - [6.3. レコードを更新する](#63-レコードを更新する)
- [7. 検索](#7-検索)
    - [7.1. 基本](#71-基本)
    - [7.2. カッコを使った条件式](#72-カッコを使った条件式)
    - [7.3. NULL を除外して行数を数える](#73-null-を除外して行数を数える)
    - [7.4. 相関サブクエリ](#74-相関サブクエリ)
    - [7.5. EXISTS](#75-exists)
    - [7.6. ウィンドウ関数](#76-ウィンドウ関数)
    - [7.7. GROUPING](#77-grouping)
- [8. 自作クエリ](#8-自作クエリ)
    - [8.1. 要素の組み合わせ毎の件数を取得する](#81-要素の組み合わせ毎の件数を取得する)
    - [8.2. カラムの情報を見やすい形式で表示する](#82-カラムの情報を見やすい形式で表示する)
    - [8.3. CSV などのデータファイルからインポート](#83-csv-などのデータファイルからインポート)
- [9. メモ](#9-メモ)
    - [9.1. SQL の文とその種類](#91-sql-の文とその種類)
        - [9.1.1. DDL (Data Definition Language / データ定義言語)](#911-ddl-data-definition-language--データ定義言語)
        - [9.1.2. DML (Data Manipulation Language / データ操作言語)](#912-dml-data-manipulation-language--データ操作言語)
        - [9.1.3. DCL (Data Control Language / データ制御言語)](#913-dcl-data-control-language--データ制御言語)
    - [9.2. [SQL Server]文字列型 4種の違い](#92-sql-server文字列型-4種の違い)
    - [9.3. 「SQL」と「クエリ」](#93-sqlとクエリ)
        - [9.3.1. SQL (Structured Query Language)](#931-sql-structured-query-language)
        - [9.3.2. クエリ（Query）](#932-クエリquery)
        - [9.3.3. つまり「SQL クエリ」って？](#933-つまりsql-クエリって)
    - [9.4. 混同しやすい用語たち](#94-混同しやすい用語たち)
        - [9.4.1. 文](#941-文)
        - [9.4.2. 句](#942-句)
        - [9.4.3. 予約語（キーワード）](#943-予約語キーワード)
        - [9.4.4. 式](#944-式)
        - [9.4.5. 関数](#945-関数)
        - [9.4.6. 述語](#946-述語)
        - [9.4.7. …つまり？](#947-つまり)
    - [9.5. DISTINCT と GROUP BY の使い分け](#95-distinct-と-group-by-の使い分け)
- [10. 参考文献](#10-参考文献)

## 1. 環境関連

### 1.1. SQL Server 環境のバージョン・エディションを確認する

参考: [SQL Server - sqlcmd でバージョンとエディションを確認する方法](https://www.curict.com/item/5a/5a4356b.html)

```sql
SELECT @@VERSION;

/***************************
Microsoft SQL Server 2019 (RTM-CU15) (KB5008996) - 15.0.4198.2 (X64)
    Jan 12 2022 22:30:08
    Copyright (C) 2019 Microsoft Corporation
    Express Edition (64-bit) on Linux (Ubuntu 20.04.3 LTS) <X64>
***************************/

```

### 1.2. 環境で使用されている文字コードを調べる  

参考: [SQLServer日本語コードの確認方法 - Qiita](https://qiita.com/makoto8048/items/41c7de2ce835027508aa)

```sql
-- 先に確認したい列の照合順序を確認しておく（参考ページを参照）

SELECT COLLATIONPROPERTY('Japanese_CI_AS', 'CodePage');

-- 932   : Shift-JIS
-- 1200  : UTF-16
-- 65001 : UTF-8
-- 20932 : EUC-JP

-- 確認できるのは非 UNICODE 型の文字列型（char, varchar, text）に使用される文字コードのみ。
-- UNICODE 型の文字列型（nchar, nvarchar, ntext）はそもそも UTF-16 固定となる。

```

## 2. データベース操作

### 2.1. データベース一覧を取得する

```sql
SELECT name FROM sys.databases;
```

### 2.2. データベースを作成する

```sql
CREATE DATABASE <database-name>;
```

### 2.3. 使用するデータベースを設定する

```sql
USE <database-name>;
```

### 2.4. 使用しているデータベースを確認する

```sql
SELECT DB_NAME();
```

## 3. テーブル操作

### 3.1. テーブル一覧を表示する

```sql
SELECT name FROM sysobjects WHERE xtype = 'U';
```

### 3.2. テーブルの定義を表示する

すべての情報を出力する。  
[5.2. カラムの情報を見やすい形式で表示する](#52-カラムの情報を見やすい形式で表示する) も参考に。

```sql
SELECT * FROM sys.columns WHERE object_id = object_id('Members');
```

### 3.3. テーブルを作成する

```sql
CREATE TABLE Members (
--  列名          データ型     この列の制約
    member_id     CHAR(4)      NOT NULL,
    member_name   VARCHAR(100) NOT NULL,
    sex           VARCHAR(32)  NOT NULL,
    age           INTEGER      ,
    foo_num       INTEGER      ,
    date_of_birth DATE         ,

--  このテーブルの制約
    PRIMARY KEY (member_id) -- 列の制約に「PRIMARY KEY」と付けてもよい
);
```

### 3.4. テーブルを削除する

```sql
DROP TABLE Members;
```

### 3.5. テーブルの定義を変更する

#### 3.5.1. 列を追加する場合

```sql
ALTER TABLE <テーブル名> ADD COLUMN <列の定義>;

-- [DB2][PostgreSQL][MySQL]
ALTER TABLE Members ADD COLUMN hobby VARCHAR(128);

-- [SQL Server][Oracle] COLUMN をつけない
ALTER TABLE Members ADD hobby VARCHAR(128);

-- [Oracle] () をつけて複数の定義を一度に追加できる
ALTER TABLE Members ADD (hobby VARCHAR(128), pet VARCHAR(128));
```

#### 3.5.2. 列を削除する場合

```sql
ALTER TABLE <テーブル名> DROP <列名>

-- [SQL Server][DB2][PostgreSQL][MySQL]
ALTER TABLE Members DROP COLUMN hobby;

-- [Oracle] COLUMN を省略できる。() をつけて複数の列を一度に削除できる
ALTER TABLE Members DROP (hobby, pet);

```

#### 3.5.3. 列の設定を変更する場合

```sql
ALTER TABLE <テーブル名> ALTER COLUMN <列の定義>;

-- 列の定義を変更
ALTER TABLE Members ALTER COLUMN member_id INTEGER NOT NULL;
ALTER TABLE Members ALTER COLUMN first_name NVARCHAR(10);
```

#### 3.5.4. 列へ主キーを付与する場合

```sql
ALTER TABLE Members ADD PRIMARY KEY (member_id, first_name);
```

## 4. ビュー

### 4.1. ビューを作成する

```sql
CREATE VIEW
    MembersSexCnt (
        -- ビューの列名（並び順が SELECT 文の結果と対応）
        sex,
        sex_count
    )
AS
    -- ビュー定義の本体（SELECT 文）
    SELECT
        sex,
        COUNT(*)
    FROM
        Members
    GROUP BY
        sex
;
```

### 4.2. ビューを削除する

```sql
DROP VIEW MembersSexCnt;
```

## 5. トランザクション

### 5.1. トランザクションの作成

```sql
-- [SQL Server][PostgreSQL]
BEGIN TRANSACTION
    ... DML 文（INSERT / UPDATE / DELETE 文） ...
COMMIT -- または ROLLBACK

-- [MySQL]
START TRANSACTION
    ... DML 文 ...
COMMIT -- または ROLLBACK

-- [Oracle][DB2]
ない
```

```sql
-- 例（SQL Server）
BEGIN TRANSACTION

    -- カッターシャツの販売単価を 1000 円値引き
    UPDATE Shohin
       SET hanbai_tanka = hanbai_tanka - 1000
     WHERE shohin_mei = 'カッターシャツ';

    -- カッターシャツの販売単価を 1000 円値引き
    UPDATE Shohin
       SET hanbai_tanka = hanbai_tanka + 1000
     WHERE shohin_mei = 'Tシャツ';

COMMIT
```

## 6. レコード操作

### 6.1. レコードを追加する

#### 6.1.1. 基本

```sql
-- [SQL Server][PostgreSQL]
BEGIN TRANSACTION; -- 行の追加を開始する
    INSERT INTO <テーブル名> (列1, 列2, 列3, ...) VALUES (値1, 値2, 値3, ...);
COMMIT;            -- 行の追加を確定する
```

※ MySQL の場合、`BEGIN TRANSACTION;` を下記に変更する。

```sql
START TRANSACTION;
```

※ Oracle, DB2 の場合は `BEGIN TRANSACTION;` が必要ないので削除する。

#### 6.1.2. 列リストの省略

テーブルの前列に対して INSERT を行う場合は列リストを省略できる。

```sql
BEGIN TRANSACTION;

--                          member_id  member_name  sex       age  foo_num  date_of_birth
INSERT INTO Members VALUES ('0001',    'Modane',    'female', 18,  111,     '2019-09-08');
INSERT INTO Members VALUES ('0002',    'Ryunosuke', 'male',   21,  NULL,    '2017-09-29');
INSERT INTO Members VALUES ('0003',    'Tsukune'  , 'female', 19,  222,     NULL);

COMMIT;
```

#### 6.1.3. SELECT 句での抽出結果から INSERT する

```sql
INSERT INTO Members (
    member_id,
    member_name,
    date_of_birth
)
SELECT
    member_id,
    member_name,
    date_of_birth
FROM
    Foo_Table
;

-- すべての列へ値を入れる際は Members のカラム指定 (a, b, c, ...) を省略できる
INSERT INTO Members
SELECT
    member_id,
    member_name,
    date_of_birth
FROM
    Foo_Table
;

-- WHERE 句、GROUP BY 句などを追加することで集計結果を挿入することもできる。
```

### 6.2. レコードを削除する

```sql
-- レコードを全行削除
DELETE FROM Members;

-- WHERE 句で削除対象の行を指定できる（探索型 DELETE）
DELETE
FROM
    Members
WHERE
    age <= 20
;
```

### 6.3. レコードを更新する

```sql
-- 指定したカラムを全行更新
UPDATE
    Members
SET
    foo_num = 15
;

-- WHERE 句で更新対象の行を指定できる（探索型 UPDATE）
UPDATE
    Members
SET
    foo_num = 15
WHERE
    member_name = 'Modane'
;

-- 計算した結果で更新することも可能（例 : 指定列の値を10倍する）
UPDATE
    Members
SET
    foo_num = foo_num * 10
;

-- NULL で更新する（NULL クリア）
UPDATE
    Members
SET
    foo_num = NULL
;

-- 複数の列を更新する場合
UPDATE
    Members
SET
    age = age / 2,
    foo_num = foo_num * 10
WHERE
    sex = 'female'
;
```

## 7. 検索

### 7.1. 基本

```sql
SELECT
    member_id,
    member_name
FROM
    Members
WHERE
    age <= 20
;
```

### 7.2. カッコを使った条件式

```sql
-- 「商品分類が事務用品」かつ「登録日が2009年9月11日または2009年9月20日」
WHERE
    shohin_bunrui = '事務用品'
    AND (
        torokubi = '2009-09-11'
        OR torokubi = '2029-09-20'
    )
;
```

### 7.3. NULL を除外して行数を数える

COUNT 関数は `*` を引数に取ることができる。  
また、引数へ `*` を渡した場合とカラム名を渡した場合によって動作が異なる。

```sql
-- NULL を含める場合は COUNT 関数の引数へ * を渡す。
SELECT
    COUNT(*) AS count
FROM
    Members
;

-- count : 3

-- NULL を含めない場合は引数へ列名を渡す。
SELECT
    COUNT(date_of_birth) AS count
FROM
    Members
;

-- count : 2
```

### 7.4. 相関サブクエリ

外側のクエリとサブクエリの特定のレコード同士を比較する際の書き方。

外側のクエリとサブクエリのキーとするカラムを縛り（バインドし）することで、  
比較する値をひとつにして（スカラ・サブクエリ）正常な比較ができるようにする。

```sql
-- [SQL Server][DB2][PostgreSQL][MySQL]
-- [Oracle] では AS を削除する
SELECT
    shohin_bunrui,
    shohin_mei,
    hanbai_tanka
FROM
    Shohin AS S1
WHERE
    hanbai_tanka > (
        SELECT
            AVG(hanbai_tanka)
        FROM
            Shohin AS S2
        WHERE
            -- 各商品の販売単価と平均単価の比較を同じ商品分類の中で行う！
            S1.shohin_bunrui = S2.shohin_bunrui
        GROUP BY
            shohin_bunrui

    )
;

-- 結合条件を外側のクエリに書いてしまうと動作しない。
-- 外側のクエリの実行時点でサブクエリのテーブル S2 は消滅しているため（スコープのルール）。
```

### 7.5. EXISTS

ある条件に合致するレコードの存在有無を調べる。  
`IN` で代用できるケースは多いが、パフォーマンス性に優れる。

```sql
-- EXISTS
SELECT
    *
FROM
    Members m
WHERE
    EXISTS (
        -- WHERE 句の条件を満たすレコードが存在した場合に真を返す
        SELECT
            * -- なんでもよい。1 でもよい
        FROM
            MembersSexCnt sc
        WHERE
            m.sex = sc.sex -- キーとして結合するカラムを指定
            AND sex_count >= 2 -- 条件を指定する場合は AND で繋げる
    )
;
```

### 7.6. ウィンドウ関数

別名 OLAP 関数（OnLine Analytical Processing）。  
データを集約せずにデータ分析を行える。

基本は下記のような感じ。

```sql
SELECT
    <ウィンドウ関数> OVER ([PARTITION BY <列リスト>] ORDER BY <ソート用列リスト>)

-- [] 内は省略できる。
-- <ウィンドウ関数> には下記2種の関数を指定できる。
--   1. 集約関数（SUM, AVG, COUNT など）
--   2. ウィンドウ専用関数（RANK, DENSE_RANK, ROW_NUMBER など）
```

例）

```sql
-- 商品分類別に、販売単価の安い順で並べたランキング表を作る
SELECT
    shohin_mei,
    shohin_bunrui,
    hanbai_tanka,
    RANK() OVER (PARTITION BY shohin_bunrui ORDER BY hanbai_tanka) AS ranking
FROM
    Shohin;
-- ORDER BY     -- 結果で並べたいときは最後に ORDER BY 句をつける
--     ranking

```

↓

```text
shohin_mei | shohin_bunrui | hanbai_tanka | ranking
---------- + ------------- + ------------ + --------
フォーク   | キッチン用品  |          500 |        1
おろしがね | キッチン用品  |          880 |        2
Tシャツ    | 衣服          |         1000 |        3
ボールペン | 事務用品      |          500 |        1
```

### 7.7. GROUPING

comming soon...

## 8. 自作クエリ

### 8.1. [要素の組み合わせ毎の件数を取得する](../mount_dir/sql/select_multi_count.sql)

指定したカラムのフィールドに存在する値の組み合わせ毎の件数を取得する。  
めちゃくちゃ使っている。  

```sql
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
```

### 8.2. [カラムの情報を見やすい形式で表示する](../mount_dir/sql/show_columns_info.sql)

指定したテーブルの カラム名 / 主キー / データ型 / 長さ / NULL 許可 / デフォルト値 を出力する。  
★のコメント部分へテーブル名を指定する。

PostgreSQL の `\d tb` のイメージ。
SQL Server だと手軽に確認する方法が無いようなので作成した。

```sql
SELECT
    o.name                    AS 'テーブル名',
    c.name                    AS 'カラム名',
    CASE
        WHEN pk.is_primary_key = 1
        THEN 'YES'
        ELSE 'NO'
    END                       AS '主キー',
    type_name(c.user_type_id) AS 'データ型',
    c.max_length              AS '長さ（バイト数）',
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
    AND o.name IN ('Members') -- ★ ここに確認したいテーブル名を指定する。

-- テーブル名 > カラム ID の順に昇順で出力
ORDER BY
    o.name,
    c.column_id
;
```

### 8.3. [CSV などのデータファイルからインポート](../mount_dir/sql/insert_from_CSV.sql)

※SQL Server

```sql
BULK INSERT members
FROM '/mount_dir/csv/members.csv'
WITH
    (
        FORMAT = 'CSV', -- CSV 形式で取り込み
        FIRSTROW = 2    -- 読み込み開始行を指定
    );

-- 細かく指定する場合は下記のような感じで
BULK INSERT members
FROM '/mount_dir/csv/members.csv'
WITH
    (
        DATAFILETYPE = 'char', -- 文字形式で取り込み
        FIELDTERMINATOR = ',', -- 区切り文字を指定
        ROWTERMINATOR = '\n',  -- 行末を示す文字を指定
        FIRSTROW = 2           -- 読み込み開始行を指定
    );
```

## 9. メモ

自分用のメモ。

### 9.1. SQL の文とその種類

#### 9.1.1. DDL (Data Definition Language / データ定義言語)

データを格納する入れ物であるデータベースやテーブルなどを作成したり削除したりするキーワード。  
`CREATE` , `DROP` , `ALTER` が該当する。

#### 9.1.2. DML (Data Manipulation Language / データ操作言語)

テーブルの行を検索したり変更したりするキーワード。  
`SELECT` , `INSERT` , `UPDATE` , `DELETE` が該当する。  
一番よく使われる。

#### 9.1.3. DCL (Data Control Language / データ制御言語)

データベースに対して行った変更を確定したり取り消したりするキーワード。  
そのほか、RDBMS のユーザーがデータベースにあるもの（テーブルなど）を操作する権限の設定も行う。  
`COMMIT` , `ROLLBACK` , `GRANT` , `REVOKE` が該当する。

### 9.2. [SQL Server]文字列型 4種の違い

| データ型 | バイト数           | 全角文字 | 文字数     | 文字列の形式   |
| -------- | ------------------ | -------- | ---------- | -------------- |
| CHAR     | 半角 1 / 全角 2    | 非推奨   | 固定       | 固定長文字列   |
| VARCHAR  | 半角 1 / 全角 2    | 非推奨   | 可変       | 可変長文字列   |
| NCHAR    | 半角・全角ともに 2 | 推奨     | 固定       | 固定長文字列   |
| NVARCHAR | 半角・全角ともに 2 | 推奨     | 可変       | 可変長文字列   |

- 「N」がない CHAR 型、VARCHAR 型は **半角と全角でバイト数が変わる** 。
    - そのため、全角文字は非推奨。
- 「N」がある NCHAR 型、NVARCHAR 型は **半角・全角ともに2バイトで保持される** 。
    - そのため、全角文字が入り得るカラムはこちらを使う。
- 「VAR」がない CHAR 型、NCHAR 型は **固定長文字列** 形式。
    - たとえば `CHAR(8)` の列に `'abc'` という文字を入れた場合、`'abc     '`（abc の後ろに半角スペースが5つ）という形で格納される。
- 「VAR」がある VARCHAR 型、NVARCHAR 型は **可変長文字列** 形式。
    - たとえば `VARCHAR(8)` の列に `'abc'` という文字を入れた場合、データはそのまま `'abc'` という形で格納される。

参考 :  
[charとvarcharとncharとnvarcharの違い | あられブログ](https://arare-blog.com/charvarcharncharnvarchar-usemethod)

### 9.3. 「SQL」と「クエリ」

#### 9.3.1. SQL (Structured Query Language)

RDB を操作するための言語。

#### 9.3.2. クエリ（Query）

必要なデータを検索し、取り出すこと・もの。**問い合わせ** とも言う。

#### 9.3.3. つまり「SQL クエリ」って？

RDB を操作するための言語（SQL）を使って問い合わせること・もの！！！！！！！！

### 9.4. 混同しやすい用語たち

#### 9.4.1. 文

SQL 全体の記述内容。

#### 9.4.2. 句

SQL 文を構成する要素で、`SELECT` や `FROM` などのキーワードから始まるフレーズ。  
`SELECT member_id, member_name` や `FROM Members` がそれにあたる。

#### 9.4.3. 予約語（キーワード）

最初から意味や使い方が決められている特別な英単語。  
`SELECT` や `FROM` がそれにあたる。

#### 9.4.4. 式

`CASE` や演算子などを用いて記述される、条件式のこと。  
WHERE 句の中で主に記述される `age <= 20` や、CASE 式 `CASE WHEN member_name = 'Modane' THEN 'kawaii' ELSE NULL END` がそれにあたる。

**式は評価されてひとつの値に定まる** 。

#### 9.4.5. 関数

入力に対して出力を返してくれる機能。  
算術関数（`+, -, *, /` や `ROUND` など）、文字列関数（`REPLACE` や `UPPER` など）、集約関数（`COUNT` や `SUM` など）などがある。

#### 9.4.6. 述語

戻り値が真理値になる関数のこと。`LIKE` や `BETWEEN` 、`ISNULL` など。  
`=, <, >, <>` などの比較演算子も、正確には比較述語という述語の一種。

#### 9.4.7. …つまり？

```sql
-- この SQL 全体の記述が「SQL 文」！

-- SELECT 句
SELECT -- 予約語「SELECT」
    member_id,
    member_name,
    CASE WHEN member_name = 'Modane' THEN 'kawaii' ELSE NULL END, -- CASE 式
    COUNT(*) -- COUNT 関数

-- FROM 句
FROM -- 予約語「FROM」
    Members

-- WHERE 句
WHERE -- 予約語「FROM」
    member_name LIKE 'M%' -- LIKE 述語で記述された条件式
;
```

### 9.5. DISTINCT と GROUP BY の使い分け

`DISTINCT` と `GROUP BY` 句は「重複を排除する」という点でどちらも同じ動作をする。  
実行速度もほぼ同じだそう。

なので、使い分けとしては「その `SELECT` 文の意味が条件に合致しているかどうかを考えよう。

例えば「選択結果から重複を除外したい」という要件に対しては `DISTINCT` を使い、「集約した結果を求めたい」という要件に対しては `GROUP BY` 句を使う…というのが筋の通った使い方！

## 10. 参考文献

- [SQL 第2版 ゼロからはじめるデータベース操作 (プログラミング学習シリーズ)](https://www.amazon.co.jp/gp/product/4798144452/ref=ppx_yo_dt_b_asin_title_o00_s00)
- [達人に学ぶSQL徹底指南書 第2版 初級者で終わりたくないあなたへ](https://www.amazon.co.jp/gp/product/4798157821/ref=ppx_yo_dt_b_asin_title_o02_s00)
