//
//  BlogCategoryEditForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 22..
//

import FeatherCore

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
    var title = StringFormField()
    var excerpt = StringFormField()
    var priority = StringFormField()
    var image = FileFormField()
    var metadata: Metadata?
    var notification: String?

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "title": title,
            "excerpt": excerpt,
            "priority": priority,
            "image": image,
            "metadata": metadata,
            "notification": notification,
        ])
    }

    init() {
        initialize()
    }

    init(req: Request) throws {
        initialize()

        let context = try req.content.decode(Input.self)
        id = context.id.emptyToNil
        title.value = context.title
        priority.value = context.priority
        excerpt.value = context.excerpt
        image.delete = context.imageDelete ?? false
        if let img = context.image, let data = img.data.getData(at: 0, length: img.data.readableBytes), !data.isEmpty {
            image.data = data
        }
    }
    
    func initialize() {
        priority.value = String(100)
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if title.value.isEmpty {
            title.error = "Title is required"
            valid = false
        }
        if Int(priority.value) == nil {
            priority.error = "Invalid priority value"
            valid = false
        }
        if excerpt.value.isEmpty {
            excerpt.error = "Excerpt is required"
            valid = false
        }
        return req.eventLoop.future(valid)
    }
    
    func read(from input: Model)  {
        id = input.id!.uuidString
        title.value = input.title
        priority.value = String(input.priority)
        excerpt.value = input.excerpt
        image.value = input.imageKey
    }

    func write(to output: Model) {
        output.title = title.value
        output.priority = Int(priority.value)!
        output.excerpt = excerpt.value
        if !image.value.isEmpty {
            output.imageKey = image.value
        }
        if image.delete {
            output.imageKey = ""
        }
    }
}
