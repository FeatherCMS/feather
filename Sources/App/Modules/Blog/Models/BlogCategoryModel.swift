//
//  BlogCategoryModel.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import Vapor
import Fluent
import ViperKit
import ViewKit

final class BlogCategoryModel: ViperModel {
    typealias Module = BlogModule

    static let name = "categories"
    
    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var imageKey: FieldKey { "image_key" }
        static var excerpt: FieldKey { "excerpt" }
        static var priority: FieldKey { "priority" }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.title) var title: String
    @Field(key: FieldKeys.imageKey) var imageKey: String
    @Field(key: FieldKeys.excerpt) var excerpt: String
    @Field(key: FieldKeys.priority) var priority: Int
    @Children(for: \.$category) var posts: [BlogPostModel]
    
    init() { }
    
    init(id: UUID? = nil,
         title: String,
         imageKey: String,
         excerpt: String,
         priority: Int = 100)
    {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.priority = priority
    }
}

// MARK: - viewModel

extension BlogCategoryModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        var id: String
        var title: String
        var imageKey: String
        var excerpt: String
        var priority: Int

        init(model: BlogCategoryModel) {
            self.id = model.id!.uuidString
            self.title = model.title
            self.imageKey = model.imageKey
            self.excerpt = model.excerpt
            self.priority = model.priority
        }
    }
    
    var viewContext: ViewContext { .init(model: self) }
}

extension BlogCategoryModel: FormFieldOptionRepresentable {

    var formFieldOption: FormFieldOption {
        .init(key: self.viewIdentifier, label: self.title)
    }
}
