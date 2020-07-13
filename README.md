# カオリアル

顔がリアルな 3D アバターにメッセージを載せて共有する web アプリです。

アバターに対して投稿されたコメントも 3D 空間上に表示されます。

転職用のポートフォリオとして作成しました。

## リンク

https://www.kaoreal.com/

<img  alt="1" src="https://user-images.githubusercontent.com/53265885/87270224-7d415580-c50a-11ea-9027-0c81a19d48ca.png">

## 特に見ていただきたい部分

- 開発/本番環境で Docker を使用している点

  （開発環境：Docker-compose、本番環境：ECR/ECS）

- AWS を使い ALB を通すことで常時 SSL 通信を行っている点
- CircleCI を用い CI/CD パイプラインを構築している点
- 外部 API（LINE Messaging API, Amazon Rekognition）を使いこなしている点
- Vue.js Vuex を使いこなし、こだわりを持って UI を作っている点

  ( 無限スクロール、画像トリミング、画像アップロード、いいね、コメント、公開制限、
  　削除、メッセージ、タブ )

- テスト（RSpec、jest）で モック、スタブ、vcr を使いこなしている点
- Aframe を使用して 3D コンテンツを表示している点
- 顔画像から顔がリアルな 3D アバターを生成するユニークなサービスを生み出した点
- アバター生成ロジックを構築した点（以下に詳細掲載）

## アバター生成ロジック

モデルとなる 3D アバターの顔部分テクスチャーマッピングを投稿画像によるものに入れ替えて生成します。
テクスチャー入れ替え時に、モデルの目鼻座標に投稿画像の目鼻座標を正確に合わせることで、きれいなカオリアルアバターが生成されます。以下に 3D アバター生成フローを記載します。ベクトル、行列計算を用いています。

1. 画像投稿
2. 外部サービス（Amazon Rekognition）による顔検出、目鼻座標検出
3. 両目の距離がモデルと等しくなるよう画像のスケーリングレート算出
4. 画像の顔を水平にするための画像回転角度を両目の座標から算出
5. 鼻座標がモデルと等しくなるように画像移動量算出
6. 上記算出結果を元に画像トリミング
7. 用意してある 3D アセットへ上記画像を組み込み、AWS S3 に保存
8. Aframe による 3D アバター(.gltf)表示

## 使用技術

**_開発環境_**

- docker
  - docker-compose

**_サーバーサイド_**

- nginx:1.19
- puma:4.3.5
- mysql:8.0
- Ruby:2.7.1
- Rails:6.0.3
- gem:
  - activestorage
  - kaminari
  - devise
  - rubocop
  - mini_magick
  - rspec-rails
  - rspec-retry
  - shoulda-matchers
  - vcr
  - webmock

**_外部 API_**

- Amazon Rekognition
- LINE Messaging API

**_インフラ_**

- AWS

  - ECS/ECR
  - EC2
  - ALB
  - RDS for MySQL
  - S3
  - CloudFront
  - Route53
  - Certificate Manager
  - VPC
  - CloudWatch
  - IAM

- CircleCI/CD

**_フロントエンド:_**

- Vue:2.6.11
- jQuery:3.4.1

- javaScript パッケージ:

  - vuex
  - axios
  - vue-croppa
  - vue-infinite-loading
  - vue-turbolinks
  - fortawesome/fontawesome-free-webfonts
  - jest
  - vue-jest
  - aframe-japanese-font
  - bootstrap
  - jquery-validation
  - moment

## クラウドアーキテクチャ

![image](https://user-images.githubusercontent.com/53265885/86527330-f1f80c80-bed8-11ea-9cbb-ea4a5c576d93.png)

## 機能一覧

- ユーザー登録
- ログイン機能
- クライアントサイドでのバリデーション
- 画像アップロード → アバタ作成
- アバター削除
- いいね
- コメント
- フォロー
- 公開制限
- メッセージボード
- ユーザーアイコン画像トリミング
- 無限スクロール（アバター一覧、コメント一覧、いいね一覧）
- タブ切り替え
- LINE ボットに画像投稿 → アバター作成

## 画面一覧

<img  alt="1" src="https://user-images.githubusercontent.com/53265885/87270224-7d415580-c50a-11ea-9027-0c81a19d48ca.png">
<img  alt="2" src="https://user-images.githubusercontent.com/53265885/87270231-80d4dc80-c50a-11ea-9d80-2ee4a14544ca.png">
<img  alt="3" src="https://user-images.githubusercontent.com/53265885/87271049-05c0f580-c50d-11ea-8b06-60e8ef2a9b05.png">
<img  alt="4" src="https://user-images.githubusercontent.com/53265885/87270233-82060980-c50a-11ea-9348-5b479d97179a.png">
<img  alt="5" src="https://user-images.githubusercontent.com/53265885/87271053-0a85a980-c50d-11ea-9aec-7f2488fbe7f5.png">
<img  alt="10" src="https://user-images.githubusercontent.com/53265885/87271063-12dde480-c50d-11ea-916a-4e6bb3fe2237.png">
<img  alt="6" src="https://user-images.githubusercontent.com/53265885/87270236-83373680-c50a-11ea-80e0-7192284a57a2.png">
<img  alt="7" src="https://user-images.githubusercontent.com/53265885/87270238-83cfcd00-c50a-11ea-8c9a-b97f14464744.png">
<img  alt="8" src="https://user-images.githubusercontent.com/53265885/87270239-84686380-c50a-11ea-953a-c72a4e2a09f0.png">
<img  alt="11" src="https://user-images.githubusercontent.com/53265885/87271524-6e5ca200-c50e-11ea-94f2-4e567c0be957.png">
<img  alt="12" src="https://user-images.githubusercontent.com/53265885/87271526-71f02900-c50e-11ea-8756-64df39a229e6.png">

<img  alt="9" src="https://user-images.githubusercontent.com/53265885/87271057-0fe2f400-c50d-11ea-90bf-a19e5a48581e.png">

<img src="https://user-images.githubusercontent.com/53265885/87270330-cc878600-c50a-11ea-8db3-dd0dd82fe74b.gif" height="390px">
<img src="https://user-images.githubusercontent.com/53265885/87270439-14a6a880-c50b-11ea-9df3-7e5862717985.gif" height="390px">
<img src="https://user-images.githubusercontent.com/53265885/87270444-17090280-c50b-11ea-8f85-6b3ccdaa85a6.gif" height="390px">

LINE BOT からもアバターを作成できます。
<br >
<img src="https://user-images.githubusercontent.com/53265885/87167032-5bc44c00-c307-11ea-914c-59cd5cee31e4.gif" height="390px">
