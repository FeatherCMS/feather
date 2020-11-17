//
//  StaticPageEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import FeatherCore

final class StaticPageEditForm: Form {

    typealias Model = StaticPageModel

    struct Input: Decodable {
        var id: String
        var title: String
        var content: String
    }

    var id: String? = nil
    var title = StringFormField()
    var content = StringFormField()
    var notification: String?
    var metadata: Metadata?

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "title": title,
            "content": content,
            "notification": notification,
            "metadata": metadata,
        ])
    }

    init() {}
    
    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        id = context.id.emptyToNil
        title.value = context.title
        content.value = context.content
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true

        if title.value.isEmpty {
            title.error = "Title is required"
            valid = false
        }
        if Validator.count(...250).validate(title.value).isFailure {
            title.error = "Title is too long (max 250 characters)"
            valid = false
        }
        if content.value.isEmpty {
            content.error = "Content is required"
            valid = false
        }
        return req.eventLoop.future(valid)
    }

    func read(from input: Model)  {
        id = input.id?.uuidString
        title.value = input.title
        content.value = input.content
    }
    
    func write(to output: Model) {
        output.title = title.value
        output.content = content.value
    }
}
