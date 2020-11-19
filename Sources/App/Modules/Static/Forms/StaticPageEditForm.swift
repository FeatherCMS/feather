//
//  StaticPageEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import FeatherCore

final class StaticPageEditForm: ModelForm {

    typealias Model = StaticPageModel

    struct Input: Decodable {
        var modelId: String
        var title: String
        var content: String
    }

    var modelId: String? = nil
    var title = StringFormField()
    var content = StringFormField()
    var notification: String?
    var metadata: Metadata?

    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "title": title,
            "content": content,
            "notification": notification,
            "metadata": metadata,
        ])
    }

    init() {}
    
    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
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
        modelId = input.id?.uuidString
        title.value = input.title
        content.value = input.content
    }
    
    func write(to output: Model) {
        output.title = title.value
        output.content = content.value
    }
}
