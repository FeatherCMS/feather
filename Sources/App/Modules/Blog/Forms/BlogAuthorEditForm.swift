//
//  BlogAuthorEditForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import Vapor
import ViewKit

final class BlogAuthorEditForm: Form {

    typealias Model = BlogAuthorModel

    struct Input: Decodable {
        var id: String
        var name: String
        var bio: String

        var image: File?
        var imageDelete: Bool?
    }

    var id: String? = nil
    var name = BasicFormField()
    var bio = BasicFormField()
    var image = FileFormField()
    
    var contentModel: FrontendContentModel.ViewContext?
    var notification: String?

    init() {}
    
    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        self.id = context.id.emptyToNil
        
        self.name.value = context.name
        self.bio.value = context.bio

        self.image.delete = context.imageDelete ?? false
        if let image = context.image {
            if let data = image.data.getData(at: 0, length: image.data.readableBytes), !data.isEmpty {
                self.image.data = data
            }
        }
    }

    func read(from model: Model)  {
        self.id = model.id?.uuidString
        self.name.value = model.name
        self.image.value = model.imageKey
        self.bio.value = model.bio
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true

        if let data = self.image.data, data.isEmpty {
            self.image.error = "Image is required"
            valid = false
        }
        if self.name.value.isEmpty {
            self.name.error = "Name is required"
            valid = false
        }
        return req.eventLoop.future(valid)
    }

    func write(to model: Model) {
        model.name = self.name.value
        if !self.image.value.isEmpty {
            model.imageKey = self.image.value
        }
        if self.image.delete {
            model.imageKey = ""
        }
        model.bio = self.bio.value
    }
}
