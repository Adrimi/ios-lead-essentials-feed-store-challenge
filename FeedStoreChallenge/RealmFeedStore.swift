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
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
                completion(.none)
            }
        } catch {
            completion(error)
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
                realm.add(
                    RealmFeedStoreMapper.createRealmFeedObject(
                        feed: feed,
                        timestamp: timestamp))
                completion(.none)
            }
        } catch {
            completion(error)
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        do {
            let realm = try Realm()
            if let localFeedObject = realm
                .objects(RealmFeedObject.self)
                .first {
                completion(.found(feed: localFeedObject.localFeed, timestamp: localFeedObject.timestamp))
            } else {
                completion(.empty)
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    public init() {}
}
