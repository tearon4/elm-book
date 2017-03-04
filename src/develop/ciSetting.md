ElmのCIの設定。

elm-community/elm-testのページにもサンプルがありますが、CIでテストを実行してみます。その時のTravis CIとCircleCIでの設定についてです。

まずプロジェクトにelm-community/elm-testの補助ツールをインストールします。

```
npm install elm-test --save-dev
```
または

```
yarn add elm-test --dev
```

そして、package.jsonのnpm scriptの項目で呼び出す設定にしておきます。

```js
...
"scripts": {
  ...
  "test": "elm-test"
},
...

"devDependencies": {
  "elm": "^0.18.0",
  "elm-test": "^0.18.2"
},

```

次に、設定ファイルをプロジェクトのルートディレクトリに設置します。そして、サイトの設定から、プロジェクトのレポジトリを指定します。レポジトリにプッシュがあると自動で起動するようになります。

以下は、Travis CIとCircleCIの設定ファイルの例です。

###Travis CI

Travis CIでの設定は以下のようになります。

```yml
sudo: false

dist: trusty

language: node_js

node_js:
  - "6"

cache:
  yarn: true
  directories:
    - tests/elm-stuff/build-artifacts

script:
  - yarn run test
```

（メモ：elm-testのサンプルコードの方では、Elmのinstallが失敗したらリトライするスクリプトを利用しています。少し試した感じ失敗しなかったのでその部分はここでは外しています。）

cacheの設定で`tests/elm-stuff/build-artifacts`を設定すると速くなります。

###CircleCI

CircleCIでの設定は以下のようになります。

```yml
machine:
  environment:
    PATH: "${PATH}:${HOME}/${CIRCLE_PROJECT_REPONAME}/node_modules/.bin"

  node:
    version: 7.2.1

dependencies:
  override:
    - yarn
    - elm-package install -y

  post:
    # Workaround to Elm CI test suite timeout: https://github.com/elm-lang/elm-compiler/issues/1473.
    - if [ ! -d libsysconfcpus ]; then git clone https://github.com/obmarg/libsysconfcpus.git; fi
    - cd libsysconfcpus && ./configure && make && sudo make install

  cache_directories:
    - libsysconfcpus
    - ~/.cache/yarn
    - tests/elm-stuff/build-artifacts
    - elm-stuff/build-artifacts

test:
  override:
    - sysconfcpus --num 1 yarn test

# deployment:
#   production:
#     branch: master
#     commands:
#       -sysconfcpus --num 1 yarn run build

```

libsysconfcpusというのをインストールして、それを通してElmをコンパイルするコマンドを実行しています。
これはCI上でElmをコンパイルすると、何も言わず止まってしまう現象がCircleCIだと出るためです。参考：[Circle CI Elm Tests Fix](https://gist.github.com/bkuhlmann/765abad66f918dac14eb49ea5f48b014)
Elmのバージョンが上がると必要なくなると思います。

cache_directoriesの設定で`tests/elm-stuff/build-artifacts`を指定していますが、CircleCIにはそのようなフォルダは無いよと言われます。
まだ良くわからないので、わかったら書き直します。


Travis CIとCircleCIどちらもyarnに対応しています。yarnを使っています。
