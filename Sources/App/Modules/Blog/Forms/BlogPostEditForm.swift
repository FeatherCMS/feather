//
//  BlogPostEditForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 02. 15..
//

import Vapor
import ViewKit

final class BlogPostEditForm: Form {

    typealias Model = BlogPostModel

    struct Input: Decodable {
        var id: String
        var title: String
        var excerpt: String
        var content: String
        var categoryId: String
        var authorId: String

        var image: File?
        var imageDelete: Bool?
    }

    var id: String? = nil
    var title = BasicFormField()
    var excerpt = BasicFormField()
    var content = BasicFormField()
    var categoryId = SelectionFormField()
    var authorId = SelectionFormField()
    var image = FileFormField()
    
    var notification: String?
    var contentModel: FrontendContentModel.ViewContext?

    func initialize() {
    }

    init() {
        self.initialize()
    }
    
    init(req: Request) throws {
        self.initialize()

        let context = try req.content.decode(Input.self)
        self.id = context.id.emptyToNil

        self.title.value = context.title
        self.excerpt.value = context.excerpt
        self.content.value = context.content
        self.categoryId.value = context.categoryId
        self.authorId.value = context.authorId

        self.image.delete = context.imageDelete ?? false
        if let image = context.image {
            if let data = image.data.getData(at: 0, length: image.data.readableBytes), !data.isEmpty {
                self.image.data = data
            }
        }
    }

    func read(from model: Model)  {
        self.id = model.id?.uuidString
        self.title.value = model.title
        self.image.value = model.imageKey
        self.excerpt.value = model.excerpt
        self.content.value = model.content
        self.categoryId.value = model.$category.id.uuidString
        self.authorId.value = model.$author.id.uuidString
    }
    
    func write(to model: Model) {
        model.title = self.title.value
        if !self.image.value.isEmpty {
            model.imageKey = self.image.value
        }
        model.excerpt = self.excerpt.value
        model.content = self.content.value
        model.$category.id = UUID(uuidString: self.categoryId.value)!
        model.$author.id = UUID(uuidString: self.authorId.value)!
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
        if self.title.value.isEmpty {
            self.title.error = "Title is required"
            valid = false
        }
        if UUID(uuidString: self.categoryId.value) == nil {
            self.categoryId.error = "Invalid category"
            valid = false
        }
        if UUID(uuidString: self.authorId.value) == nil {
            self.authorId.error = "Invalid author"
            valid = false
        }
        return req.eventLoop.future(valid)
    }
}
