//
//  BlogPostModel.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import Vapor
import Fluent
import ViperKit

final class BlogPostModel: ViperModel {
    typealias Module = BlogModule
    
    static let name = "posts"

    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var imageKey: FieldKey { "image_key" }
        static var excerpt: FieldKey { "excerpt" }
        static var content: FieldKey { "content" }
        static var categoryId: FieldKey { "category_id" }
        static var authorId: FieldKey { "author_id" }
    }
    
    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.title) var title: String
    @Field(key: FieldKeys.imageKey) var imageKey: String
    @Field(key: FieldKeys.excerpt) var excerpt: String
    @Field(key: FieldKeys.content) var content: String
    @Parent(key: FieldKeys.categoryId) var category: BlogCategoryModel
    @Parent(key: FieldKeys.authorId) var author: BlogAuthorModel

    init() { }
    
    init(id: UUID? = nil,
         title: String,
         imageKey: String,
         excerpt: String,
         content: String,
         categoryId: UUID,
         authorId: UUID)
    {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.content = content
        self.$category.id = categoryId
        self.$author.id = authorId
    }
}
