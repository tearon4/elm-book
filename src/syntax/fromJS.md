
#オブジェクト指向言語から見ての違いとか。

オブジェクト指向型と分類される言語から見ての違いとか。

##クラスと型

型とクラスについて

Elm

```
type alias User = {id : Int , hp : Int}
```

```
class User {
  var id ,
  var hp
}
```

Union型は、オブジェクト指向型言語として説明すると固定された木構造のクラス、と言えます。

```
type Bool = True | False

```


```

class Bool {
}

class False extend Bool {

}

class True extend Bool {

}

```

この時、Boolというクラスを継承しているクラスは、FalseとTrueのみと固定されています。

ユニオン型はcase式でパターンマッチが行えます。

```
type Bool = True | False

hoge : Bool -> String   -- Bool型を取る
hoge isNantoka =
      case isNantoka of
          True ->
          False ->
              -- これ以上のパターンは無いので考える必要がない

```

木構造やフラグをUnion型で表現します。

直積型とUnion型ですべてのクラスを表現できます。


##表記の違い

* forループ等のループ構文がない。

ループを書きたい場合は、再帰関数で書きます。末尾再帰にすると最適化されます。

List型やArray型に集計や走査、変換を行いたい場合は、foldl、filter、map、といった関数を使うことを検討します。


* try...catch文が無い

エラー処理のページヘ
