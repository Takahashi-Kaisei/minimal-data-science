
### cache busting
source: [Dockerfile を書くベストプラクティス](https://docs.docker.jp/develop/develop-images/dockerfile_best-practices.html#:~:text=apt%2Dget,-%E6%81%90%E3%82%89%E3%81%8F)
apt-getでの以下のような書き方をよく見かける。
```
RUN apt-get update && apt-get install -y
```

これを分解すると以下のようになる。
```
FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y curl
```

この時、apt-get updateはキャッシュされるため、この後Dockerfileを更新し、他のツールをinstallするように変更しても、apt-get updateはキャッシュされるため、updateは実行されず、apt-get install -y curlの部分だけが更新されることになる。
このため、apt-get updateは常に最新の状態で実行されるようにするために、&&で繋げるのがベストプラクティスである。

また、以下のコマンドを最後に追加することで、イメージのサイズを小さくすることができる。
```
&& rm -rf /var/lib/apt/lists/*
```

- マルチステージビルド
    - ビルド環境と、実行環境を切り分ける
- キャッシュを使うために、変更の少ない場所を先に書く。
- ルートレス



やりたいことは、リモート開発とローカル開発をシームレスに行えるようにすること。
また、環境構築にはuvを使いたいので、それをベースとしたいのだが、問題なのはuvのdocker imageをベースとして問題ないかということろ。
今までtorchのcuda対応のイメージをベースにして、uvのバイナリをコピーするという運用をしていたが、これではローカルではcudaには対応していないため避けたい。
しかし、uvのイメージをベースとした時、torchとcudaの両方が問題なく動作するかが不安。
また、uvがちゃんと機能するのか、pyproject.tomlがちゃんと機能するのかが心配である。

https://zenn.dev/turing_motors/articles/ab155fe6653660 を使って、相性の良いtorchを後からinstallするのが良さそう。


結局、pyproject.tomlでリモートとローカルの切り分けをするのであれば、docker周りはリモートだけに依存して良い。
したがってbase imageは nvidia/cuda:13.2.0-cudnn-devel-ubuntu24.04
を使用する。
後方互換性を信じてcudaのversionを選ぶ、develはなんかいっぱい入ってるから便利そう。
https://hub.docker.com/r/nvidia/cuda
