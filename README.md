# Appleのチュートリアルを実施するリポジトリ
https://developer.apple.com/tutorials/app-dev-training
## SwiftUI essentials
### Using stacks to arrange views
学んだこと
- プロジェクトの作成
- 基本的なViewの作り方
- アクセスシビティーの対応(Voice Over)
    - .accessibilityElement(children: .ignore)
    - .accessibilityLabel()
    - .accessibilityValue()
 

## Views
### Creating a card view
学んだこと
- ラベルスタイルのカスタマイズ方法（文字列とイメージの配置をカスタマイズするイメージ）
    - LabelStyle protocol
        - makeBody必須
        - configuration.title→タイトル
        - configuration.icon→アイコン
        - HStackやVStackを使っていい感じにラベルのスタイルをカスタマイズできる
    - leading-dot syntaxでラベルのスタイルを適用する便利な呼び出し方
    ```swift
    extension LabelStyle where Self == TrailingIconLabelStyle {
        static var trailingIcon: Self { Self() }
    }
    // 呼び出し方
    Label("\(scrum.lengthInMinutes)", systemImage: "clock")
                    .labelStyle(.trailingIcon)
    ```
