<!-- omit in toc -->
# MSSQL with Docker

SQL Server を WSL 上の Docker コンテナで構築する自分用テンプレート & メモ置き場です。  

## 1. リンク

- [SQLメモ.md](docs/SQLメモ.md)
- [コマンドメモ.md](docs/コマンドメモ.md)
- [環境構築メモ.md](docs/環境構築メモ.md)

## 2. 必要な環境

- OS: Windows 10 バージョン 2004 以降 (ビルド 19041 以降) または Windows 11
- WSL2（Ubuntu）
- Docker
    - メモリ制限 : 2GB 以上 ※
- Docker Compose

※ SQL Server の Docker Image は 2GB 以上が必須要件。  
[Microsoft SQL Server by Microsoft | Docker Hub](https://hub.docker.com/_/microsoft-mssql-server#:~:text=Configuration-,Requirements,-This%20image%20requires)

## 3. 作業を開始するとき

1. WSL2 を立ち上げる。
2. WSL2 環境上で Docker が起動しているか `sudo service docker status` を送信して確認する。
    1. `Docker is running` と出力された場合: 問題なし。
    2. `Docker is not running` と表示された場合: Docker を起動させるコマンド `sudo service docker start` を送信後、もう一度確認コマンドを送信して確認する。
3. `docker-compose up -d` を送信して SQL Server のコンテナを作成 & バックグラウンドで起動する。
4. `docker ps` コマンドを送信してコンテナが起動中か確認する。
5. 作業方法に合わせて SQL Server の利用を開始する。
   1. CLI から実行する場合:
        1. コンテナ内の sqlcmd を使ってログインする。

        ```shell
        $ docker exec -it mssql_with_docker_db_1 /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'パスワード'
        1>
        ```

   2. Azure Data Studio で接続して実行する場合:
        1. 画面左部のサーバー一覧から [環境構築メモ.md](docs/環境構築メモ.md) で作成したサーバーを選択する。
        2. `接続` ボタンをクリックし、接続ができたことを確認する。

## 4. 作業を終了するとき

1. `docker-compose stop` で起動中のコンテナを停止する。
2. `docker ps` コマンドを送信してコンテナが一覧に表示されていないことを確認する。
3. `sudo service docker stop` を送信して Docker を停止する。
4. `sudo service docker status` で Docker が終了していることを確認する。

## 5. 参考文献

### 5.1. WSL2

- [WSL のインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/windows/wsl/install)
- [Windows Terminal + WSL 2 + Homebrew + Zsh - Qiita](https://qiita.com/okayurisotto/items/36f6f9df499a74e62bff)
- [windows10でVSCode+WSL2(Ubuntu)+Docker Desktopの開発環境を作る](https://zenn.dev/ivgtr/scraps/92e14f80683be9)

### 5.2. Docker

- [Docker Documentation | Docker Documentation](https://docs.docker.com/)
- [Docker ドキュメント日本語化プロジェクト — Docker-docs-ja 20.10 ドキュメント](https://docs.docker.jp/index.html)
- [ubuntu20.04にDockerとdocker-composeをインストールする](https://zenn.dev/k_neko3/articles/76340d2db1f43d)
- [Microsoft SQL Server by Microsoft | Docker Hub](https://hub.docker.com/_/microsoft-mssql-server)
- [Dockerのデータを永続化！Data Volume（データボリューム）の理解から始める環境構築入門 | Enjoy IT Life](https://nishinatoshiharu.com/docker-volume-tutorial/)
- [DockerでSQL Serverを建ててsqlcmd, SSMS, JDBCでアクセスする - DockerでSQL Serverを建ててsqlcmd, SSMS, JDBCでアクセスする - aegif Labo Blog Alfresco](https://aegif.jp/alfresco/tech-info/-/20201104-alfresco/1.3)

### 5.3. Azure Data Studio

- [Azure Data Studio - 日本語化する方法](https://www.curict.com/item/48/48b33f5.html)
- [WSL2上のDockerでSQL Server実行してSSMSで繋ぐまで - YOMON8.NET](https://yomon.hatenablog.com/entry/2020/03/wsl2_mssql_ssms)
