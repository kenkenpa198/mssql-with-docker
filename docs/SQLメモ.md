<!-- omit in toc -->
# SQL メモ

標準 SQL を中心にまとめた自分用メモ。  
実際に使えるコードは [mount_dir 上](../mount_dir/sql/) へ格納。

データベース特有の操作・方言だったり他環境で確認が取れていない場合は、見出しの先頭へ [SQL Server] のようにタグをつけている。

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
- [4. レコード操作](#4-レコード操作)
    - [4.1. レコードを追加する](#41-レコードを追加する)
        - [4.1.1. 基本](#411-基本)
        - [4.1.2. 特定のカラムのみを指定](#412-特定のカラムのみを指定)
        - [4.1.3. SELECT 句での抽出結果から](#413-select-句での抽出結果から)
        - [4.1.4. [SQL Server]CSV などのデータファイルからインポート](#414-sql-servermount_dirsqlinsert_from_csvsql)
    - [4.2. レコードを削除する](#42-レコードを削除する)
- [5. 検索](#5-検索)
    - [5.1. 基本](#51-基本)
    - [5.2. 要素の組み合わせ毎の件数を取得する](#52-要素の組み合わせ毎の件数を取得する)
    - [5.3. [SQL Server]カラムの情報を見やすい形式で表示する](#53-sql-servermount_dirsqlshow_columns_infosql)
- [6. メモ](#6-メモ)
    - [6.1. SQL の文とその種類](#61-sql-の文とその種類)
        - [6.1.1. DDL (Data Definition Language / データ定義言語)](#611-ddl-data-definition-language--データ定義言語)
        - [6.1.2. DML (Data Manipulation Language / データ操作言語)](#612-dml-data-manipulation-language--データ操作言語)
        - [6.1.3. DCL (Data Control Language / データ制御言語)](#613-dcl-data-control-language--データ制御言語)
    - [6.2. [SQL Server]文字列型 4種の違い](#62-sql-server文字列型-4種の違い)
    - [6.3. 「SQL」と「クエリ」](#63-sqlとクエリ)
        - [6.3.1. SQL (Structured Query Language)](#631-sql-structured-query-language)
        - [6.3.2. クエリ（Query）](#632-クエリquery)
        - [6.3.3. つまり「SQL クエリ」って？](#633-つまりsql-クエリって)
    - [6.4. 「キーワード」と「句」と「式」と「文」](#64-キーワードと句と式と文)
        - [6.4.1. キーワード](#641-キーワード)
        - [6.4.2. 句](#642-句)
        - [6.4.3. 式](#643-式)
        - [6.4.4. 文](#644-文)
        - [6.4.5. …つまり？](#645-つまり)
- [7. 参考文献](#7-参考文献)

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

## 4. レコード操作

### 4.1. レコードを追加する

#### 4.1.1. 基本

```sql
-- [SQL Server][PostgreSQL]
BEGIN TRANSACTION; -- 行の追加を開始する

--                          member_id  member_name  sex       age  foo_num  date_of_birth
INSERT INTO Members VALUES ('0001',    'Modane',    'female', 18,  111,     '2019-09-08');
INSERT INTO Members VALUES ('0002',    'Ryunosuke', 'male',   21,  NULL,    '2017-09-29');
INSERT INTO Members VALUES ('0003',    'Tsukune'  , 'female', 19,  222,     NULL);

COMMIT;            -- 行の追加を確定する
```

MySQL の場合、`BEGIN TRANSACTION;` を下記に変更する。

```sql
START TRANSACTION;
```

Oracle, DB2 の場合は `BEGIN TRANSACTION;` が必要ないので削除する。

#### 4.1.2. 特定のカラムのみを指定

```sql
INSERT INTO Members (
    member_id,
    member_name,
    date_of_birth
)
VALUES (
    1,
    'Modane',
    '2019-09-08'
);
```

#### 4.1.3. SELECT 句での抽出結果から

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
WHERE
    条件
;

-- すべての列へ値を入れる際は Members のカラム指定 (a, b, c, ...) を省略できる
INSERT INTO Members
SELECT
    member_id,
    member_name,
    date_of_birth
FROM
    Foo_Table
WHERE
    条件
;
```

#### 4.1.4. [SQL Server][CSV などのデータファイルからインポート](../mount_dir/sql/insert_from_CSV.sql)

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

### 4.2. レコードを削除する

```sql
DELETE
FROM
    Members
WHERE
    条件
;
```

## 5. 検索

### 5.1. 基本

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

### 5.2. [要素の組み合わせ毎の件数を取得する](../mount_dir/sql/select_multi_count.sql)

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

### 5.3. [SQL Server][カラムの情報を見やすい形式で表示する](../mount_dir/sql/show_columns_info.sql)

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

## 6. メモ

自分用のメモ。

### 6.1. SQL の文とその種類

#### 6.1.1. DDL (Data Definition Language / データ定義言語)

データを格納する入れ物であるデータベースやテーブルなどを作成したり削除したりするキーワード。  
`CREATE` , `DROP` , `ALTER` が該当する。

#### 6.1.2. DML (Data Manipulation Language / データ操作言語)

テーブルの行を検索したり変更したりするキーワード。  
`SELECT` , `INSERT` , `UPDATE` , `DELETE` が該当する。  
一番よく使われる。

#### 6.1.3. DCL (Data Control Language / データ制御言語)

データベースに対して行った変更を確定したり取り消したりするキーワード。  
そのほか、RDBMS のユーザーがデータベースにあるもの（テーブルなど）を操作する権限の設定も行う。  
`COMMIT` , `ROLLBACK` , `GRANT` , `REVOKE` が該当する。

### 6.2. [SQL Server]文字列型 4種の違い

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

### 6.3. 「SQL」と「クエリ」

#### 6.3.1. SQL (Structured Query Language)

RDB を操作するための言語。

#### 6.3.2. クエリ（Query）

必要なデータを検索し、取り出すこと・もの。**問い合わせ** とも言う。

#### 6.3.3. つまり「SQL クエリ」って？

RDB を操作するための言語（SQL）を使って問い合わせること・もの！！！！！！！！

### 6.4. 「キーワード」と「句」と「式」と「文」

#### 6.4.1. キーワード

最初から意味や使い方が決められている特別な英単語。  
`SELECT` や `FROM` がそれにあたる。

#### 6.4.2. 句

SQL 文を構成する要素で、`SELECT` や `FROM` などのキーワードから始まるフレーズ。  
`SELECT member_id, member_name` や `FROM Members` がそれにあたる。

#### 6.4.3. 式

`CASE` や演算子などを用いて記述される、条件式のこと。  
WHERE 句の中で主に記述される `age <= 20` や、CASE 式 `CASE WHEN member_name = 'Modane' THEN 'kawaii' ELSE NULL END` がそれにあたる。

**式は評価されてひとつの値に定まる** 。

#### 6.4.4. 文

SQL 全体の記述内容。

#### 6.4.5. …つまり？

```sql
-- この SQL 全体の記述が「文」！

-- SELECT「句」ここから
SELECT -- キーワード「SELECT」
    member_id,
    member_name,
    CASE WHEN member_name = 'Modane' THEN 'kawaii' ELSE NULL -- CASE 式
    END
-- SELECT 句 ここまで

-- FROM 句
FROM -- キーワード「FROM」
    Members

-- WHERE 句
WHERE -- キーワード「FROM」
    age <= 20 -- 条件式
;
```

## 7. 参考文献

- [SQL 第2版 ゼロからはじめるデータベース操作 (プログラミング学習シリーズ)](https://www.amazon.co.jp/gp/product/4798144452/ref=ppx_yo_dt_b_asin_title_o00_s00)
- [達人に学ぶSQL徹底指南書 第2版 初級者で終わりたくないあなたへ](https://www.amazon.co.jp/gp/product/4798157821/ref=ppx_yo_dt_b_asin_title_o02_s00)
