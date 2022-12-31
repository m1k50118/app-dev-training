//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by 佐藤真 on 2022/12/31.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: DailyScrum.sampleData)
        }
    }
}
