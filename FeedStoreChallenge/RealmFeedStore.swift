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
            id: localFeedImage.id.uuidString,
            imageDescription: localFeedImage.description,
            location: localFeedImage.location,
            urlString: localFeedImage.url.absoluteString)
    }
}

// MARK: - Realm Feed Object
class RealmFeedObject: Object {
    var feedImages: List<RealmFeedImage> = .init()
    @objc dynamic var timestamp: Date = Date()
}

extension RealmFeedObject {
    var localFeed: [LocalFeedImage] {
        feedImages.compactMap(\.localFeed)
    }
}

// MARK: - Realm Feed Image
class RealmFeedImage: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var imageDescription: String? = nil
    @objc dynamic var location: String? = nil
    @objc dynamic var urlString: String = ""
    
    override init() {}
    
    init(id: String, imageDescription: String?, location: String?, urlString: String) {
        self.id = id
        self.imageDescription = imageDescription
        self.location = location
        self.urlString = urlString
    }
}

extension RealmFeedImage {
    var localFeed: LocalFeedImage? {
        guard let id = UUID(uuidString: id),
              let url = URL(string: urlString) else {
            return nil
        }
        return LocalFeedImage(
            id: id,
            description: imageDescription,
            location: location,
            url: url)
    }
}
