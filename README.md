# EasyCMake
このリポジトリはCMakeプロジェクトのテンプレート形式になっています。このプロジェクトではCMakeLists.txtがディレクトリ内のソースファイルを自動で探索するため、プロジェクトに合わせてCMakeLists.txtを書き直す必要がありません。

今後、boostなどの外部ライブラリをリンクする機能も追加する予定です。

## 機能
- ソースファイルの自動探索
- 一つのプロジェクトで複数の実行ファイルを生成
- プロジェクト内のすべての実行ファイルで共有されるインクルードパス及びソースファイルの管理
- 各実行ファイルのみで有効なインクルードパス及びソースファイルの管理

## ディレクトリ構造
このプロジェクトにはmoduleとappという特有の概念が存在します。moduleはmodulesディレクトリ内のソースファイルやヘッダファイルの集まりです。appはappsディレクトリの各サブディレクトリで管理されるソースファイルやヘッダファイルの集まりです。

```
EasyCMake/
├── .gitignore
├── CMakeLists.txt
├── EasyCMake.cmake
├── LICENSE
├── README.md
├── build/
├── apps/
│   ├── app1/
│   │   ├── app1.cpp
│   │   ├── app1.hpp
│   │   └── main.cpp
│   ├── app2/
│   │   ├── app2.cpp
│   │   ├── app2.hpp
│   │   └── main.cpp
└── modules/
    └── module1/
        ├── module1.cpp
        └── module1.hpp
```

### app
appごとに実行ファイルが生成され、実行ファイルの名前はそのディレクトリ名になります。各appのディレクトリ内のソースファイル及びヘッダファイルは、そのapp内だけで紐付けられます。ソースファイルはディレクトリ内で再帰的に探索されるため、app内でフォルダを作成して管理することも可能です。

### module
moduleは、それ単体では実行ファイルを生成されません。moduleのソースファイルとヘッダファイルは、プロジェクト内のすべてのappと紐付けられます。modulesディレクトリ内のソースファイルは再帰的に探索されます。

## 使い方
以下はUbuntuを想定したコマンドで説明します。

まずリポジトリをクローンします。
```bash
cd ~/
git clone https://github.com/Doraemonjayo/EasyCMake.git
cd ./EasyCMake
```
ビルドします。
```bash
cd build
cmake ..
make
cd ..
```
### 実行例
```bash
./build/app1
```
出力例
```
Hello! from module1.
Hello! from app1.
```

## ライセンス
このプロジェクトは[MITライセンス](LICENSE)の下でライセンスされています。