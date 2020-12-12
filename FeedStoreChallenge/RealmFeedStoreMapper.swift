//
//  RealmFeedStoreMapper.swift
//  FeedStoreChallenge
//
//  Created by adrian.szymanowski on 29/11/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

class RealmFeedStoreMapper {
    static func createRealmFeedObject(feed: [LocalFeedImage], timestamp: Date) -> Object {
        let realmFeedObject = RealmFeedObject()
        feed.map(RealmFeedStoreMapper.mapToLocal)
            .forEach(realmFeedObject.feedImages.append)
        realmFeedObject.timestamp = timestamp
        return realmFeedObject
    }
    
    private static func mapToLocal(_ localFeedImage: LocalFeedImage) -> RealmFeedImage {
        RealmFeedImage(
            id: localFeedImage.id,
            imageDescription: localFeedImage.description,
            location: localFeedImage.location,
            urlString: localFeedImage.url)
    }
}
