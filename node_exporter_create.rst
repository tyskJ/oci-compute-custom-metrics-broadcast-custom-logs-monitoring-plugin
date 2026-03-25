Linux
=====================================================================
.. note::

  * ``root`` ユーザーにて実行します

1. バイナリ取得
---------------------------------------------------------------------
* `リリースノート <https://github.com/prometheus/node_exporter/releases>`_ よりインストーラーを取得し解凍します
* CPU は合わせてください
* バイナリを所定の位置に移動させます

.. code-block:: bash

  VER=1.10.2
  wget https://github.com/prometheus/node_exporter/releases/download/v${VER}/node_exporter-${VER}.linux-amd64.tar.gz
  tar xvzf node_exporter-${VER}.linux-amd64.tar.gz
  mv /root/node_exporter-${VER}.linux-amd64/node_exporter /usr/local/bin/

2. 専用システムユーザー作成 & バイナリ所有権変更
---------------------------------------------------------------------
.. code-block:: bash

  useradd -s /sbin/nologin -M node_exporter
  chown node_exporter:node_exporter /usr/local/bin/node_exporter

3. サービス化
---------------------------------------------------------------------
* ``Socket`` ファイル起動とするため、``socket`` ファイルを作成 (あえて)

.. code-block:: bash
  :caption: /etc/systemd/system/node_exporter.socket

  [Unit]
  # このソケットユニットの説明（systemctl status で表示される）
  Description=Node Exporter

  [Socket]
  # TCPポート9100番(デフォルト)で待ち受けする設定
  # systemd自身がこのポートをlistenする（node_exporterではない）
  # 接続が来たタイミングで対応する .service を起動する（socket activation）
  ListenStream=9100

  # （補足）
  # ListenStream は TCP 用
  # UNIXソケットの場合は ListenStream=/path/to/socket も指定可能

  [Install]
  # sockets.target が起動するタイミングでこのソケットを有効化する
  # → systemctl enable すると OS起動時に自動でlisten開始される
  WantedBy=sockets.target




Windows
=====================================================================
1. インストーラー取得
---------------------------------------------------------------------
* `リリースノート <https://github.com/prometheus-community/windows_exporter/releases>`_ よりインストーラーを取得
* ``msi`` ファイル取得 (CPUは合わせること)

2. インストーラー実行
---------------------------------------------------------------------
* 管理者権限で ``Powershell`` を起動し、以下実行

.. code-block:: powershell

  msiexec.exe /i <path-to-msi-file> --% ENABLED_COLLECTORS=cpu,logical_disk,memory,process,service

.. note::

  * ``path-to-msi-file`` は適宜変更すること
  * 取得対象メトリクスは適宜修正すること
  * コマンド実行後インストールプロンプトが表示されるため、デフォルトで完了させる

3. 起動確認
---------------------------------------------------------------------
* ブラウザにて ``http://localhost:9182/metrics`` を呼び出し、``windows_*`` のメトリクスが表示されればOK
* ``windows_exporter`` サービスが登録されますので、サーバーマネージャーから確認できます

参考資料
=====================================================================
リファレンス
---------------------------------------------------------------------
* `prometheus/node_exporter - GitHub <https://github.com/prometheus/node_exporter>`_
* `prometheus/node_exporter/releases - GitHub <https://github.com/prometheus/node_exporter/releases>`_
* `prometheus-community/windows_exporter - GitHub <https://github.com/prometheus-community/windows_exporter>`_
* `prometheus-community/windows_exporter/releases - GitHub <https://github.com/prometheus-community/windows_exporter/releases>`_