<!-- omit in toc -->
# コマンドメモ

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

参考:
https://qiita.com/chihiro/items/75b12aca631f79be28b2

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
