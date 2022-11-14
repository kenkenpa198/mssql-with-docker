<!-- omit in toc -->
# mssql-with-docker

SQL Server を WSL 上の Docker コンテナで構築する自分用テンプレート & メモ置き場です。  

<!-- omit in toc -->
## 目次

- [1. リンク](#1-リンク)
- [2. 必要な環境](#2-必要な環境)
- [3. 作業を開始するとき](#3-作業を開始するとき)
- [4. 作業を終了するとき](#4-作業を終了するとき)
- [5. service コマンドによる Docker 起動方法](#5-service-コマンドによる-docker-起動方法)
    - [5.1. 起動するとき](#51-起動するとき)
    - [5.2. 停止するとき](#52-停止するとき)
    - [5.3. 補足: なぜ WSL の立ち上げ時に Docker コマンドを受け付けないのか](#53-補足-なぜ-wsl-の立ち上げ時に-docker-コマンドを受け付けないのか)
- [6. 参考文献](#6-参考文献)
    - [6.1. WSL](#61-wsl)
    - [6.2. Docker](#62-docker)
    - [6.3. Azure Data Studio](#63-azure-data-studio)

## 1. リンク

- [SQLメモ.md](docs/SQLメモ.md)
- [コマンドメモ.md](docs/コマンドメモ.md)
- [環境構築メモ.md](docs/環境構築メモ.md)

## 2. 必要な環境

- OS: Windows 10 バージョン 2004 以降 (ビルド 19041 以降) または Windows 11
- WSL（Ubuntu）
- Docker
    - メモリ制限 : 2GB 以上 ※
- Docker Compose

※ SQL Server の Docker Image は 2GB 以上が必須要件。  
[Microsoft SQL Server by Microsoft | Docker Hub](https://hub.docker.com/_/microsoft-mssql-server#:~:text=Configuration-,Requirements,-This%20image%20requires)

## 3. 作業を開始するとき

1. WSL を起動し、このディレクトリへ入る。

    ```shell
    $ cd mssql-with-docker
    ```

2. Docker を起動する。
    1. Win 環境へ Docker Desktop をインストールしていた場合、Windows のスタートメニュー等から Docker Desktop アプリを実行する。
    2. WSL 環境へ Docker を直接インストールしていた場合、 [5. service コマンドによる Docker 起動方法](#5-service-コマンドによる-docker-起動方法) セクションを参考に起動する。
3. Docker コンテナを `docker-compose.yml` を使用して起動する。

    ```shell
    # docker-compose.yml を使用してバックグラウンドで起動
    $ sudo docker-compose up -d
    Creating network "mssql-with-docker_default" with the default driver
    Creating mssql-with-docker_db_1 ... done # '... done' が出力されれば OK
    ```

    1. 初めての実行の場合、公式 Docker イメージのプルから始まるのでしばらく待つ。

        ```shell
        $ sudo docker-compose up -d
        Creating network "mssql-with-docker_default" with the default driver
        Creating volume "mssql-with-docker_db-volume" with default driver
        Pulling db (mcr.microsoft.com/mssql/server:2019-latest)...
        ...
        Status: Downloaded newer image for mcr.microsoft.com/mssql/server:2019-latest
        Creating mssql-with-docker_db_1 ... done # '... done' が出力されれば OK
        ```

4. Docker コンテナが起動中か確認する。

    ```shell
    # 起動中のコンテナを確認
    $ sudo docker ps
    CONTAINER ID   IMAGE                                      ... NAMES
    aaaaaaaaaaaa   mcr.microsoft.com/mssql/server:2019-latest ... mssql-with-docker_db_1 # NAMES へ 'mssql-with-docker_db_1' が表示されていれば OK

    # 生成されたデータボリュームを確認
    $ sudo docker volume ls
    DRIVER    VOLUME NAME
    local     mssql-with-docker_db-volume # 'mssql-with-docker_db-volume' が表示されていれば OK
    ```

5. 作業方法に合わせて SQL Server の利用を開始する。
   1. CLI から実行する場合:
        1. コンテナ内の sqlcmd を使ってログインする。

        ```shell
        $ sudo docker exec -it mssql-with-docker_db_1 sqlcmd -S localhost -U SA -P 'パスワード'
        1>
        ```

   2. Azure Data Studio で接続して実行する場合:
        1. 画面左部のサーバー一覧から [環境構築メモ.md](docs/環境構築メモ.md) で作成したサーバーを選択する。
        2. `接続` ボタンをクリックし、接続ができたことを確認する。

## 4. 作業を終了するとき

1. sqlcmd または Azure Data Studio での接続を切断する。
2. 起動中のコンテナを停止する。

    ```shell
    $ sudo docker-compose stop
    Stopping mssql-with-docker_db_1 ... done
    ```

3. コンテナが起動中でないことを確認する。

    ```shell
    $ docker ps
    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

    # 何も表示されていない状態であれば OK
    ```

4. 必要であれば Docker も終了する。
    1. Win 環境へ Docker Desktop をインストールしていた場合、Windows のタスクバー > Docker のアイコンを右クリック > `Quit Docker Desktop` を実行する。
    2. WSL 環境へ Docker を直接インストールしていた場合、 [5. service コマンドでの Docker 起動方法](#5-service-コマンドでの-docker-起動方法) セクションを参考に停止する。

## 5. service コマンドによる Docker 起動方法

WSL は立ち上げ時に Docker コマンドが受け付けられない状態となっている（詳しくは [補足](#53-補足-なぜ-WSL-の立ち上げ時に-docker-コマンドを受け付けないのか) セクションを参照）。  

```shell
# WSL 起動直後の状態で docker コマンドを実行
$ sudo docker ps
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

このため、`service` コマンドを使って Docker コマンドを受け付けられる状態にする。

### 5.1. 起動するとき

```shell
# Docker デーモン（Docker の常駐プログラム）の起動状態を確認
$ sudo service docker status
* Docker is not running                # 'is not running' と表示されていれば起動中ではない

# Docker デーモンを service コマンドで起動する
$ sudo service docker start
* Starting Docker: docker        [ OK ]

# Docker デーモンの起動状態をもう一度確認
$ sudo service docker status
* Docker is running                    # 'is running' と表示されれば起動中である
```

### 5.2. 停止するとき

```shell
# Docker デーモンの起動状態を確認
$ sudo service docker status
* Docker is running

# Docker デーモンを service コマンドで停止する
$ sudo service docker stop
* Stopping Docker: docker        [ OK ]

# Docker デーモンの起動状態をもう一度確認
$ sudo service docker status
* Docker is not running
```

### 5.3. 補足: なぜ WSL の立ち上げ時に Docker コマンドを受け付けないのか

※ 以下個人的な理解のため間違っているかもしれません。

Docker は「Docker デーモン（※1）」が基盤となり各処理が実行される。  
この Docker デーモンは Linux 標準のプログラム「Systemd（※2）」によって OS の起動時に自動実行されている。

しかし WSL は Systemd に対応していない（※3）ため、WSL の立ち上げ時には Docker デーモンも起動していない状態となっている。

したがって WSL を起動後に続けて Docker コマンドを送信しても、受け取り手がそもそも存在しないのでコマンドが受け付けられないということ。

※1 デーモン … Linux 上で実行される常駐プログラムの総称。Windows でいう「サービス」にあたる。  
※2 Systemd … Linux のシステム初期化・管理・設定を担うプログラム。ちなみに Systemd 自体もデーモンである。
※3 [Microsoft Store 版 v0.67.6 以降の WSL は Systemd に対応したらしい](https://forest.watch.impress.co.jp/docs/news/1441775.html)（未検証）。

なお Docker Desktop を使用する場合は Docker Desktop の起動時に WSL 上の Docker デーモンも起動してくれるそう。  
このため、デーモンを手動で起動せずともコマンドの実行が可能。

## 6. 参考文献

### 6.1. WSL

- [WSL のインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/windows/wsl/install)
- [Windows Terminal + WSL 2 + Homebrew + Zsh - Qiita](https://qiita.com/okayurisotto/items/36f6f9df499a74e62bff)
- [windows10でVSCode+WSL2(Ubuntu)+Docker Desktopの開発環境を作る](https://zenn.dev/ivgtr/scraps/92e14f80683be9)

### 6.2. Docker

- [Docker Documentation | Docker Documentation](https://docs.docker.com/)
- [Docker ドキュメント日本語化プロジェクト — Docker-docs-ja 20.10 ドキュメント](https://docs.docker.jp/index.html)
- [Microsoft SQL Server - Ubuntu based images by Microsoft | Docker Hub](https://hub.docker.com/_/microsoft-mssql-server)
- [ubuntu20.04にDockerとdocker-composeをインストールする](https://zenn.dev/k_neko3/articles/76340d2db1f43d)
- [Dockerのデータを永続化！Data Volume（データボリューム）の理解から始める環境構築入門 | Enjoy IT Life](https://nishinatoshiharu.com/docker-volume-tutorial/)
- [DockerでSQL Serverを建ててsqlcmd, SSMS, JDBCでアクセスする - DockerでSQL Serverを建ててsqlcmd, SSMS, JDBCでアクセスする - aegif Labo Blog Alfresco](https://aegif.jp/alfresco/tech-info/-/20201104-alfresco/1.3)
- [さわって理解するDocker入門 第6回 | オブジェクトの広場](https://www.ogis-ri.co.jp/otc/hiroba/technical/docker/part6.html)
- [WindowsでDockerデーモンを自動起動させる方法をまとめてみる without Docker Desktop - Qiita](https://qiita.com/mechagumi/items/6838cd313d8b26b4b438)

### 6.3. Azure Data Studio

- [Azure Data Studio - 日本語化する方法](https://www.curict.com/item/48/48b33f5.html)
- [WSL2上のDockerでSQL Server実行してSSMSで繋ぐまで - YOMON8.NET](https://yomon.hatenablog.com/entry/2020/03/wsl2_mssql_ssms)
