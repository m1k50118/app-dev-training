//
//  ErrorWrapper.swift
//  Scrumdinger
//
//  Created by 佐藤真 on 2023/01/08.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error
    let guidance: String

    init(id: UUID = UUID(), error: Error, guidance: String) {
        self.id = id
        self.error = error
        self.guidance = guidance
    }
}
