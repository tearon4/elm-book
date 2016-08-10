#effect manager

EffectManagerとは、Cmd/Subの裏側です。例えばwebsocketモジュールはユーザーに、websocketを発信するCmdと受信するSubのみ公開していますが、裏側では、通信が切れた時の復旧や、積まれたスタックの消費を管理しています。

EffectManagerは多分、主にTaskの管理に使います。Taskは実行すると、process idを返すので。

Mouseモジュールなら、立ち上がったTaskの数を管理したり、しています。

しかし処理の流れがよくわからん

onEffectsはcmdがあったらうごくのかな。初期起動もしそうだな。

Platform.sendToSelfでonSelfMsgに飛ぶっぽいけど、なぜ必要なんだろ。このときeffectmanegerで状態を更新できる？

Platform.sendToAppで状態を変えつつsubへ飛ぶのかな。htmlのイベントみたいなものと書いてあるな。


router は appmsg　slfmsg を持っている
