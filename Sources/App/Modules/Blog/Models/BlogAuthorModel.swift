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

extension BlogAuthorModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        var id: String
        var name: String
        var imageKey: String
        var bio: String

        init(model: BlogAuthorModel) {
            self.id = model.id!.uuidString
            self.name = model.name
            self.imageKey = model.imageKey
            self.bio = model.bio
        }
    }
    
    var viewContext: ViewContext { .init(model: self) }
}

extension BlogAuthorModel: FormFieldOptionRepresentable {

    var formFieldOption: FormFieldOption {
        .init(key: self.viewIdentifier, label: self.name)
    }
}
