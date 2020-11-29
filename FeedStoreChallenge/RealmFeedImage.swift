//
//  RealmFeedImage.swift
//  FeedStoreChallenge
//
//  Created by adrian.szymanowski on 29/11/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

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
