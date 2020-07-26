//
//  BlogCategoryEditForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 22..
//

import Vapor
import ViewKit

final class BlogCategoryEditForm: Form {

    typealias Model = BlogCategoryModel

    struct Input: Decodable {
        var id: String
        var title: String
        var excerpt: String
        var priority: String

        var image: File?
        var imageDelete: Bool?
    }

    var id: String? = nil
    var title = BasicFormField()
    var excerpt = BasicFormField()
    var priority = BasicFormField()
    var image = FileFormField()
    
    var contentModel: FrontendContentModel.ViewContext?
    var notification: String?
        
    init() {
        self.initialize()
    }

    init(req: Request) throws {
        self.initialize()

        let context = try req.content.decode(Input.self)
        self.id = context.id.emptyToNil
        
        self.title.value = context.title
        self.priority.value = context.priority
        self.excerpt.value = context.excerpt

        self.image.delete = context.imageDelete ?? false
        if let image = context.image {
            if let data = image.data.getData(at: 0, length: image.data.readableBytes), !data.isEmpty {
                self.image.data = data
            }
        }
    }
    
    func initialize() {
        self.priority.value = String(100)
    }
    
    func read(from model: Model)  {
        self.id = model.id!.uuidString
        self.title.value = model.title
        self.priority.value = String(model.priority)
        self.excerpt.value = model.excerpt
        self.image.value = model.imageKey
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if self.title.value.isEmpty {
            self.title.error = "Title is required"
            valid = false
        }
        if Int(self.priority.value) == nil {
            self.priority.error = "Invalid priority value"
            valid = false
        }
        if self.excerpt.value.isEmpty {
            self.excerpt.error = "Excerpt is required"
            valid = false
        }
        return req.eventLoop.future(valid)
    }
    
    func write(to model: Model) {
        model.title = self.title.value
        model.priority = Int(self.priority.value)!
        model.excerpt = self.excerpt.value
        if !self.image.value.isEmpty {
            model.imageKey = self.image.value
        }
        if self.image.delete {
            model.imageKey = ""
        }
    }
}
