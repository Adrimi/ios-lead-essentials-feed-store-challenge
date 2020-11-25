//
//  RealmFeedStore.swift
//  FeedStoreChallenge
//
//  Created by adrian.szymanowski on 25/11/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmFeedStore: FeedStore {
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        let realm = try! Realm()
        try! realm.write {
            realm.add({
                let realmFeedObject = RealmFeedObject()
                feed
                    .map { localFeedImage in
                        let realmFeedImage = RealmFeedImage()
                        realmFeedImage.id = localFeedImage.id.uuidString
                        realmFeedImage.imageDescription = localFeedImage.description
                        realmFeedImage.location = localFeedImage.location
                        realmFeedImage.urlString = localFeedImage.url.absoluteString
                        return realmFeedImage
                    }
                    .forEach(realmFeedObject.feedImages.append)
                realmFeedObject.timestamp = timestamp
                return realmFeedObject
            }())
            completion(nil)
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let realm = try! Realm()
        if let localFeedObject = realm
            .objects(RealmFeedObject.self)
            .first {
            completion(.found(feed: localFeedObject.localFeed, timestamp: localFeedObject.timestamp))
        } else {
            completion(.empty)
        }
    }
    
    public init() {}
}

class RealmFeedObject: Object {
    var feedImages: List<RealmFeedImage> = .init()
    @objc dynamic var timestamp: Date = Date()
    
    var localFeed: [LocalFeedImage] {
        feedImages.map {
            LocalFeedImage(
                id: UUID(uuidString: $0.id)!,
                description: $0.imageDescription,
                location: $0.location,
                url: URL(string: $0.urlString!)!)
        }
    }
}

class RealmFeedImage: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var imageDescription: String? = nil
    @objc dynamic var location: String? = nil
    @objc dynamic var urlString: String? = nil
}
