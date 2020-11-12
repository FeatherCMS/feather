//
//  BlogAuthorModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import FeatherCore

final class BlogAuthorModel: ViperModel {

    typealias Module = BlogModule
    
    static let name = "authors"
    
    struct FieldKeys {
        static var name: FieldKey { "name" }
        static var imageKey: FieldKey { "imageKey" }
        static var bio: FieldKey { "bio" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.imageKey) var imageKey: String
    @Field(key: FieldKeys.bio) var bio: String
    @Children(for: \.$author) var links: [BlogAuthorLinkModel]
    @Children(for: \.$author) var posts: [BlogPostModel]
    
    init() { }
    
    init(id: UUID? = nil,
         name: String,
         imageKey: String,
         bio: String)
    {
        self.id = id
        self.name = name
        self.imageKey = imageKey
        self.bio = bio
    }
}
