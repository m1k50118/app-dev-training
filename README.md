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
### Displaying data in a list
学んだこと
- Listの使い方
    - listRowBackground()でセルの色を変えられる
- forEachの使い方

## Navigation and modal presentation
### Creating a navigation hierarchy
学んだこと
- 画面遷移の方法と値の受け渡し方
    - チュートリアルの中では`NavigationView`を使っているが、近々deprecatedになるので、代わりに`NavigationStack`を使う
    - NavigationLink(destination: 遷移先のView)
    - .toolbar {}
        - ナビゲーションバーのアイテム
    - .navigationTitle()はNavigationLinkにつけず、外側のViewにつける
- List内でSectionに分ける方法
    - チュートリアルではSection(header: , content:)になっているけど、Renameされて下記の書き方に変更されている
    ```swift
    List {
        Section {
            contentView
        } header: {
            headerView
        }
    }
    ```
- 先頭の文字を大文字にする方法
    - String.capitalized

頭いいなと思ったコード
- 元々DailyScrumのattendeesは`[String]`だった
- プロパティを`[Attendee]`にしたので、イニシャライザの引数も`[Attendee]`にすると思いきや
- `[String]`のままにして、mapで`[Attendee]`を返却するようにしている
- インスタンスを作成する時の引数を修正する必要がないので、こっちの方が楽
```swift
import Foundation

struct DailyScrum: Identifiable {
    let id: UUID
    var title: String
    var attendees: [Attendee] // 元々[String]
    var lengthInMinutes: Int
    var theme: Theme
    
    // attendees: [String]は変えない
    init(id: UUID = UUID(), title: String, attendees: [String], lengthInMinutes: Int, theme: Theme) {
        self.id = id
        self.title = title
        self.attendees = attendees.map { Attendee(name: $0) } // mapで[Attendee]を返却（かしこい）
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
    }
}

extension DailyScrum {
    struct Attendee: Identifiable {
        let id: UUID
        var name: String
        
        init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
        }
    }
}

extension DailyScrum {
    static let sampleData: [DailyScrum] =
    [
        // ここで宣言していたattendeesを修正する必要がないので、とっても楽
        DailyScrum(title: "Design", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], lengthInMinutes: 10, theme: .yellow),
        DailyScrum(title: "App Dev", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 5, theme: .orange),
        DailyScrum(title: "Web Dev", attendees: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"], lengthInMinutes: 5, theme: .poppy)
    ]
}
```
### Creating the edit view
学んだこと
- @Stateの使い方
    - ViewにBindして欲しいプロパティを使う時に宣言する
    - 変数を変更することでViewに変更が反映される
- Formの存在
    - Listと同じようにスクロール可能なリストが表示される
    - データ入力に使用するViewをグループ化するのに使われる
- Sliderの使い方
    - Slider(value: 値, in: 範囲, step: 増減の幅)

よく分からなかったこと
- Form
    - The Form container automatically adapts the appearance of controls when it renders on different platforms.
    - Form コンテナは、異なるプラットフォームでレンダリングする際に、コントロールの外観を自動的に調整します。

### Passing data with bindings
学んだこと
- RoundedRectangle()の使い方
    - 角丸四角形
- fixedSize(horizontal: Bool, vertical: Bool)
    - サイズをフィットさせる
- @Bindingの使い方
    - 親のViewのプロパティを子のViewで変更する時に使う
    - Previewに@Bindingの値を代入するときは、.constant()を使う
- Pickerの存在
    - ボタンで、タップしたらリストが表示されるやつ