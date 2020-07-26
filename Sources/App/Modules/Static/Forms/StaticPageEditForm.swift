//
//  StaticPageEditForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Vapor
import ViewKit

final class StaticPageEditForm: Form {

    typealias Model = StaticPageModel

    struct Input: Decodable {
        var id: String
        var title: String
        var content: String
    }

    var id: String? = nil
    var title = BasicFormField()
    var content = BasicFormField()
    
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
        self.content.value = context.content
    }

    func read(from model: Model)  {
        self.id = model.id?.uuidString
        
        self.title.value = model.title
        self.content.value = model.content
    }
    
    func write(to model: Model) {
        model.title = self.title.value
        model.content = self.content.value
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true

        if self.title.value.isEmpty {
            self.title.error = "Title is required"
            valid = false
        }
        if self.content.value.isEmpty {
            self.content.error = "Content is required"
            valid = false
        }
        return req.eventLoop.future(valid)
    }
}
