# EasyCMake
このリポジトリはCMakeプロジェクトのテンプレート形式になっています。このプロジェクトではCMakeLists.txtがディレクトリ内のソースファイルを自動で探索するため、プロジェクトに合わせてCMakeLists.txtを書き直す必要がありません。

## 機能
- ソースファイルの自動探索
- 一つのプロジェクトで複数の実行ファイルを生成
- プロジェクト内のすべての実行ファイルで共有されるインクルードパス及びソースファイルの管理
- 各実行ファイルのみで有効なインクルードパス及びソースファイルの管理
- 各実行ファイルのみ、またはすべての実行ファイルと外部ライブラリ(Python, OpenCV, boost等)の紐付け

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
│   │   ├── main.cpp
│   │   └──pkglinker.cmake
└── modules/
    └── module1/
        ├── module1.cpp
        └── module1.hpp
```

### app
appごとに実行ファイルが生成され、実行ファイルの名前はそのディレクトリ名になります。各appのディレクトリ内のソースファイル及びヘッダファイルは、そのapp内だけで紐付けられます。ソースファイルはディレクトリ内で再帰的に探索されるため、app内でフォルダを作成して管理することも可能です。

### module
moduleは、それ単体では実行ファイルを生成されません。moduleのソースファイルとヘッダファイルは、プロジェクト内のすべてのappと紐付けられます。modulesディレクトリ内のソースファイルは再帰的に探索されます。

## 外部ライブラリの紐付け
moduleまたはappのディレクトリで`pkglinker.cmake`というファイルを書くことで設定します。

### 例 : `apps/app2/pkglinker.cmake`
```cmake
link_package(
    Python3
    COMPONENTS Interpreter Development
    DIRECTORIES "\${Python3_INCLUDE_DIRS}"
    LIBRARIES "\${Python3_LIBRARIES}"
)
```
この例ではapp2にPython3を紐付けしています。これは以下のようなスクリプトを意味し、自動的に実行されます。
```cmake
find_package(Python3 REQUIRED COMPONENTS Interpreter Development)
target_include_directories(app2 PRIVATE ${Python3_INCLUDE_DIRS})
target_link_libraries(app2 PRIVATE ${Python3_LIBRARIES})
```
`COMPONENTS` `DIRECTORIES` `LIBRARIES`については、必要のないものは省略することができます。
### 注意 !
`Python3_INCLUDE_DIRS`や`Python3_LIBRARIES`等は`find_package(Python3　...)`を実行する以前には存在しない変数です。

関数の引数は実行時に展開されてしまうため、例のようにバックスラッシュをドル記号の前に書き、`DIRECTORIES "\${Python3_INCLUDE_DIRS}"` `LIBRARIES "\${Python3_LIBRARIES}"`と記述することで変数が展開されることを防いでください。

`Python3_INCLUDE_DIRS`や`Python3_LIBRARIES`の内容がわかっている場合は、その内容を直接記述することが可能です。

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

### 実行例1
```bash
./build/app1
```
出力
```
Hello! from app1.
Hello! from module1.
```

### 実行例2
```bash
./build/app2
```
出力
```
Hello! from app2.
Hello! from module1.
Hello! from Python.
```

## ライセンス
このプロジェクトは[MITライセンス](LICENSE)の下でライセンスされています。