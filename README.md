<!-- omit in toc -->
# MSSQL with Docker

SQL Server を WSL 上の Docker コンテナで構築するサンプルです。

## 1. 必要環境

- WSL2（Ubuntu）
- Docker
- Docker Compose

## 2. 基本の使い方

とりあえずこの項目だけ押さえておけば 起動～作業～終了 まで行えると思います。  
[環境構築メモ.md](環境構築メモ.md) 、[コマンドメモ.md](コマンドメモ.md) もご参考に。

### 2.1. 作業を開始するとき

1. WSL2 を立ち上げる。
   1. Azure Data Studio で接続する場合は `ip a | grep eth0 | grep inet` を実行しておいて IP アドレスを控えておく。
2. WSL2 環境上で Docker が起動しているか `sudo service docker status` を送信して確認する。
    1. `Docker is running` と出力された場合: 問題なし。
    2. `Docker is not running` と表示された場合: Docker を起動させるコマンド `sudo service docker start` を送信後、もう一度確認コマンドを送信して確認する。
3. `docker-compose up -d` を送信して SQL Server のコンテナを作成 & バックグラウンドで起動する。
4. `docker ps` コマンドを送信してコンテナが起動中か確認する。
5. 作業方法に合わせて SQL Server の利用を開始する。
   1. CLI から実行する場合:
      1. `docker-compose exec db bash` で起動中のコンテナへ入る。
      2. `sqlcmd -S localhost -U SA -P 'Test1234'` を送信して SQL Server へログインする。
   2. Azure Data Studio で接続して実行する場合:
      1. 控えておいた IP アドレスを接続先サーバーへ指定する。

            ```text
            「inet AAA.BB.CCC.DDD/20 brd .....」 の場合
            ⇒ 「tcp:AAA.BB.CCC.DDD, 1433」を指定する。
            ```

      2. `接続` ボタンをクリックし、接続ができたことを確認する。

### 2.2. 作業を終了するとき

1. SQL Server から抜けるときは `exit` を送信する。
2. コンテナから抜けるときも `exit` を送信する。
3. `docker-compose stop` で起動中のコンテナを停止する。
4. `docker ps` コマンドを送信してコンテナが一覧に表示されていないことを確認する。
5. `sudo service docker stop` を送信して Docker を停止する。
6. `sudo service docker status` で Docker が終了していることを確認する。
