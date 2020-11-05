//
//  BlogAuthorModel.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import Vapor
import Fluent
import ViperKit
import ViewKit
import Leaf

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
    @Children(for: \.$author) var Posts: [BlogPostModel]
    
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

// MARK: - viewModel

extension BlogAuthorModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id!.uuidString,
            "name": name,
            "imageKey": imageKey,
            "bio": bio,
        ])
    }
}

extension BlogAuthorModel: FormFieldStringOptionRepresentable {

    var formFieldStringOption: FormFieldStringOption {
        .init(key: id!.uuidString, label: name)
    }
}
