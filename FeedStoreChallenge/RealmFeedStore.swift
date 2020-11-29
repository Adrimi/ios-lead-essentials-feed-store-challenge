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
            realm.deleteAll()
            realm.add(
                RealmFeedStoreMapper.createRealmFeedObject(
                    feed: feed,
                    timestamp: timestamp))
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
