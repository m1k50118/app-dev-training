//
//  ScrumTimer.swift
//  Scrumdinger
//
//  Created by 佐藤真 on 2023/01/04.
//

import Foundation

/// デイリースクラムの時間を管理する。会議の総時間、各発言者の時間、現在の発言者の名前を記録する
class ScrumTimer: ObservableObject {
    /// 会議中に会議の出席者を記録するための構造体
    struct Speaker: Identifiable {
        /// 出席者の名前
        let name: String
        /// 出席者が発言の順番を終えた場合、trueを返します
        var isCompleted: Bool
        /// Identifiableに準拠するためのId
        let id = UUID()
    }

    /// 発言する会議出席者の名前
    @Published var activeSpeaker = ""
    /// 会議の開始からの秒数
    @Published var secondsElapsed = 0
    /// すべての出席者に発言の順番が回ってくるまでの秒数
    @Published var secondsRemaining = 0
    /// 発言する順番に並べられた会議の出席者
    private(set) var speakers: [Speaker] = []

    /// スクラム会議の長さ
    private(set) var lengthInMinutes: Int
    /// 新しい出席者が話し始めた時に実行されるクロージャ
    var speakerChangedAction: (() -> Void)?
    
    private var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var lengthInSeconds: Int { lengthInMinutes * 60 }
    private var secondsPerSpeaker: Int {
        (lengthInMinutes * 60) / speakers.count
    }
    private var secondsElapsedForSpeaker: Int = 0
    private var speakerIndex: Int = 0
    private var speakerText: String {
        return "Speaker \(speakerIndex + 1):" + speakers[speakerIndex].name
    }
    private var startDate: Date?

    /**
     新しいタイマーを初期化する。 引数なしで時間を初期化すると、参加者も長さもゼロの ScrumTimer が作成される。
     タイマーをスタートさせるときは`startScrum()` を使う。

     - Parameters:
     - lengthInMinutes: 会議の長さ
     -  attendees: 会議の参加者のリスト
     */
    init(lengthInMinutes: Int = 0, attendees: [DailyScrum.Attendee] = []) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }

    /// タイマーをスタートする。
    func startScrum() {
        changeToSpeaker(at: 0)
    }

    /// タイマーを止める。
    func stopScrum() {
        timer?.invalidate()
        timer = nil
        timerStopped = true
    }

    /// 次の発表者にタイマーを進める
    func skipSpeaker() {
        changeToSpeaker(at: speakerIndex + 1)
    }

    private func changeToSpeaker(at index: Int) {
        if index > 0 {
            let previousSpeakerIndex = index - 1
            speakers[previousSpeakerIndex].isCompleted = true
        }
        secondsElapsedForSpeaker = 0
        guard index < speakers.count else { return }
        speakerIndex = index
        activeSpeaker = speakerText
        
        secondsElapsed = index * secondsPerSpeaker
        secondsRemaining = lengthInSeconds - secondsElapsed
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true, block: { [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(secondsElapsed: Int(secondsElapsed))
            }
        })
    }
    
    private func update(secondsElapsed: Int) {
        secondsElapsedForSpeaker = secondsElapsed
        self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
        guard secondsElapsed <= secondsPerSpeaker else {
            return
        }
        secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)
        guard !timerStopped else { return }
        
        if secondsElapsedForSpeaker >= secondsPerSpeaker {
            changeToSpeaker(at: speakerIndex + 1)
            speakerChangedAction?()
        }
    }

    /**
     新しい会議の長さと新しい参加者でタイマーをリセットする。

     - Parameters:
     - lengthInMinutes: 会議の長さ
     - attendees: 各出席者の名前
     */
    func reset(lengthInMinutes: Int, attendees: [DailyScrum.Attendee]) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
}

extension DailyScrum {
    /// `DailyScrum` に含まれる会議の長さと参加者を用いて、新しい `ScrumTimer` を作成する。
    var timer: ScrumTimer {
        ScrumTimer(lengthInMinutes: lengthInMinutes, attendees: attendees)
    }
}

extension Array where Element == DailyScrum.Attendee {
    var speakers: [ScrumTimer.Speaker] {
        if isEmpty {
            return [ScrumTimer.Speaker(name: "Speaker 1", isCompleted: false)]
        } else {
            return map { ScrumTimer.Speaker(name: $0.name, isCompleted: false) }
        }
    }
}
