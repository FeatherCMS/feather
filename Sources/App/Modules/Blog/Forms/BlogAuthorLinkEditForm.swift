//
//  BlogAuthorLinkEditForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import Vapor
import ViewKit

final class BlogAuthorLinkEditForm: Form {

    typealias Model = BlogAuthorLinkModel

    struct Input: Decodable {
        var id: String
        var name: String
        var url: String
        var priority: String
        var authorId: String
    }

    var id: String? = nil
    var name = BasicFormField()
    var url = BasicFormField()
    var priority = BasicFormField()
    var authorId: String! = nil

    var notification: String?
    
        
    init() {
        self.initialize()
    }

    init(req: Request) throws {
        self.initialize()

        let context = try req.content.decode(Input.self)
        self.id = context.id.emptyToNil

        self.name.value = context.name
        self.url.value = context.url
        self.priority.value = context.priority
        self.authorId = context.authorId
    }
    
    func initialize() {
        self.priority.value = String(100)

    }
    
    func read(from model: Model)  {
        self.id = model.id!.uuidString
        self.name.value = model.name
        self.url.value = model.url
        self.priority.value = String(model.priority)
        self.authorId = model.$author.id.uuidString
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if self.name.value.isEmpty {
            self.name.error = "Name is required"
            valid = false
        }
        if self.url.value.isEmpty {
            self.url.error = "Url is required"
            valid = false
        }
        if Int(self.priority.value) == nil {
            self.priority.error = "Invalid priority"
            valid = false
        }

        return req.eventLoop.future(valid)
    }
    
    func write(to model: Model) {
        model.name = self.name.value
        model.url = self.url.value
        model.priority = Int(self.priority.value)!
        model.$author.id = UUID(uuidString: self.authorId)!
    }
}
