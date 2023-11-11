# pgo-test
pgo-testは、GoのPGO(Profile-Guided Optiomization)のための検証用リポジトリです。

## ディレクトリ構成

```
├── bin         # バイナリが格納されます
├── internal    # メインのソースコードが格納されます
├── load        # profileを取得するためのスクリプトが格納されます
├── log         # 解析中のログが格納されます
├── main.go     # Goコードのエントリポイント
├── profile     # profileが格納されます
└── script      # 一連の操作をまとめたスクリプトが格納されます
```

## スクリプト
`script` ディレクトリには、

- setup.bash
- bench.bash
- diff.bash

の3ファイルが格納されています。

`setup.bash` は後続のスクリプトファイルで利用するコマンドをインストールするためのスクリプトです。

`bench.bash` はバイナリをビルドしてPGOを用いたビルドを実施するコマンドが列挙されたスクリプトです。

`diff.bash` は `bench.bash` でビルドされたバイナリとprofileを用いて、それらのバイナリ等を比較するためのスクリプトです。

それぞれのスクリプトにコメントが記載されているので参照してください。


```bash
# install tool
./script/setup.bash

# run benchmark
./script/bench.bash

# check diff
./script/diff.bash
```
