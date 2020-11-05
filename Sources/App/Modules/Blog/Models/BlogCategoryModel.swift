//
//  BlogCategoryModel.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import FeatherCore

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

extension BlogCategoryModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id!.uuidString,
            "title": title,
            "imageKey": imageKey,
            "excerpt": excerpt,
            "priority": priority,
        ])
    }
}

extension BlogCategoryModel: FormFieldStringOptionRepresentable {

    var formFieldStringOption: FormFieldStringOption {
        .init(key: id!.uuidString, label: title)
    }
}
