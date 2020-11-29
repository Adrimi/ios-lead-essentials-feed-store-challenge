//
//  RealmFeedObject.swift
//  FeedStoreChallenge
//
//  Created by adrian.szymanowski on 29/11/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

class RealmFeedObject: Object {
    var feedImages: List<RealmFeedImage> = .init()
    @objc dynamic var timestamp: Date = Date()
}

extension RealmFeedObject {
    var localFeed: [LocalFeedImage] {
        feedImages.compactMap(\.localFeed)
    }
}
