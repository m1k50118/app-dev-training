//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by 佐藤真 on 2022/12/31.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ScrumsView(scrums: $scrums)
            }
        }
    }
}
