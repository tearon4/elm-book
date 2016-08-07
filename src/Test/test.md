#Test

Testを行うことで、ソースコードが仕様を満たしているかどうか、正しく動いているかどうか、思い違いがないか、検査することが出来ます。

Elm PackageでTestライブラリを検索すると、便利系のライブラリが乱立しているのですが、ここでは基本的なライブラリを見ていきます。


#Elm-test

Elm-testはユニットテストができるライブラリです。

```
elm-package install elm-community/elm-test
```

#BDD style

```
rogeriochaves/elm-test-bdd-style
```

#Elm-check

Elm-checkは、プロパティベーステストが出来るライブラリです。
ユニットテストでは、基本的に正しい場合や値を列挙する必要がありました、しかしそれでは、記述漏れが発生しますし、テストの質を高めるためには幾つものテストを書く必要があります。プロパティベーステストは、テスト対象の性質をかけば、その性質にそってテストが値を変え、自動でテストを生成して大量に行ってくれるという方法です。

```
elm package install elm-community/elm-check
```



```
```
