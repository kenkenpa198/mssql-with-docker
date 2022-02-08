<!-- omit in toc -->
# MSSQL with Docker

## 基本の使い方

### 環境構築

環境構築.md （作成中）を基に下記の環境を構築する！

- WSL2（Ubuntu）
- Docker
- Docker Compose

### 開始

1. WSL を立ち上げる。
2. WSL 環境上で Docker が起動しているか確認する。
    1. `sudo service docker status` を送信する。
    2. `Docker is running` と出力された場合:
    OK 。
    3. `Docker is not running` と表示された場合:
    起動させるコマンド `sudo service docker start` を送信して、もっかい確認コマンドを送信して確認する。
3. `docker-compose up -d` を送信して SQL Server のコンテナを作成 & バックグラウンドで起動する。
4. `docker ps` コマンドを送信してコンテナが起動中か確認する。
5. `docker-compose exec main bash` で起動中のコンテナへ入る。
6. `sqlcmd -S localhost -U SA -P 'Test1234'` を送信して SQL Server へログインする。
7. SQL Server のコマンドを参考に作業する！

### 終了

1. SQL Server から抜けるときは `exit` を送信する。
2. コンテナから抜けるときも `exit` を送信する。
3. `docker-compose stop` で起動中のコンテナを停止する。
4. `docker ps` コマンドを送信してコンテナが一覧に表示されていないことを確認する。
5. `sudo service docker stop` を送信して Docker を停止する。
6. `sudo service docker status` で Docker が終了していることを確認する。

## 1. Docker

### 1.1. Docker コマンド

- Docker を起動

    ```shell
    sudo service docker status # 確認
    sudo service docker start  # 起動
    ```

- 起動中の Docker Image を表示

    ```shell
    docker ps
    ```

### 1.2. Docker Compose コマンド

- コンテナをバックグラウンドで起動

    ```shell
    docker-compose up -d
    ```

- 起動しているコンテナに bash で入る

    ```shell
    docker-compose exec main bash

    # 抜けるときは `exit` を送信する
    ```

- 起動しているコンテナを停止する

    ```shell
    docker-compose stop
    ```

- 起動しているコンテナのログを表示する

    ```shell
    docker-compose logs -f
    ```

- コンテナを削除する

    ```shell
    docker-compose down
    ```

## 2. SQL Server

### 2.1. 基本

- SQL Server へログインする

    ```shell
    sqlcmd -S localhost -U SA -P 'Test1234'
    ```

- ログイン + SQL をファイルから読みだして実行

    ```shell
    sqlcmd -S localhost -U SA -P 'Test1234' -i /mount_dir/sql/show_databases.sql
    ```

### 2.2. データベース操作

- データベース一覧を取得する

    ```sql
    select name from sys.databases;
    go
    ```

- データベースを作成する

    ```sql
    create database <<database-name>> ;
    go
    ```

- 使用するデータベースを設定する

    ```sql
    use <<database-name>> ;
    go
    ```

- 使用しているデータベースを確認する

    ```sql
    select DB_NAME() ;
    go
    ```

### 2.3. テーブル操作

- テーブル一覧を表示する

    ```sql
    select name from sysobjects where xtype = 'U' ;
    go
    ```

- テーブルを作成する

    ```sql
    create table members (
        member_id int not null primary key,
        first_name varchar(50) null,
        last_name varchar(50) null,
        created_at datetime not null,
        updated_at datetime null
    )
    ;
    go
    ```

- カラムの情報を表示する

    ```sql
    select * from sys.columns
    where object_id = object_id('members')
    go
    ```

- カラムの情報を表示する（列名 / 型 / 長さ / NULL 許可 のみ）

    ```text
    mount_dir/sql/show_columns.sql を見てね
    ```

### 2.3. レコード操作

- レコードを抽出する

    ```sql
    select
        member_id,
        first_name,
    from members
    where 条件
    ;
    go

    -- 全部抜き出すときは select 句に * を指定しよう
    ```

- レコードを追加する（1行）

    ```sql
    insert into members (
        member_id,
        first_name,
        last_name,
        created_at
    )
    values (
        1,
        'modane',
        'sakura',
        '2021-01-01 00:00:00'
    )
    ;
    go

    -- すべての列へ値を入れる際は members のカラム指定 (a, b, c, ...) を省略できる
    ```

- 別テーブルから SELECT 句での抽出結果を追加する

    ```sql
    insert into members (
        member_id,
        first_name,
        last_name,
        created_at
    )
    select
        member_id,
        first_name,
        last_name,
        created_at
    from members_sub
    where 条件
    ;
    go
    ```

- レコードを削除する

    ```sql
    delete
    from members
    where 条件
    ;
    go
    ```
