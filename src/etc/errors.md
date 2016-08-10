#よく見るエラー

作業中よく遭遇するエラーを並べておきます。

##コンパイルエラー

コンパイル時のエラーです。エラーの種類、どのファイルで起こったのか（右上に書かれてあります）、行番号、エラーの箇所、が表示されます。

####SYNTAX PROBLEM

構文エラーです。構文エラーは「これはElmというプログラミング言語表記になっていないよ」というエラーです。
この文字がないのでは等のヒントも表示されます。

例：
```
-- SYNTAX PROBLEM -------------------------------------------- repl-temp-000.elm


I ran into something unexpected when parsing your code!

6|   List.map (+ 2) [1..5]
               ^
I am looking for one of the following things:

    a closing paren ')'
    a comma ','
    an expression
    whitespace
```

####
