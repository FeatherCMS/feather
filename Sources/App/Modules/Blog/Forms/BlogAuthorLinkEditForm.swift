//
//  BlogAuthorLinkEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

final class BlogAuthorLinkEditForm: ModelForm {

    typealias Model = BlogAuthorLinkModel

    struct Input: Decodable {
        var modelId: String
        var name: String
        var url: String
        var priority: String
        var authorId: String
    }

    var modelId: String? = nil
    var name = StringFormField()
    var url = StringFormField()
    var priority = StringFormField()
    var authorId: String! = nil
    var notification: String?
    
    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "name": name,
            "url": url,
            "priority": priority,
            "authorId": authorId,
            "notification": notification,
        ])
    }
        
    init() {
        initialize()
    }

    init(req: Request) throws {
        initialize()
        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
        name.value = context.name
        url.value = context.url
        priority.value = context.priority
        authorId = context.authorId
    }
    
    func initialize() {
        priority.value = String(100)
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if name.value.isEmpty {
            name.error = "Name is required"
            valid = false
        }
        if Validator.count(...250).validate(name.value).isFailure {
            name.error = "Name is too long (max 250 characters)"
            valid = false
        }
        if url.value.isEmpty {
            url.error = "Url is required"
            valid = false
        }
        if Validator.count(...250).validate(url.value).isFailure {
            url.error = "URL is too long (max 250 characters)"
            valid = false
        }
        if Int(priority.value) == nil {
            priority.error = "Invalid priority"
            valid = false
        }

        return req.eventLoop.future(valid)
    }
    
    func read(from input: Model)  {
        modelId = input.id?.uuidString
        name.value = input.name
        url.value = input.url
        priority.value = String(input.priority)
        authorId = input.$author.id.uuidString
    }

    func write(to output: Model) {
        output.name = name.value
        output.url = url.value
        output.priority = Int(priority.value)!
        output.$author.id = UUID(uuidString: authorId)!
    }
}
